# Event Planner

A social event planning app built with Flutter and Firebase. Users create events, add friends by username, and invite them as participants, with a custom neo brutalist design system and peruser Firestore security rules.

> A self taught side project, built to learn Flutter and Firebase end to end, from auth flows through to production security rules.

---


## Features

**Authentication**
- Email/password registration and sign in via Firebase Auth
- Mandatory email verification before app access
- Password reset by email
- Auth state gate,the app routes to home or login based on a live `authStateChanges()` stream, so a signed-in user skips the login screen
- Unique usernames, enforced with a pre-registration availability check

**Friends**
- Search for users by username
- Send, accept, and decline friend requests
- Friendships are written atomically to both users in a single Firestore transaction, so a half created friendship is impossible

**Events**
- Create events with name, date, time, venue, and description
- Select participants from your friends list
- Separate upcoming and past event views, driven by Firestore queries on event date
- Event owners can view details and delete

**Account**
- Profile with avatar (15 presets), username, and email
- Full account deletion, cascades through Firestore data before removing the Auth user

---

## Tech Stack

| | |
|---|---|
| Framework | Flutter (Dart) |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| State | `StatefulWidget` + `StreamBuilder` / `FutureBuilder` |

No state management package, the app relies on Firestore streams as the source of truth, with widget local state for forms.

---

## Architecture

```
lib/
├── main.dart              # App entry, routes, auth state gate
├── theme.dart             # Design system: colors, ThemeData, shared widgets
├── account_service.dart   # Cascading account deletion
│
├── login.dart             # Sign in
├── register.dart          # Sign up + avatar picker + username validation
├── emailverify.dart       # Email verification gate
├── forgotPW.dart          # Password reset
│
├── home.dart              # Upcoming / past events
├── add.dart               # Create event, pick participants
│
├── friends.dart           # Friends list
├── invite.dart            # Search users, send requests
├── requests.dart          # Incoming requests, accept/decline
│
├── profile.dart           # User profile
└── setting.dart           # Privacy policy, account deletion, logout
```

### Design system

`theme.dart` holds a neo-brutalist design language — hard black borders, zero-blur offset shadows, flat colors — exposed as `ThemeData` plus reusable widgets:

- `BrutalField` — text input with validation
- `BrutalDateField` — date picker field
- `BrutalButton` — primary action button
- `FriendTile` — friend / request row with contextual actions
- `DisplayEvent` — event list panel, filtered by upcoming or past

### Data model

```
users/{uid}
  username, email, DateOfBirth, gender, avatarId, createdAt

users/{uid}/friends/{friendUid}
  uid, username, addedAt

publicProfiles/{uid}
  username, avatarId

friend_requests/{requestId}
  fromUid, toUid, status, createdAt

events/{eventId}
  ownerId, name, description, venue, date,
  participantid[], participantsnames[], createdAt
```

**Why `publicProfiles` is separate:** Firestore security rules cannot restrict access to individual fields — a document is readable in full or not at all. Locking `users/{uid}` to its owner is correct for email, date of birth, and gender, but it also makes username search impossible. Splitting the two publicly-needed fields into their own collection keeps friend search working without exposing personal data.

### Security rules

Firestore rules are version-controlled in [`firestore.rules`](firestore.rules). Summary:

- `users/{uid}` — readable and writable only by the owner
- `publicProfiles/{uid}` — world-readable (username lookup runs before sign-in), writable only by the owner
- `users/{uid}/friends/{friendId}` — writable by either party, so accepting a request can write both sides
- `events/{id}` — readable only by listed participants; `ownerId` is validated on create so it cannot be forged; only the owner can update or delete
- `friend_requests/{id}` — visible only to sender and recipient

---

## Setup

**Prerequisites:** Flutter SDK (3.10+), a Firebase project, and the FlutterFire CLI.

```bash
git clone https://github.com/Manpriya-Lax/Event-Planner.git
cd Event-Planner/eventplanner
flutter pub get
```

Firebase config files are intentionally excluded from version control, so you'll need to generate your own:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This creates `lib/firebase_options.dart` and `android/app/google-services.json`.

In the Firebase console, enable **Email/Password** authentication and create a **Cloud Firestore** database, then deploy the rules:

```bash
firebase deploy --only firestore:rules
```

Firestore will prompt you to create composite indexes the first time you load the events screen — follow the link in the console error to create them.

```bash
flutter run
```

---

## Known Limitations

Things I'm aware of and would address next:

- **Leaving others' events** — deleting your account removes events you own, but your UID remains in events owned by other users. Fixing this properly needs a Cloud Function with admin privileges.
- **Duplicate friend requests** — sending the same request twice isn't blocked at the app level.
- **Exact-match search** — username search requires the full string. Prefix search would need a denormalized search field or an external index such as Algolia.
- **No offline support** — Firestore persistence is explicitly disabled.
- **No tests** — the widget test is still the generated default.
- **Settings is minimal** — currently policy links, logout, and account deletion only.

---

## License

MIT
