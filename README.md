# SU Learning Companion (Project Title / Mobile Application Name)

### Description  
SU Learning Companion is a mobile application built specifically for Sabancı University students to simplify their academic organization and study routines.
University students often struggle to manage deadlines, track assignments, and keep up with study sessions across multiple platforms — using a mix of calendars, notes apps, messaging groups, and reminders. This constant switching between tools leads to disorganization, missed deadlines, and reduced study efficiency.

SU Learning Companion solves this by bringing all essential academic tools into one unified platform. The app combines a course dashboard, assignment tracking, study timers, flashcards, and note-taking features — giving students a centralized and structured way to manage their academic life.

### Main Purpose — Problem the App Solves  
Students often rely on multiple apps to manage tasks, deadlines, and study plans, which leads to confusion and missed work.  
This app solves that problem by centralizing all academic tools and providing one organized, simple-to-use system.

## How We Met the Key Requirements

| Requirement | How We Fulfill It |
|-------------|--------------------|
| **Named Routes** | All screens use named/structured routes via `GoRouter`, defined in `AppRouter` and all features routers, etc.). Initial route is `/welcome`. |
| **Utility Classes** | Centralized styling using utility files: `app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart` , `data_formatters.dart` — used consistently across all features. |
| **Images (Asset + Network)** | Used asset image (`sabanci_logo.jpeg`) in HomeScreen and network image in welcome screens. |
| **Custom Font** | External fonts (Poppins, Orbitron) added via `pubspec.yaml` and applied globally using `fontFamily: 'AppFont'`. |
| **Card & List + Delete** | `ExamsListScreen`, `HomeworksListScreen`, `ResourcesListScreen`, `NotesListScreen`, and `FlashcardsListScreen` use **Card widgets** linked to model classes, with delete functionality (dynamic list update). |
| **Form Validation + AlertDialog** | Multiple forms (Exams, Homeworks, Notes, Flashcards, Resources, Signup, Login) use **Form + TextFormField validators**, show **inline error text**, and display **AlertDialog if invalid**. |
| **Responsiveness** | Scrollable layouts using `SingleChildScrollView`, `Expanded`, and `Flexible` ensure proper behavior across device sizes and orientations. |


## 🧭 Basic Navigation Flow

1. **Welcome Screen** → Login or Sign Up  
2. After login → **Home Screen**  
   - View courses, reminders, add a course  
   - Bottom navigation: **Home – Calendar – Profile**  
3. Open any course (click on any course) → **Course Details Screen**  
   - Access features: Exams, Homeworks, Notes, Resources, Flashcards  
4. Each feature supports:
   - List view (Card/ListTile)
   - Add new item (form with validation + AlertDialog)
   - Delete/edit (where applicable)  
5. **Calendar Screen** shows cross-course deadlines/events  
6. **Profile Screen** shows user info + Logout
    
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















