# 📱 Aqar Morocco Mobile (Flutter)

This is the mobile application for the Aqar Morocco real estate platform.

## 🚀 Getting Started

Since the source code was generated manually, you need to follow these steps to run it:

1. **Install Flutter**: Make sure you have the Flutter SDK installed on your machine.
2. **Setup Project**:
   ```bash
   cd aqar_morocco_mobile
   flutter pub get
   ```
3. **Configure API**:
   - Open `lib/core/network/api_client.dart`
   - Change `baseUrl` to your Render.com URL (e.g., `https://aqar-morocco.onrender.com/api`).

4. **Run App**:
   ```bash
   flutter run
   ```

## 🏗️ Folder Structure
- `lib/core`: Theme, Networking, Constants.
- `lib/data`: Models and JSON mapping.
- `lib/providers`: State management (Auth, Listings).
- `lib/ui`: Screens and Widgets.

## 📂 Deployment to GitHub
1. Create a new repository on GitHub.
2. Push the folders `aqar-morocco`, `aqar-morocco-admin`, and `aqar_morocco_mobile`.
3. Link `aqar-morocco` to **Render.com** (Web Service).
4. Link `aqar-morocco-admin` to **Vercel** or **Render.com** (Static Site/Web Service).
