class ConstModel {
  late String id;
  late String nomi;

  ConstModel({required this.id, required this.nomi});

  ConstModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    nomi = json['nomi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['nomi'] = this.nomi;
    return data;
  }
  static List<ConstModel> fromJsonList(List list) {
    return list.map((item) => ConstModel.fromJson(item)).toList();
  }

}