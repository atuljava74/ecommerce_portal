# Ecommerce Portal

A Flutter-based ecommerce portal that provides a seamless shopping experience with a modern UI, integrated with a backend for managing products, cart, and orders. The app is built using the BLoC pattern to separate business logic from the UI, ensuring a clean and maintainable codebase.

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- A code editor, such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- A connected device or emulator for testing

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ecommerce_portal.git
   cd ecommerce_portal

2. Install Dependencies
   ```bash
   flutter pub get

3. Run the app
   ```bash
   flutter run
   
###Folder Structure
ecommerce_portal/
├── android/                # Native Android code
├── assets/                 # Assets like images, fonts, etc.
├── ios/                    # Native iOS code
├── lib/                    # Main source code
│   ├── blocs/              # BLoC classes for managing state and business logic
│   ├── models/             # Data models
│   ├── screens/            # UI screens
│   ├── utils/              # Utility classes and helpers
│   └── widgets/            # Reusable widgets
├── test/                   # Unit and widget tests
├── pubspec.yaml            # Flutter dependencies
└── README.md               # Project documentation

###Architecture
The app follows a Layered Architecture using the BLoC (Business Logic Component) Pattern:

Presentation Layer: UI components managed by Flutter widgets (screens/ and widgets/ folders).
Business Logic Layer: BLoC classes handle business logic and state management (blocs/ folder).
Data Layer: Models and utility classes that represent and manipulate data (models/ and utils/ folders).
This architecture ensures separation of concerns, making the app more scalable and easier to maintain.

###Features
User Authentication: Login and Signup functionality with secure session management.
Product Catalog: Browse products by category and subcategory, with detailed product descriptions and images.
Cart Management: Add products to the cart, manage quantities, and view cart totals.
Checkout Process: Seamless checkout with shipping information, payment method selection, and order confirmation.
Order History: View past orders with detailed information on each purchase.
Responsive UI: Beautifully designed UI.
###Screenshots



###Dependencies
Key packages used in the project:

flutter_bloc: State management using the BLoC pattern.
cached_network_image: Efficient image caching and loading.
lottie: Beautiful animations for enhancing user experience.
flutter_rating_bar: Display star ratings in the product detail page.

###API Integration
The app interacts with a backend built using PHP and MySQL. API endpoints manage user authentication, product catalog, cart operations, and order processing. 

