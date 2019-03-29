// To parse this JSON data, do
//
//     final episode = episodeFromJson(jsonString);

import 'dart:convert';
import 'link.dart';
import 'links.dart';

Episode episodeFromJson(String str) {
  final jsonData = json.decode(str);
  return Episode.fromJson(jsonData);
}

String episodeToJson(Episode data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Episode {
  String id;
  String type;
  Link link;
  Attributes attributes;
  Relationships relationships;

  Episode({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => new Episode(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : json["type"],
    link: json["links"] == null ? null : Link.fromJson(json["links"]),
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
    relationships: json["relationships"] == null ? null : Relationships.fromJson(json["relationships"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "type": type == null ? null : type,
    "links": link == null ? null : link.toJson(),
    "attributes": attributes == null ? null : attributes.toJson(),
    "relationships": relationships == null ? null : relationships.toJson(),
  };
}

class Attributes {
  String createdAt;
  String updatedAt;
  Titles titles;
  String canonicalTitle;
  int seasonNumber;
  int number;
  dynamic relativeNumber;
  String synopsis;
  String airdate;
  int length;
  Thumbnail thumbnail;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.titles,
    this.canonicalTitle,
    this.seasonNumber,
    this.number,
    this.relativeNumber,
    this.synopsis,
    this.airdate,
    this.length,
    this.thumbnail,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    titles: json["titles"] == null ? null : Titles.fromJson(json["titles"]),
    canonicalTitle: json["canonicalTitle"] == null ? null : json["canonicalTitle"],
    seasonNumber: json["seasonNumber"] == null ? null : json["seasonNumber"],
    number: json["number"] == null ? null : json["number"],
    relativeNumber: json["relativeNumber"],
    synopsis: json["synopsis"] == null ? null : json["synopsis"],
    airdate: json["airdate"] == null ? null : json["airdate"],
    length: json["length"] == null ? null : json["length"],
    thumbnail: json["thumbnail"] == null ? null : Thumbnail.fromJson(json["thumbnail"]),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "titles": titles == null ? null : titles.toJson(),
    "canonicalTitle": canonicalTitle == null ? null : canonicalTitle,
    "seasonNumber": seasonNumber == null ? null : seasonNumber,
    "number": number == null ? null : number,
    "relativeNumber": relativeNumber,
    "synopsis": synopsis == null ? null : synopsis,
    "airdate": airdate == null ? null : airdate,
    "length": length == null ? null : length,
    "thumbnail": thumbnail == null ? null : thumbnail.toJson(),
  };
}

class Thumbnail {
  String original;
  Meta meta;

  Thumbnail({
    this.original,
    this.meta,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) => new Thumbnail(
    original: json["original"] == null ? null : json["original"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "original": original == null ? null : original,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class Meta {
  Dimensions dimensions;

  Meta({
    this.dimensions,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => new Meta(
    dimensions: json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
  );

  Map<String, dynamic> toJson() => {
    "dimensions": dimensions == null ? null : dimensions.toJson(),
  };
}

class Dimensions {
  Dimensions();

  factory Dimensions.fromJson(Map<String, dynamic> json) => new Dimensions(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Titles {
  String enJp;
  String enUs;
  String jaJp;

  Titles({
    this.enJp,
    this.enUs,
    this.jaJp,
  });

  factory Titles.fromJson(Map<String, dynamic> json) => new Titles(
    enJp: json["en_jp"] == null ? null : json["en_jp"],
    enUs: json["en_us"] == null ? null : json["en_us"],
    jaJp: json["ja_jp"] == null ? null : json["ja_jp"],
  );

  Map<String, dynamic> toJson() => {
    "en_jp": enJp == null ? null : enJp,
    "en_us": enUs == null ? null : enUs,
    "ja_jp": jaJp == null ? null : jaJp,
  };
}

class Relationships {
  Media media;
  Media videos;

  Relationships({
    this.media,
    this.videos,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => new Relationships(
    media: json["media"] == null ? null : Media.fromJson(json["media"]),
    videos: json["videos"] == null ? null : Media.fromJson(json["videos"]),
  );

  Map<String, dynamic> toJson() => {
    "media": media == null ? null : media.toJson(),
    "videos": videos == null ? null : videos.toJson(),
  };
}

class Media {
  Links links;

  Media({
    this.links,
  });

  factory Media.fromJson(Map<String, dynamic> json) => new Media(
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "links": links == null ? null : links.toJson(),
  };
}
