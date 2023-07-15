// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';

part 'apod.g.dart';

@Collection()
class Apod {
  Id get apodId => fastHash(date!);

  String? copyright;
  String? date;
  String? explanation;
  String? hdurl;
  String? mediaType;
  String? thumbnailUrl;
  String? title;
  String? url;
  Apod({
    this.copyright,
    this.date,
    this.explanation,
    this.hdurl,
    this.mediaType,
    this.thumbnailUrl,
    this.title,
    this.url,
  });

  factory Apod.fromMap(Map<String, dynamic> map) {
    return Apod(
      copyright: map['copyright'] != null ? map['copyright'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      explanation:
          map['explanation'] != null ? map['explanation'] as String : null,
      hdurl: map['hdurl'] != null ? map['hdurl'] as String : null,
      mediaType: map['media_type'] != null ? map['media_type'] as String : null,
      thumbnailUrl:
          map['thumbnail_url'] != null ? map['thumbnail_url'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
    );
  }

  factory Apod.fromJson(String source) =>
      Apod.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Apod(copyright: $copyright, date: $date, explanation: $explanation, hdurl: $hdurl, mediaType: $mediaType, thumbnailUrl: $thumbnailUrl, title: $title, url: $url,)';
  }
}

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}
