# Chattbox

**Chattbox** is a modern, Flutter-based messaging application that enables real-time communication between users. It leverages **Firebase** for backend services and **Firebase Cloud Messaging (FCM)** for push notifications.

![1](https://github.com/user-attachments/assets/b45feb57-5ca0-4913-ab97-4d68c420c96c)
![2](https://github.com/user-attachments/assets/c4730554-4a4a-43d1-b0f1-03d839f71e9c)
![3](https://github.com/user-attachments/assets/e6ce6c1e-a197-49f2-b3ae-89610768cf62)
![4](https://github.com/user-attachments/assets/b09d07d2-97dd-4c9c-ab44-1685baae9b5e)
![5](https://github.com/user-attachments/assets/237a0e56-1d51-4f3e-ac05-e1577a3ed031)


## **Features**

- **Real-time Messaging**: Instantly send and receive messages with other users.
- **Push Notifications**: Stay notified with messages using **Firebase Cloud Messaging (FCM)** for both foreground and background notifications.
- **Customizable Light Theme**: Personalize your experience with a custom light theme.
- **Multiple Pages**: 
  - **Splash Screen**: A welcome screen when the app starts.
  - **Login Screen**: Sign in or sign up for an account.
  - **Home Screen**: Overview of chats and navigation options.
  - **Chat Screen**: View and send messages in a conversation.

---

## **Getting Started**

### **Installation**
To run the app on your device or emulator:
1. Install all dependencies by running:
   ```bash
   flutter pub get
   ```
2. Start the app with:
   ```bash
   flutter run
   ```

---

## **Code Structure**

## **`lib/`**
The main directory containing all source files of the Flutter app.

### **`utils/`**
This folder contains utility/helper classes for Firebase authentication, Firestore operations, FCM notifications, and local notifications.
- **`Auth_Helper.dart`**: Manages Firebase authentication operations.
- **`FCM_noti_Helper.dart`**: Handles Firebase Cloud Messaging (FCM) for push notifications.
- **`FireStore.dart`**: Contains Firestore database interactions and operations.
- **`Local_Notification_Helper.dart`**: Manages local notifications within the app.

### **`view/`**
Contains the main screens and components of the application.

#### **`view/Compont/`**
Reusable components for building UI elements.
- **`dra.dart`**: Likely a component used for drawing UI or rendering specific elements.
- **`ChatPage.dart`**: Handles user chat conversations.
  
#### **Main Screens**
- **`HomePage.dart`**: Displays the home screen where users can access chats and navigate to other sections.
- **`LoginPage.dart`**: Manages user authentication and login functionality.
- **`SignUpPage.dart`**: Manages user registration.
- **`SplashScreen.dart`**: Displays a loading screen when the app starts.

### **`firebase_options.dart`**
Configuration file for Firebase initialization.

### **`main.dart`**
The main entry point of the application. Initializes Firebase, sets up push notifications, and defines app routes.

---

## **Firebase Cloud Messaging (FCM)**

- **Push Notifications** are powered by **Firebase Cloud Messaging (FCM)**.
- The app handles background messages with the `backgroundMessageHandler` function.
- It listens for incoming notifications using:
  - **`FirebaseMessaging.onMessage`**: Handles foreground notifications.
  - **`FirebaseMessaging.onBackgroundMessage`**: Handles background notifications.

