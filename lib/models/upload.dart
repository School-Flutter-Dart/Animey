// To parse this JSON data, do
//
//     final upload = uploadFromJson(jsonString);

import 'dart:convert';
import 'link.dart';
import 'links.dart';

Upload uploadFromJson(String str) {
  final jsonData = json.decode(str);
  return Upload.fromJson(jsonData);
}

String uploadToJson(Upload data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Upload {
  String id;
  String type;
  Link links;
  Attributes attributes;
  Relationships relationships;

  Upload({
    this.id,
    this.type,
    this.links,
    this.attributes,
    this.relationships,
  });

  factory Upload.fromJson(Map<String, dynamic> json) => new Upload(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : json["type"],
    links: json["links"] == null ? null : Link.fromJson(json["links"]),
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
    relationships: json["relationships"] == null ? null : Relationships.fromJson(json["relationships"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "type": type == null ? null : type,
    "links": links == null ? null : links.toJson(),
    "attributes": attributes == null ? null : attributes.toJson(),
    "relationships": relationships == null ? null : relationships.toJson(),
  };
}

class Attributes {
  String createdAt;
  String updatedAt;
  Content content;
  int uploadOrder;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.content,
    this.uploadOrder,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
    uploadOrder: json["uploadOrder"] == null ? null : json["uploadOrder"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "content": content == null ? null : content.toJson(),
    "uploadOrder": uploadOrder == null ? null : uploadOrder,
  };
}

class Content {
  String original;
  Meta meta;

  Content({
    this.original,
    this.meta,
  });

  factory Content.fromJson(Map<String, dynamic> json) => new Content(
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

class Relationships {
  Relationship user;
  Relationship owner;

  Relationships({
    this.user,
    this.owner,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => new Relationships(
    user: json["user"] == null ? null : Relationship.fromJson(json["user"]),
    owner: json["owner"] == null ? null : Relationship.fromJson(json["owner"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user == null ? null : user.toJson(),
    "owner": owner == null ? null : owner.toJson(),
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
