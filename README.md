
# EaQue Client

## Overview
EaQue Client is the frontend component of the AI-powered data query interface project. It is built using Flutter and provides an intuitive interface for users to interact with the AI-powered backend to query data.

## Features
- User-friendly interface for data queries
- Real-time responses from the backend
- Cross-platform support (Android and Web)

## Tech Stack
- Flutter
- Dart
- Firebase (for authentication and storage)

## Prerequisites
- Flutter (>=2.x)
- Dart (>=2.12)

## Getting Started

### Clone the Repository
```sh
git clone https://github.com/Mehak1524/EaQue_Client.git
cd EaQue_Client
```

### Install Dependencies
```sh
flutter pub get
```

### Environment Variables
Create a `lib/.env` file and add the following environment variables:
```
FIREBASE_API_KEY=your_firebase_api_key
BACKEND_URL=your_backend_url
```

### Run the App
#### Android
```sh
flutter run
```

#### Web
```sh
flutter run -d chrome
```

## App Structure
- `lib/main.dart`: Entry point of the application
- `lib/screens`: Contains UI screens
- `lib/services`: Contains services for interacting with the backend

## Usage
1. Open the app and navigate to the data query interface.
2. Enter your query and submit.
3. View the AI-powered response.



## Contributing
Contributions are welcome! Please open an issue or submit a pull request.

## Contact
For any inquiries, please reach out to mehakverma1524@gmail.com


