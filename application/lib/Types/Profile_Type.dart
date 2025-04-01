class Profiles {
  String? email;
  String? username;
  String? address;
  String? sType;
  String? dateOfBirth;
  ProfileImage? profileImage;
  String? sUpdatedAt;
  String? postalCode;
  String? sRev;
  String? phoneNumber;
  String? sCreatedAt;
  List<PastOrders>? pastOrders;
  String? sId;

  Profiles({
    this.email,
    this.username,
    this.address,
    this.sType,
    this.dateOfBirth,
    this.profileImage,
    this.sUpdatedAt,
    this.postalCode,
    this.sRev,
    this.phoneNumber,
    this.sCreatedAt,
    this.pastOrders,
    this.sId,
  });

  Profiles.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    address = json['address'];
    sType = json['_type'];
    dateOfBirth = json['dateOfBirth'];
    profileImage =
        json['profileImage'] != null
            ? new ProfileImage.fromJson(json['profileImage'])
            : null;
    sUpdatedAt = json['_updatedAt'];
    postalCode = json['postalCode'];
    sRev = json['_rev'];
    phoneNumber = json['phoneNumber'];
    sCreatedAt = json['_createdAt'];
    if (json['pastOrders'] != null) {
      pastOrders = <PastOrders>[];
      json['pastOrders'].forEach((v) {
        pastOrders!.add(new PastOrders.fromJson(v));
      });
    }
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['username'] = this.username;
    data['address'] = this.address;
    data['_type'] = this.sType;
    data['dateOfBirth'] = this.dateOfBirth;
    if (this.profileImage != null) {
      data['profileImage'] = this.profileImage!.toJson();
    }
    data['_updatedAt'] = this.sUpdatedAt;
    data['postalCode'] = this.postalCode;
    data['_rev'] = this.sRev;
    data['phoneNumber'] = this.phoneNumber;
    data['_createdAt'] = this.sCreatedAt;
    if (this.pastOrders != null) {
      data['pastOrders'] = this.pastOrders!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    return data;
  }
}

class ProfileImage {
  Asset? asset;
  String? sType;

  ProfileImage({this.asset, this.sType});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    asset = json['asset'] != null ? new Asset.fromJson(json['asset']) : null;
    sType = json['_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.asset != null) {
      data['asset'] = this.asset!.toJson();
    }
    data['_type'] = this.sType;
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

class PastOrders {
  int? totalAmount;
  String? orderId;
  String? sKey;
  String? orderDate;
  String? status;

  PastOrders({
    this.totalAmount,
    this.orderId,
    this.sKey,
    this.orderDate,
    this.status,
  });

  PastOrders.fromJson(Map<String, dynamic> json) {
    totalAmount = json['totalAmount'];
    orderId = json['orderId'];
    sKey = json['_key'];
    orderDate = json['orderDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAmount'] = this.totalAmount;
    data['orderId'] = this.orderId;
    data['_key'] = this.sKey;
    data['orderDate'] = this.orderDate;
    data['status'] = this.status;
    return data;
  }
}
