// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'anime.dart';
import 'link.dart';
import 'links.dart';
import 'upload.dart';
import 'user.dart';

String getContentWithoutUrl(Post post){
  if(post.attributes.embed != null && post.attributes.embed.url!=null){
    return post.attributes.content.replaceFirst(post.attributes.embed.url, '');
  }else{
    return post.attributes.content;
  }
}

class Post {
  String id;
  String type;
  Link link;
  Attributes attributes;
  Relationships relationships;
  Anime anime;
  List<Upload> uploads = List<Upload>();
  User user;

  Post({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  });

  factory Post.fromJson(Map<String, dynamic> json) => new Post(
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
  int commentsCount;
  int postLikesCount;
  bool spoiler;
  bool nsfw;
  bool blocked;
  dynamic deletedAt;
  int topLevelCommentsCount;
  dynamic editedAt;
  dynamic targetInterest;
  Embed embed;
  dynamic embedUrl;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.content,
    this.contentFormatted,
    this.commentsCount,
    this.postLikesCount,
    this.spoiler,
    this.nsfw,
    this.blocked,
    this.deletedAt,
    this.topLevelCommentsCount,
    this.editedAt,
    this.targetInterest,
    this.embed,
    this.embedUrl,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    content: json["content"] == null ? null : json["content"],
    contentFormatted: json["contentFormatted"] == null ? null : json["contentFormatted"],
    commentsCount: json["commentsCount"] == null ? null : json["commentsCount"],
    postLikesCount: json["postLikesCount"] == null ? null : json["postLikesCount"],
    spoiler: json["spoiler"] == null ? null : json["spoiler"],
    nsfw: json["nsfw"] == null ? null : json["nsfw"],
    blocked: json["blocked"] == null ? null : json["blocked"],
    deletedAt: json["deletedAt"],
    topLevelCommentsCount: json["topLevelCommentsCount"] == null ? null : json["topLevelCommentsCount"],
    editedAt: json["editedAt"],
    targetInterest: json["targetInterest"],
    embed: json["embed"] == null ? null : Embed.fromJson(json["embed"]),
    embedUrl: json["embedUrl"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "content": content == null ? null : content,
    "contentFormatted": contentFormatted == null ? null : contentFormatted,
    "commentsCount": commentsCount == null ? null : commentsCount,
    "postLikesCount": postLikesCount == null ? null : postLikesCount,
    "spoiler": spoiler == null ? null : spoiler,
    "nsfw": nsfw == null ? null : nsfw,
    "blocked": blocked == null ? null : blocked,
    "deletedAt": deletedAt,
    "topLevelCommentsCount": topLevelCommentsCount == null ? null : topLevelCommentsCount,
    "editedAt": editedAt,
    "targetInterest": targetInterest,
    "embed": embed == null ? null : embed.toJson(),
    "embedUrl": embedUrl,
  };
}

class Embed {
  String url;
  String kind;
  Image image;
  String title;

  Embed({
    this.url,
    this.kind,
    this.image,
    this.title,
  });

  factory Embed.fromJson(Map<String, dynamic> json) {
    Image image;
    try{
      image = json["image"] == null ? null : Image.fromJson(json["image"]);
    }catch(exception){
      image = Image(url: json["image"]);
    }
    return Embed(
      url: json["url"] == null ? null : json["url"],
      kind: json["kind"] == null ? null : json["kind"],
      image: image,
      title: json["title"] == null ? null : json["title"],
    );
  }

//  factory Embed.fromJson(Map<String, dynamic> json) => new Embed(
//    url: json["url"] == null ? null : json["url"],
//    kind: json["kind"] == null ? null : json["kind"],
//    image: json["image"] == null ? null : Image.fromJson(json["image"]),
//    title: json["title"] == null ? null : json["title"],
//  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "kind": kind == null ? null : kind,
    "image": image == null ? null : image.toJson(),
    "title": title == null ? null : title,
  };
}

class Image {
  String url;
  String type;
  double width;
  double height;

  Image({
    this.url,
    this.type,
    this.width,
    this.height,
  });

  factory Image.fromJson(Map<String, dynamic> json) => new Image(
    url: json["url"] == null ? null : json["url"],
    type: json["type"] == null ? null : json["type"],
    width: json["width"] == null ? null : double.parse(json["width"].toString()),
    height: json["height"] == null ? null : double.parse(json["height"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "type": type == null ? null : type,
    "width": width == null ? null : width,
    "height": height == null ? null : height,
  };
}


class Relationships {
  Relationship user;
  String userId;///&include=user
  Relationship targetUser;
  Relationship targetGroup;
  Relationship media;
  Relationship spoiledUnit;
  Relationship ama;
  Relationship postLikes;
  Relationship comments;
  Relationship uploads;
  List<String> uploadIds = List<String>();

  Relationships({
    this.user,
    this.userId,
    this.targetUser,
    this.targetGroup,
    this.media,
    this.spoiledUnit,
    this.ama,
    this.postLikes,
    this.comments,
    this.uploads,
    this.uploadIds
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => new Relationships(
    user: json["user"] == null ? null : Relationship.fromJson(json["user"]),
    userId: json["user"]['data'] == null ? null : json["user"]['data']['id'],
    targetUser: json["targetUser"] == null ? null : Relationship.fromJson(json["targetUser"]),
    targetGroup: json["targetGroup"] == null ? null : Relationship.fromJson(json["targetGroup"]),
    media: json["media"] == null ? null : Relationship.fromJson(json["media"]),
    spoiledUnit: json["spoiledUnit"] == null ? null : Relationship.fromJson(json["spoiledUnit"]),
    ama: json["ama"] == null ? null : Relationship.fromJson(json["ama"]),
    postLikes: json["postLikes"] == null ? null : Relationship.fromJson(json["postLikes"]),
    comments: json["comments"] == null ? null : Relationship.fromJson(json["comments"]),
    uploads: json["uploads"] == null ? null : Relationship.fromJson(json["uploads"]),
    uploadIds: json["uploads"]["data"] == null? null: (json["uploads"]["data"] as List).map((json)=>json["id"]).cast<String>().toList()
  );

  Map<String, dynamic> toJson() => {
    "user": user == null ? null : user.toJson(),
    "targetUser": targetUser == null ? null : targetUser.toJson(),
    "targetGroup": targetGroup == null ? null : targetGroup.toJson(),
    "media": media == null ? null : media.toJson(),
    "spoiledUnit": spoiledUnit == null ? null : spoiledUnit.toJson(),
    "ama": ama == null ? null : ama.toJson(),
    "postLikes": postLikes == null ? null : postLikes.toJson(),
    "comments": comments == null ? null : comments.toJson(),
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
