DRUG APP — AI AGENTS GUIDE
## Project Overview

This is a Flutter app for pet owners.

Main idea:
An ecosystem app where users can:

manage pet health
store vaccine and treatment records
keep medical information
later book pet services
later use AI for recommendations and document parsing

## Tech Stack
Flutter (Dart)
Supabase (planned)
UI-first development approach

## Project Structure

lib/
screens/
profile/
vaccines/
vaccines_screen.dart
add_record_screen.dart
treatment_form_screen.dart
vaccination_form_screen.dart
health_screen.dart
profile_screen.dart
home/
ai/
models/
services/
widgets/

## How to Run

flutter pub get
flutter run

For Chrome:
flutter run -d chrome

## Navigation Flow

health_screen
→ vaccines_screen
→ add_record_screen
→ treatment_form_screen
→ vaccination_form_screen

## UI Rules
Use soft rounded containers
Border radius usually 14–18
Background color: #F7F9F7
Accent color: #F0B63F
Selected color: #BEE7DF
Keep UI minimal, clean, soft
Avoid default Flutter look when possible
Reuse current design patterns   

## Current Screens
health_screen.dart
vaccines_screen.dart
add_record_screen.dart
treatment_form_screen.dart
vaccination_form_screen.dart

## Current Features
Navigation from health → vaccines
Add record flow
Treatment form UI
Vaccination form UI

## Rules for AI Agents
Do not break navigation
Do not rename files
Do not duplicate screens
Prefer editing existing widgets
Keep code simple
Preserve UI style
Build UI → logic → backend

## Next Steps
Add history cards to vaccines_screen
Add local save logic
Connect Supabase
Add document scanning
Add AI parsing

## Notes

Project is evolving.
Keep solutions simple and scalable.