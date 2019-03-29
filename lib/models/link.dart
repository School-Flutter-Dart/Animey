class Link {
  String self;

  Link({
    this.self,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    self: json["self"] == null ? null : json['self'],
  );

  Map<String, dynamic> toJson() => {
    "self": self == null ? null : self,
  };
}
