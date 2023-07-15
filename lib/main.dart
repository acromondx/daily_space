import 'package:daily_space/page_navigator.dart';
import 'package:daily_space/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  final theme = AppTheme();

  runApp(ProviderScope(
    child: MaterialApp(
      theme: theme.dark(),
      home: const PageNavigator(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
