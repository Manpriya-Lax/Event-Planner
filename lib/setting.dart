import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventplanner/theme.dart';
import 'package:eventplanner/account_service.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingsState();
}

class _SettingsState extends State<Setting> {
  // TODO: replace with your real published URLs before submitting to Play.
  static const String privacyPolicyUrl =
      "https://your-username.github.io/eventplanner/privacy.html";
  static const String deletionRequestUrl =
      "https://your-username.github.io/eventplanner/delete-account.html";

  static const String appVersion = "1.0.0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: const Text("Settings"),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _tile(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            onTap: () => _showLink("Privacy Policy", privacyPolicyUrl),
          ),
          const SizedBox(height: 12),

          _tile(
            icon: Icons.link_outlined,
            title: "Request Account Deletion (Web)",
            onTap: () => _showLink("Account Deletion", deletionRequestUrl),
          ),
          const SizedBox(height: 12),

          _tile(
            icon: Icons.logout,
            title: "Logout",
            onTap: () async {
              final navigator = Navigator.of(context);
              await FirebaseAuth.instance.signOut();
              navigator.pushNamedAndRemoveUntil("/login", (route) => false);
            },
          ),
          const SizedBox(height: 12),

          _tile(
            icon: Icons.delete_forever,
            title: "Delete Account",
            color: AppColors.primary,
            onTap: _confirmDelete,
          ),

          const SizedBox(height: 30),
          Center(
            child: Text(
              "Version $appVersion",
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.ink, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.ink,
              offset: Offset(5, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.ink),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.ink),
          ],
        ),
      ),
    );
  }

  /// No url_launcher dependency: show the URL and let the user copy it.
  /// If you add url_launcher later, swap this for launchUrl().
  void _showLink(String title, String url) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.ink, width: 3),
        ),
        title: Text(title),
        content: SelectableText(url),
        actions: [
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(dialogContext);
              await Clipboard.setData(ClipboardData(text: url));
              messenger.showSnackBar(
                const SnackBar(content: Text("Link copied")),
              );
            },
            child: const Text("Copy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final passwordController = TextEditingController();
    bool isDeleting = false;
    String? errorText;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppColors.ink, width: 3),
              ),
              title: const Text("Delete account?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "This permanently deletes your profile, friends, "
                    "friend requests and the events you created. "
                    "This cannot be undone.",
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    enabled: !isDeleting,
                    decoration: InputDecoration(
                      hintText: "Enter your password to confirm",
                      errorText: errorText,
                    ),
                  ),
                  if (isDeleting) ...[
                    const SizedBox(height: 16),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                      isDeleting ? null : () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () async {
                          if (passwordController.text.isEmpty) {
                            setDialogState(
                                () => errorText = "Password required");
                            return;
                          }

                          setDialogState(() {
                            isDeleting = true;
                            errorText = null;
                          });

                          final navigator = Navigator.of(context);

                          try {
                            await AccountService.deleteAccount(
                              password: passwordController.text,
                            );

                            navigator.pushNamedAndRemoveUntil(
                              "/login",
                              (route) => false,
                            );
                          } on FirebaseAuthException catch (e) {
                            setDialogState(() {
                              isDeleting = false;
                              errorText = e.code == 'wrong-password' ||
                                      e.code == 'invalid-credential'
                                  ? "Incorrect password"
                                  : (e.message ?? "Could not delete account");
                            });
                          } catch (e) {
                            setDialogState(() {
                              isDeleting = false;
                              errorText = "Could not delete account: $e";
                            });
                          }
                        },
                  child: const Text(
                    "Delete",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    passwordController.dispose();
  }
}
