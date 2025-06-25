# Daily Planner App

A Flutter mobile application designed to help users organize their daily activities with ease. This app enables users to create a to-do list, mark tasks as completed, and categorize each activity based on time and type.

## Features

### Activity Management
- Add daily activities with specific time and category
- Mark activities as completed when done
- Edit or delete existing activities
- Filter activities by date and completion status

### User Authentication (via Supabase)
- Sign Up with email, password, and name
- Sign In with email and password
- Sign Out functionality
- Input validation and error messaging

### Cloud Database Integration
- Secure storage of user data using Supabase
- Activities are saved and fetched based on user ID
- Offline support with local storage using Hive

### Session Persistence
- User login sessions stored locally using Hive
- Automatic login on app relaunch if a session exists

### Get Started Screen
- Onboarding screens for first-time users
- Skips to login or home screen for returning users

### Clean UI and Navigation
- Material Design 3 with custom theme
- Intuitive navigation using GoRouter
- State management with Provider

## Setup Instructions

1. Clone the repository
2. Update the Supabase credentials in `lib/config/app_config.dart`
   ```dart
   static const String supabaseUrl = 'YOUR_SUPABASE_URL';
   static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```
3. Create the necessary tables in your Supabase project:

   **Activities Table:**
   ```sql
   CREATE TABLE activities (
     id UUID PRIMARY KEY,
     title TEXT NOT NULL,
     description TEXT,
     time TIMESTAMP WITH TIME ZONE NOT NULL,
     category TEXT NOT NULL,
     is_completed BOOLEAN DEFAULT FALSE,
     user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- Add RLS (Row Level Security) policy
   ALTER TABLE activities ENABLE ROW LEVEL SECURITY;
   CREATE POLICY "Users can only access their own activities" ON activities
     FOR ALL USING (auth.uid() = user_id);
   ```

4. Run the app:
   ```
   flutter pub get
   flutter run
   ```

## Project Structure

- `/lib/config` - Application configuration
- `/lib/models` - Data models
- `/lib/providers` - State management
- `/lib/screens` - UI screens
- `/lib/services` - Business logic and API services
- `/lib/utils` - Utility functions
- `/lib/widgets` - Reusable UI components

## Technologies Used

- **Flutter** - UI framework
- **Provider** - State management
- **Supabase** - Backend and authentication
- **Hive** - Local storage
- **GoRouter** - Navigation

## License

This project is for educational purposes and part of a university assignment.
