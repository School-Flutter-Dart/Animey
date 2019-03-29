// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);


import 'link.dart';
import 'links.dart';

class Category {
  String id;
  String type;
  Link link;
  Attributes attributes;
  Relationships relationships;

  Category({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  });

  factory Category.fromJson(Map<String, dynamic> json) => new Category(
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
  String title;
  String description;
  int totalMediaCount;
  String slug;
  bool nsfw;
  int childCount;
  dynamic image;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.title,
    this.description,
    this.totalMediaCount,
    this.slug,
    this.nsfw,
    this.childCount,
    this.image,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    totalMediaCount: json["totalMediaCount"] == null ? null : json["totalMediaCount"],
    slug: json["slug"] == null ? null : json["slug"],
    nsfw: json["nsfw"] == null ? null : json["nsfw"],
    childCount: json["childCount"] == null ? null : json["childCount"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "totalMediaCount": totalMediaCount == null ? null : totalMediaCount,
    "slug": slug == null ? null : slug,
    "nsfw": nsfw == null ? null : nsfw,
    "childCount": childCount == null ? null : childCount,
    "image": image,
  };
}

class Relationships {
  Relationship parent;
  Relationship anime;
  Relationship drama;
  Relationship manga;

  Relationships({
    this.parent,
    this.anime,
    this.drama,
    this.manga,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => new Relationships(
    parent: json["parent"] == null ? null : Relationship.fromJson(json["parent"]),
    anime: json["anime"] == null ? null : Relationship.fromJson(json["anime"]),
    drama: json["drama"] == null ? null : Relationship.fromJson(json["drama"]),
    manga: json["manga"] == null ? null : Relationship.fromJson(json["manga"]),
  );

  Map<String, dynamic> toJson() => {
    "parent": parent == null ? null : parent.toJson(),
    "anime": anime == null ? null : anime.toJson(),
    "drama": drama == null ? null : drama.toJson(),
    "manga": manga == null ? null : manga.toJson(),
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
