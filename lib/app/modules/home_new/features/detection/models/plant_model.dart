class PlantModel {
  int? id;
  String? name;
  String? family;
  String? images;
  String? detail;
  String? others;

  PlantModel(
      {this.id, this.name, this.family, this.images, this.detail, this.others});

  PlantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    family = json['family'];
    images = json['images'];
    detail = json['detail'];
    others = json['others'];
  }
}
