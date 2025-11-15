# Product Dashboard

A modern and responsive Product Dashboard that displays product information, statistics, and insights in a clean UI.

## Features
- Product listing with search
- Product categories & filters
- Dashboard charts 
- Smooth UI/UX optimized for web and mobile
- API integration for real-time product data

## Technologies Used
- Flutter / Dart
- REST API
- Git & GitHub

## Run The Project Using Command
- flutter run -d chrome

## Libraries Used 
- flutter_bloc: ^9.1.1
- equatable: ^2.0.7
- go_router: ^17.0.0
- dio: ^5.9.0
- get_it: ^9.0.5

##Folder Structure & Reasoning
lib/
│
├── core/
│   ├── di/
│   │   └── service_locator.dart
│   ├── network/
│   │   └── dio_client.dart
│   ├── routes/
│   │   └── app_routes.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── usecase/
│
├── features/
│   └── product/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── product_remote_datasource.dart
│       │   ├── model/
│       │   │   └── product_model.dart
│       │   └── repositories/
│       │       └── product_repository_imp.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── product_entity.dart
│       │   ├── repositories/
│       │   │   └── product_repository.dart
│       │   └── usecase/
│       │       ├── add_product_usecase.dart
│       │       ├── get_product_usecase.dart
│       │       └── update_product_usecase.dart
│       │
│       ├── models/
│       │   └── product_request.dart
│       │
│       ├── presentation/
│       │   ├── bloc/
│       │   │   ├── product_bloc.dart
│       │   │   ├── product_event.dart
│       │   │   └── product_state.dart
│       │   ├── pages/
│       │   │   ├── product_detail_page.dart
│       │   │   └── product_list_page.dart
│       │   └── widgets/
│       │       ├── add_edit_product_modal.dart
│       │       ├── product_card.dart
│       │       ├── searchbar.dart
│       │       └── sidebar.dart
│
└── main.dart

1. core/
Contains global-level utilities used across the entire app
di/ → Service Locator for dependency injection
network/ → Dio configuration (base URL, headers, interceptors)
routes/ → Centralized navigation
theme/ → App colors, typography, styles

2. features/product/
All product-related logic is grouped into a single feature to follow modular architecture.

2.1 data/
Handles API calls, model conversion, and repository implementation.
datasources/
→ Remote API calls using Dio (product_remote_datasource.dart)
model/
→ JSON models for network communication
repositories/
→ Implementation of domain repository (product_repository_imp.dart)

2.2 domain/
The pure business logic layer.
entities/ → Business objects independent of API
repositories/ → Abstract repository contract
usecase/ → Each action is separated (Get, Add, Update products)

models/
Holds request-specific such as:
product_request.dart

2.4 presentation/
UI + State Management
bloc/ → Handles product state, events, loading logic
pages/ → Screens (product list, product detail)
widgets/ → Reusable UI components (sidebar, cards)
