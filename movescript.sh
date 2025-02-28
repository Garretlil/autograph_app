#!/bin/bash

mv lib/Consts.dart lib/core/constants.dart
mv lib/Theme/Colors.dart lib/core/theme.dart
mv lib/AnimationSyncManager.dart lib/core/animation_manager.dart
mv lib/NetworkLayer.dart lib/core/network/network_layer.dart
mv lib/NetworkLayer.g.dart lib/core/network/network_layer.g.dart
mv lib/LocalCart.dart lib/core/services/local_cart.dart
mv lib/UserData.dart lib/core/services/user_service.dart

mv lib/Courses.dart lib/data/models/course.dart
mv lib/Products.dart lib/data/models/product.dart
mv lib/PurchasedСourses.dart lib/data/models/purchased_course.dart

mv lib/CartScreens/CartChooseScreen.dart lib/presentation/screens/cart/cart_choose_screen.dart
mv lib/CartScreens/CartEventsScreen.dart lib/presentation/screens/cart/cart_events_screen.dart
mv lib/CartScreens/OrderStatusScreen.dart lib/presentation/screens/cart/order_status_screen.dart
mv lib/HomeScreens/HomePage.dart lib/presentation/screens/home/home_page.dart
mv lib/LoginRegisterScreens/RegistrationScreen.dart lib/presentation/screens/login/registration_screen.dart
mv lib/ProfileScreens/ProfilePage.dart lib/presentation/screens/profile/profile_page.dart
mv lib/ShopScreens/ProductScreen.dart lib/presentation/screens/shop/product_screen.dart
