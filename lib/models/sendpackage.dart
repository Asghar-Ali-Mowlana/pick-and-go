class SendPackage {
  //String? id;
  String? receiverName;
  String? receiverEmail;
  String? receiverAddress;
  int? receiverPostalCode;
  int? receiverContact;
  String? packageDescription;
  double? packageLength;
  double? packageHeight;
  double? packageWidth;
  double? packageWeight;
  double? packageCost;

  SendPackage(
      {
        //this.id,
        this.receiverName,
        this.receiverEmail,
        this.receiverAddress,
        this.receiverPostalCode,
        this.receiverContact,
        this.packageDescription,
        this.packageLength,
        this.packageHeight,
        this.packageWidth,
        this.packageWeight,
        this.packageCost
      });

  //convert object to json
  Map<String, dynamic> toJson() => {
    // 'id': id,
    'receiverName': receiverName,
    'receiverEmail': receiverEmail,
    'receiverAddress': receiverAddress,
    'receiverPostalCode': receiverPostalCode,
    'receiverContact': receiverContact,
    'packageDescription': packageDescription,
    'packageLength': packageLength,
    'packageHeight': packageHeight,
    'packageWidth': packageWidth,
    'packageWeight': packageWeight,
  };

  // //returns user object
  // static SendPackage fromJson(Map<String, dynamic> json) => SendPackage(
  //   id: json['id'],
  //   name: json['name'],
  //   category: json['category'],
  //   preparationtime: json['preparationtime'],
  //   instructions: json['instructions'],
  //   ingredients: json['ingredients'],
  //   recipeimage: json['recipeimage'],
  //   favourites: json['favourites'],
  // );

}
