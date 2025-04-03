class Products {
  String? sCreatedAt;
  String? sRev;
  String? description;
  String? sId;
  String? sUpdatedAt;
  String? sType;
  Video? video;
  String? title;
  List<Images>? images;
  int? price;

  Products({
    this.sCreatedAt,
    this.sRev,
    this.description,
    this.sId,
    this.sUpdatedAt,
    this.sType,
    this.video,
    this.title,
    this.images,
    this.price,
  });

  Products.fromJson(Map<String, dynamic> json) {
    sCreatedAt = json['_createdAt'];
    sRev = json['_rev'];
    description = json['description'];
    sId = json['_id'];
    sUpdatedAt = json['_updatedAt'];
    sType = json['_type'];
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
    title = json['title'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_createdAt'] = this.sCreatedAt;
    data['_rev'] = this.sRev;
    data['description'] = this.description;
    data['_id'] = this.sId;
    data['_updatedAt'] = this.sUpdatedAt;
    data['_type'] = this.sType;
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    data['title'] = this.title;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    return data;
  }
}

class Video {
  String? sType;
  Asset? asset;

  Video({this.sType, this.asset});

  Video.fromJson(Map<String, dynamic> json) {
    sType = json['_type'];
    asset = json['asset'] != null ? new Asset.fromJson(json['asset']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_type'] = this.sType;
    if (this.asset != null) {
      data['asset'] = this.asset!.toJson();
    }
    return data;
  }
}

class Asset {
  String? sRef;
  String? sType;

  Asset({this.sRef, this.sType});

  Asset.fromJson(Map<String, dynamic> json) {
    sRef = json['_ref'];
    sType = json['_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_ref'] = this.sRef;
    data['_type'] = this.sType;
    return data;
  }
}

class Images {
  String? sKey;
  Asset? asset;
  String? sType;

  Images({this.sKey, this.asset, this.sType});

  Images.fromJson(Map<String, dynamic> json) {
    sKey = json['_key'];
    asset = json['asset'] != null ? new Asset.fromJson(json['asset']) : null;
    sType = json['_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_key'] = this.sKey;
    if (this.asset != null) {
      data['asset'] = this.asset!.toJson();
    }
    data['_type'] = this.sType;
    return data;
  }
}
