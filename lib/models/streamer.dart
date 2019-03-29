// To parse this JSON data, do
//
//     final streamer = streamerFromJson(jsonString);

import 'dart:convert';
import 'link.dart';
import 'links.dart';

Streamer streamerFromJson(String str) {
  final jsonData = json.decode(str);
  return Streamer.fromJson(jsonData);
}

String streamerToJson(Streamer data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Streamer {
  String id;
  String type;
  Link link;
  Attributes attributes;
  Relationships relationships;

  Streamer({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  });

  factory Streamer.fromJson(Map<String, dynamic> json) => new Streamer(
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
  String siteName;
  int streamingLinksCount;
  String logo;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.siteName,
    this.streamingLinksCount,
    this.logo,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    siteName: json["siteName"] == null ? null : json["siteName"],
    streamingLinksCount: json["streamingLinksCount"] == null ? null : json["streamingLinksCount"],
    logo: json["logo"] == null ? null : json["logo"]['original'],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "siteName": siteName == null ? null : siteName,
    "streamingLinksCount": streamingLinksCount == null ? null : streamingLinksCount,
    "logo": logo == null ? null : logo,
  };
}

class Relationships {
  Relationship streamingLinks;
  Relationship videos;

  Relationships({
    this.streamingLinks,
    this.videos,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => new Relationships(
    streamingLinks: json["streamingLinks"] == null ? null : Relationship.fromJson(json["streamingLinks"]),
    videos: json["videos"] == null ? null : Relationship.fromJson(json["videos"]),
  );

  Map<String, dynamic> toJson() => {
    "streamingLinks": streamingLinks == null ? null : streamingLinks.toJson(),
    "videos": videos == null ? null : videos.toJson(),
  };
}

class Relationship {
  Links links;

  Relationship({
    this.links,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) => new Relationship(
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "links": links == null ? null : links.toJson(),
  };
}
