// To parse this JSON data, do
//
//     final genre = genreFromJson(jsonString);

import 'dart:convert';
import 'link.dart';

GenresData genreFromJson(String str) {
  final jsonData = json.decode(str);
  return GenresData.fromJson(jsonData);
}

String genreToJson(GenresData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class GenresData {
  List<Genres> genres;

  GenresData({
    this.genres,
  });

  factory GenresData.fromJson(Map<String, dynamic> json) => new GenresData(
        genres: json["data"] == null
            ? null
            : (json["data"] as List)
                .map((json) => Genres.fromJson(json))
                .cast<Genres>()
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        "data": genres == null ? null : genres.map((genres) => genres.toJson()),
      };
}

class Genres {
  String id;
  String type;
  Link link;
  Attributes attributes;

  Genres({
    this.id,
    this.type,
    this.link,
    this.attributes,
  });

  factory Genres.fromJson(Map<String, dynamic> json) => new Genres(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        link: json["links"] == null ? null : Link.fromJson(json["links"]),
        attributes: json["attributes"] == null
            ? null
            : Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "links": link == null ? null : link.toJson(),
        "attributes": attributes == null ? null : attributes.toJson(),
      };
}

class Attributes {
  String createdAt;
  String updatedAt;
  String name;
  String slug;
  dynamic description;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.name,
    this.slug,
    this.description,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "description": description,
      };
}
