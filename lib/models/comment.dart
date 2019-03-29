// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'link.dart';
import 'links.dart';

class Comment {
  String id;
  String type;
  Link link;
  Attributes attributes;
  Relationships relationships;

  Comment({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => new Comment(
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
  String content;
  String contentFormatted;
  bool blocked;
  dynamic deletedAt;
  int likesCount;
  int repliesCount;
  dynamic editedAt;
  Embed embed;
  dynamic embedUrl;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.content,
    this.contentFormatted,
    this.blocked,
    this.deletedAt,
    this.likesCount,
    this.repliesCount,
    this.editedAt,
    this.embed,
    this.embedUrl,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    content: json["content"] == null ? null : json["content"],
    contentFormatted: json["contentFormatted"] == null ? null : json["contentFormatted"],
    blocked: json["blocked"] == null ? null : json["blocked"],
    deletedAt: json["deletedAt"],
    likesCount: json["likesCount"] == null ? null : json["likesCount"],
    repliesCount: json["repliesCount"] == null ? null : json["repliesCount"],
    editedAt: json["editedAt"],
    embed: json["embed"] == null ? null : Embed.fromJson(json["embed"]),
    embedUrl: json["embedUrl"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "content": content == null ? null : content,
    "contentFormatted": contentFormatted == null ? null : contentFormatted,
    "blocked": blocked == null ? null : blocked,
    "deletedAt": deletedAt,
    "likesCount": likesCount == null ? null : likesCount,
    "repliesCount": repliesCount == null ? null : repliesCount,
    "editedAt": editedAt,
    "embed": embed == null ? null : embed.toJson(),
    "embedUrl": embedUrl,
  };
}

class Embed {
  String url;
  String kind;
  Site site;
  Image image;
  String title;
  Image video;
  String description;

  Embed({
    this.url,
    this.kind,
    this.site,
    this.image,
    this.title,
    this.video,
    this.description,
  });

  factory Embed.fromJson(Map<String, dynamic> json){
    Image image;
    try{
      image = json["image"] == null ? null : Image.fromJson(json["image"]);
    }catch(exception){
      image = Image(url: json["image"]);
    }
    return Embed(
      url: json["url"] == null ? null : json["url"],
      kind: json["kind"] == null ? null : json["kind"],
      site: json["site"] == null ? null : Site.fromJson(json["site"]),
      image: image,
      title: json["title"] == null ? null : json["title"],
      video: json["video"] == null ? null : Image.fromJson(json["video"]),
      description: json["description"] == null ? null : json["description"],
    );
  }

//  factory Embed.fromJson(Map<String, dynamic> json) => new Embed(
//    url: json["url"] == null ? null : json["url"],
//    kind: json["kind"] == null ? null : json["kind"],
//    site: json["site"] == null ? null : Site.fromJson(json["site"]),
//    image: json["image"] == null ? null : Image.fromJson(json["image"]),
//    title: json["title"] == null ? null : json["title"],
//    video: json["video"] == null ? null : Image.fromJson(json["video"]),
//    description: json["description"] == null ? null : json["description"],
//  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "kind": kind == null ? null : kind,
    "site": site == null ? null : site.toJson(),
    "image": image == null ? null : image.toJson(),
    "title": title == null ? null : title,
    "video": video == null ? null : video.toJson(),
    "description": description == null ? null : description,
  };
}

class Image {
  String url;
  String type;
  dynamic width; ///FIXME: parse width and height to int
  dynamic height;

  Image({
    this.url,
    this.type,
    this.width,
    this.height,
  });

  factory Image.fromJson(Map<String, dynamic> json) => new Image(
    url: json["url"] == null ? null : json["url"],
    type: json["type"] == null ? null : json["type"],
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "type": type == null ? null : type,
    "width": width == null ? null : width,
    "height": height == null ? null : height,
  };
}

class Site {
  String name;

  Site({
    this.name,
  });

  factory Site.fromJson(Map<String, dynamic> json) => new Site(
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
  };
}

class Relationships {
  Relationship user;
  Relationship post;
  Relationship parent;
  Relationship likes;
  Relationship replies;
  Relationship uploads;

  Relationships({
    this.user,
    this.post,
    this.parent,
    this.likes,
    this.replies,
    this.uploads,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => new Relationships(
    user: json["user"] == null ? null : Relationship.fromJson(json["user"]),
    post: json["post"] == null ? null : Relationship.fromJson(json["post"]),
    parent: json["parent"] == null ? null : Relationship.fromJson(json["parent"]),
    likes: json["likes"] == null ? null : Relationship.fromJson(json["likes"]),
    replies: json["replies"] == null ? null : Relationship.fromJson(json["replies"]),
    uploads: json["uploads"] == null ? null : Relationship.fromJson(json["uploads"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user == null ? null : user.toJson(),
    "post": post == null ? null : post.toJson(),
    "parent": parent == null ? null : parent.toJson(),
    "likes": likes == null ? null : likes.toJson(),
    "replies": replies == null ? null : replies.toJson(),
    "uploads": uploads == null ? null : uploads.toJson(),
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
