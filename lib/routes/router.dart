import 'package:auto_route/annotations.dart';
import '../HomeScreens/EventsOnlineOfflineScreen.dart';
import '../HomeScreens/HomePage.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: HomePage,
      children: [
        AutoRoute(
          path: 'home',
          name: 'HomeRouter',
          page: HomePage,
          children: [
            AutoRoute(path: 'events', page: EventsOnlineOffline),
          ],
        ),
        AutoRoute(
          path: 'Cart',
          name: 'CartRouter',
          page: EventsOnlineOffline,
          children: [
            AutoRoute(path: 'events', page: EventsOnlineOffline),
          ],
        ),
      ],
    )
  ],
)
class $AppRouter {}