Here's a more polished and organized description for your **Bubbly Chatting App**:

---

# Bubbly Chatting App

**Bubbly Chatting App** is a modern, Flutter-based messaging application that supports real-time communication between users. It leverages **Firebase** for backend services and **Firebase Cloud Messaging (FCM)** for push notifications.

---

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

- **`main.dart`**: The main entry point of the app. Responsible for initializing Firebase, FCM, and setting up routes for navigation.
  
- **`views/pages/`**: Contains the app’s main screens:
  - `SplashScreen`: Displays the app's loading screen.
  - `LoginPage`: Handles user authentication.
  - `HomePage`: Displays user chats and provides navigation options.
  - `ChatPage`: Manages chat conversations between users.

- **`helper/`**: Contains utility classes:
  - `LNotificationHelper`: Manages push notifications and handles local notifications.

- **`components/`**: Reusable UI components:
  - `MyLightTheme`: Defines the custom light theme for the app.

---

## **Firebase Cloud Messaging (FCM)**

- **Push Notifications** are powered by **Firebase Cloud Messaging (FCM)**.
- The app handles background messages with the `backgroundMessageHandler` function.
- It listens for incoming notifications using:
  - **`FirebaseMessaging.onMessage`**: Handles foreground notifications.
  - **`FirebaseMessaging.onBackgroundMessage`**: Handles background notifications.

---

By following this structure, the app offers a seamless real-time chatting experience, with a clean and manageable codebase.

