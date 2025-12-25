# SU Learning Companion (Project Title / Mobile Application Name)

### Description  
SU Learning Companion is a mobile application built specifically for Sabancı University students to simplify their academic organization and study routines.
University students often struggle to manage deadlines and track assignments— using a mix of calendars, notes apps, exams, flashcards, and reminders. This constant switching between tools leads to disorganization, missed deadlines, and reduced study efficiency.

SU Learning Companion solves this by bringing all essential academic tools into one unified platform. The app combines a course dashboard, assignment tracking, study timers, flashcards, and note-taking features — giving students a centralized and structured way to manage their academic life.

### Main Purpose — Problem the App Solves  
Students often rely on multiple apps to manage tasks, deadlines, and study plans, which leads to confusion and missed work.  
This app solves that problem by centralizing all academic tools and providing one organized, simple-to-use system.

### Motivation
Our motivation behind **SU Learning Companion** was to create a meaningful improvement in the daily academic lives of Sabancı University students. We observed that students often rely on scattered tools—calendars, note apps, messaging platforms, and reminders—which leads to disorganization, missed deadlines, and inefficient study habits. We wanted to change that by designing a **single, mobile-first solution** that brings everything together in one place.  

By centralizing courses, exams, homework, notes, resources, flashcards, and schedules into a unified application, our goal is to help students study more effectively, stay organized, and ultimately **perform better academically and achieve higher grades**. SU Learning Companion is built not just as an app, but as a practical academic assistant that supports students throughout their semester and helps them focus on what truly matters—learning and success.

## Firebase Backend & State Management
Step 3 transforms the Step 2 UI prototype into a **fully functional, data-driven application** by integrating **Firebase Authentication**, **Cloud Firestore**, **Provider-based state management**, and **local persistence**.

The application now supports **multi-user authentication**, **secure real-time data synchronization**, **user-specific data isolation**, and **persistent preferences**, creating a fast and professional user experience.

## Team Contribution

All team members worked on **both frontend and backend aspects**, contributing beyond their primary feature areas.

| Member | Frontend Contributions | Backend & Database Contributions |
|------|------------------------|----------------------------------|
| **Abdallah Al Homsi** | Exams UI, Homeworks UI, edit & form screens | Designed Firestore structure for exams & homeworks, implemented full CRUD, enforced `createdBy` & `createdAt`, integrated Provider for real-time updates |
| **Fowzi Hindi** | Flashcards UI (groups & questions), navigation | Implemented Firestore subcollections for flashcards, ownership enforcement, delete restrictions, Provider integration |
| **Syeda Manaal Amir** | Calendar UI, course feature integration | Connected calendar to Firestore-driven deadlines and ensured real-time updates |
| **Abdul Momin Alam** | Notes UI, list & edit screens | Implemented Firestore streams for notes, Provider state handling (loading, error, success) |
| **Salma Tubail** | Resources UI, Add Course screen | Designed global resources Firestore model, enforced read-only access for non-owners |
| **Rand M O Khaled** | Welcome, Login, Signup UI | Implemented Firebase Authentication, auth guards, Provider-based auth state affecting the entire app |

All contributions, code changes, and cross-feature collaboration **can be verified in the GitHub commit history**, showing that each member worked across multiple parts of the application — not only on their assigned screens. Meaning that the Main Feature Contribution is not the only thing each member contributed in as there are various parts of the project in which we all contributed to. 
All backend operations are implemented through **repository and provider layers**.  
No UI widget accesses Firestore directly.

## Firestore Architecture & Data Storage
The app uses **Cloud Firestore** as its primary backend database.
### Data Structure
- Each authenticated user has a private document under `/users/{uid}`.
- All personal academic data (courses, exams, homeworks, notes, flashcards) is stored **inside the user’s space**, ensuring users can only access their own data.
- Course **resources are stored globally** under `/courses/{courseId}/resources` so all students can view shared materials.
- Every Firestore document includes:
  - a unique document ID (Firestore auto-generated)
  - feature-specific fields (title, date, content, etc.)
  - `createdBy` (user UID)
  - `createdAt` timestamp

### Firestore Document Requirements
Every document includes:
- **Unique document ID**
- **Feature-specific fields** (title, date, content, difficulty, etc.)
- **createdBy** → Firebase user UID
- **createdAt** → Firestore timestamp

### Real-Time Updates
- Firestore **streams** are used for exams, homeworks, notes, flashcards, and resources.
- Any create, update, or delete operation is reflected instantly in the UI.

### Security
- Users can only read/write their own data.
- Resources are **globally readable** but **only editable/deletable by their creator**.
- All access requires authentication.

### Testing
To ensure correctness and reliability, we added automated Flutter tests including **2 unit tests** and **1 widget test**.

### How to Run Tests

From the project root, run:

```bash
flutter test
```
### Implemented Tests

### 1) Unit Test — ThemeProvider default is Light
Type: Unit test
File: test/unit/theme_provider_default_test.dart
What it checks:
The app theme defaults to Light Mode when a user is new / not logged in.
ThemeProvider initializes correctly with the expected default state.

### 2) Unit Test — ThemeProvider toggle + persistence (per-user)
Type: Unit test
File: test/unit/theme_provider_toggle_test.dart
What it checks:
Theme toggling works (Light ↔ Dark).
The theme value is persisted using SharedPreferences.
The theme is stored per authenticated user, so one user’s dark mode does not affect another user.
When logged out, theme is forced back to Light Mode (in the Login but when user is logged in again it is still Dark).

