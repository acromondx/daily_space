import 'package:daily_space/models/apod.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final dbServiceProvider =
    ChangeNotifierProvider<DatabaseService>((_) => DatabaseService());

final bookmarkedFolderProvider = FutureProvider<List<Apod>>((ref) async {
  final result = await ref.watch(dbServiceProvider).getAllApod();
  return result;
});

final isBookmarkedProvider =
    FutureProvider.family<bool, Apod>((ref, course) async {
  final result = await ref.watch(dbServiceProvider).isBookmarked(course);
  return result;
});

class DatabaseService extends ChangeNotifier {
  late Future<Isar> db;

  DatabaseService() {
    db = openIsar();
  }

  Future<Isar> openIsar() async {
    if (Isar.instanceNames.isEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      return await Isar.open([ApodSchema],
          inspector: false, directory: directory.path);
    }

    return Future.value(Isar.getInstance());
  }

  Future<void> bookmarkApod(Apod newApod) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.apods.put(newApod);
    });
    notifyListeners();
  }

  Future<bool> isBookmarked(Apod apod) async {
    final isar = await db;
    if (await isar.apods.where().filter().apodIdEqualTo(apod.apodId).count() >=
        1) {
      return true;
    }
    return false;
  }

  Future<List<Apod>> getAllApod() async {
    final isar = await db;
    final apod = isar.apods;
    return apod.where().sortByTitle().findAll();
  }

  Future<void> deleteApod(Id id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.apods.delete(id);
    });
    notifyListeners();
  }
}
