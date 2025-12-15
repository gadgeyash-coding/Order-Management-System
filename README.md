# Order Management System (Flutter)

A Flutter-based Order Management System developed using **GetX** and **MVVM architecture**.  
This project is created as a technical POC to demonstrate clean architecture, state management, and backend integration.

---

## Features

- Firebase Authentication (Email & Password)
- Fetch Orders from Firestore
- Create, Update & Delete Orders
- Real-time UI updates using GetX
- Loader & error handling
- Refresh data from server
- Responsive UI (Android & iOS)

---

## Architecture

This project follows **MVVM architecture** using **GetX**.

### Structure
- View → UI layer
- Controller → Business logic
- Service → Firebase operations
- Model → Data representation
- Binding → Dependency injection

---

## State Management

- GetX
    - Reactive state using `Rx`
    - Dependency injection with `Bindings`
    - Navigation using Get routes

---

## Backend

- Firebase
    - Firebase Authentication
    - Cloud Firestore for order management

---

## Setup Instructions

1. Create Firebase project
2. Enable Auth (Email/Password) & Firestore
3. Add android/app/google-services.json & iOS config
4. Run `flutter pub get`
5. Run app


### Firebase Setup

1. Add google-services.json (Android)

2. Add GoogleService-Info.plist (iOS)

3. Enable Email/Password authentication

4. Create Firestore collection: orders

### 1. Clone Repository
```bash
git clone https://github.com/gadgeyash-coding/Order-Management-System.git

