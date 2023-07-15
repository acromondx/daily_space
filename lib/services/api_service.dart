import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api_key.dart'; //create and import your own API key
import '../models/apod.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final apodProvider =
    FutureProvider.family<Apod, DateTime>((ref, dateTime) async {
  return getData(dateTime: dateTime);
});

Future<Apod> getData({DateTime? dateTime}) async {
  final dio = Dio();
  try {
    // const key = String.fromEnvironment('APOD_API_KEY');
    // if (key.isEmpty) {
    //   throw AssertionError('APOD_API_KEY is not set');
    // }
    dateTime ??= DateTime.now();
    String dateString =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final path =
        'https://api.nasa.gov/planetary/apod?api_key=$apiKey&date=$dateString&thumbs=True';
    final response = await dio.get(path).timeout(const Duration(seconds: 15));
    final res = json.encode(response.data);
    print(Apod.fromJson(res).mediaType);
    return Apod.fromJson(res);
  } on DioException catch (e) {
    throw 'Network error: ${e.message}';
  } catch (e) {
    throw 'An unexpected error occurred: $e';
  }
}
