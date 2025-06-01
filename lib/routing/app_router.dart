import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/list_screen.dart';
import '../screens/add_edit_screen.dart';
import '../screens/chart_screens/bar_chart_screen.dart';
import '../screens/chart_screens/line_chart_screen.dart';
import '../screens/chart_screens/pie_chart_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ListScreen(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddEditScreen(),
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) {
        final id = int.tryParse(state.params['id'] ?? '');
        return AddEditScreen(expenseKey: id);
      },
    ),
    GoRoute(
      path: '/charts/bar',
      builder: (context, state) => const BarChartScreen(),
    ),
    GoRoute(
      path: '/charts/line',
      builder: (context, state) => const LineChartScreen(),
    ),
    GoRoute(
      path: '/charts/pie',
      builder: (context, state) => const PieChartScreen(),
    ),
  ],
);
