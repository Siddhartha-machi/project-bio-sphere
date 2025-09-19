import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class RouteFallback extends StatelessWidget {
  final GoRouterState? state;

  const RouteFallback(this.state, {super.key});

  String _buildRouteInfo() {
    String routeInfo = '';
    if (state != null) {
      routeInfo = state!.uri.path;
    }

    return routeInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Default route widget : ${_buildRouteInfo()}')),
    );
  }
}
