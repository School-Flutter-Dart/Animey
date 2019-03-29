// To parse this JSON data, do
//
//     final streamingLinks = streamingLinksFromJson(jsonString);

import 'link.dart';
import 'links.dart';
import 'streamer.dart';

class StreamingLink {
  String id;
  String type;
  Link link;
  Attributes attributes;
  Relationships relationships;
  Streamer streamer;

  StreamingLink({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  });

  factory StreamingLink.fromJson(Map<String, dynamic> json) => new StreamingLink(
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
  dynamic createdAt;
  String updatedAt;
  String url;
  List<String> subs;
  List<String> dubs;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.url,
    this.subs,
    this.dubs,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    url: json["url"] == null ? null : json["url"],
    subs: json["subs"] == null ? null : new List<String>.from(json["subs"].map((x) => x)),
    dubs: json["dubs"] == null ? null : new List<String>.from(json["dubs"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "url": url == null ? null : url,
    "subs": subs == null ? null : new List<dynamic>.from(subs.map((x) => x)),
    "dubs": dubs == null ? null : new List<dynamic>.from(dubs.map((x) => x)),
  };
}

class Relationships {
  Media streamer;
  Media media;

  Relationships({
    this.streamer,
    this.media,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => new Relationships(
    streamer: json["streamer"] == null ? null : Media.fromJson(json["streamer"]),
    media: json["media"] == null ? null : Media.fromJson(json["media"]),
  );

  Map<String, dynamic> toJson() => {
    "streamer": streamer == null ? null : streamer.toJson(),
    "media": media == null ? null : media.toJson(),
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