### 3) Widget Test — Notes screen renders essential UI
Type: Widget test
File: test/widget/notes_list_screen_empty_test.dart
What it checks:
The Notes screen builds correctly.
Core UI elements exist.
Prevents UI regressions that could block authentication flow.

### Known Limitations / Bugs
No known critical limitations or bugs at the time of submission.

No known critical limitations or bugs at the time of submission.

Core requirements were validated through manual testing + automated tests:

Authentication (signup, login, logout)

Firestore CRUD + real-time updates

Provider-based state management

SharedPreferences theme persistence
## How We Met the Requirements

| Requirement / Rubric Item | Implementation |
|---------------------------|----------------|
| Firebase setup & connection | Firebase initializes correctly and connects without runtime errors |
| User authentication | Email/password signup, login, logout with user-friendly error handling |
| Firestore data modeling | Structured collections per feature with ownership & timestamps |
| Model classes | Dart models accurately reflect Firestore documents |
| Repository layer | All Firestore operations go through repositories |
| Provider state management | MultiProvider with ChangeNotifier for auth and core data |
| Auth-based navigation | Logged-out users see auth screens; logged-in users see main app |
| Real-time UI updates | Firestore streams update UI automatically |
| Local persistence | Theme preference stored and restored via SharedPreferences |
| Firestore security rules | Prevent unauthenticated access and enforce user ownership |

### 1. Firebase Authentication
- Implemented **email/password sign-up, login, and logout** using Firebase Authentication.
- Navigation is protected with **authentication-based routing**:
  - Logged-out users can only access login and signup screens.
  - Logged-in users are redirected to the main app.
- Authentication errors (invalid credentials, network issues) are handled and displayed with **user-friendly messages**.

---

### 2. Cloud Firestore Database
- All dynamic app data is stored in **Cloud Firestore**.
- Each feature supports **full CRUD operations** (create, read, update, delete).
- Data is loaded using **Firestore streams**, enabling **real-time UI updates**.
- Firestore security rules restrict users to **their own data**, while allowing controlled access to shared resources.

---

### 3. State Management (Provider)
- The app uses **Provider with ChangeNotifier** to manage:
  - Authentication state (logged in/out)
  - Feature data (lists, loading states, errors)
- The UI reacts automatically when:
  - A user logs in or logs out
  - Firestore data changes
- Shared state is accessed via providers, avoiding deep constructor passing.

---

### 4. Local Persistence
- The app persists the **theme preference (light/dark mode)** using SharedPreferences.
- The selected theme is restored automatically when the app restarts.
## Demo Video Script

1. **User 1 – First-Time Signup**
   - Open the app
   - Sign up with email & password
   - App redirects automatically to Home Screen

2. **User 1 – Course Setup**
   - Add a course
   - Open the course
   - For each feature:
     - **Exams** → add, edit, delete
     - **Homeworks** → add, edit, delete
     - **Notes** → add, edit, delete
     - **Flashcards** → add group, add question, delete
     - **Resources** → add and edit (allowed only for the creator)

3. **User 1 – Navigation**
   - Open Calendar (shows aggregated deadlines)
   - Return to Home Screen
   - Edit profile information
   - Log out

4. **User 2 – Existing User**
   - Log in
   - Dark theme is automatically restored (SharedPreferences)

5. **Data Isolation & Security**
   - Open the same course
   - Show that:
     - Exams, homeworks, notes, and flashcards from User 1 are **not visible**
     - Resources are visible but **cannot be edited or deleted** (not the owner)

6. **Persistence Demo**
   - Close the app
   - Reopen the app
   - User is still logged in
   - App opens directly to Home Screen
    
### 1. First-time setup (cloning the repo)

```bash
# Clone the repository
git clone https://github.com/abdallahalhomsi/SU-Learning-Companion.git

# Download Flutter dependencies
flutter pub get
```
### 2. Running the App

Start an Android emulator or connect a physical device.

In Android Studio, select the device in the top-right device selector.

run in terminal:
```bash
flutter run
```

### 3. Workflow for each team member

```bash
# 1. Make sure you are on the correct branch (usually main or your feature branch)
git status
git branch

# 2. Get the latest changes from GitHub
git pull origin main
```

### 4. Committing Changes

```bash
# See what changed
git status

# Add the files you modified
git add .

# Commit with a clear message
git commit -m "Describe what you implemented"

# Push your changes to GitHub
git push origin main      # or your feature branch
```

### Group Members & Roles  

| Name | Student ID | Role | 
|------|-------------|------|
| **Abdallah Al Homsi** | 34565 | Project Coordinator |
| **Fowzi Hindi** | 33587 | Learning & Research Lead |
| **Syeda Manaal Amir** | 33550 | Integration & Repository Lead  |
| **Abdul Momin Alam** | 33622 | Documentation & Submission Lead  |
| **Salma Tubail** | 33749 | Presentation & Communication Lead  |
| **Rand M O Khaled** | 35003 | Testing & Quality Assurance Lead  |

### Contact  
For questions or updates about the project, please contact the team via their **Sabancı University emails**.
Team communication, coordination, and **task assignments are managed through Jira**, ensuring efficient collaboration and workflow tracking.















