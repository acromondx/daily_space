import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class InternetErrorSection extends StatelessWidget {
  const InternetErrorSection({
    Key? key,
    required this.error,
    required this.onRefreshButtonPressed,
  }) : super(key: key);

  final Object error;
  final void Function()? onRefreshButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (error is DioException)
          const SelectableText(
            'Network error: Please check your internet connection.',
            style: TextStyle(color: Colors.white),
          ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          onPressed: onRefreshButtonPressed,
          label: const Text('Refresh'),
        ),
      ],
    );
  }
}
