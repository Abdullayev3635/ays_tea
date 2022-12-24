class BrendModel {
  late String id;
  late String nomi;
  late String img;

  BrendModel({required this.id, required this.nomi, required this.img});

  BrendModel.fromJson(Map<String, dynamic> json) {
    id = json['brend_id']??0;
    nomi = json['nomi']??"";
    img = json['rasmi']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brend_id'] = this.id;
    data['nomi'] = this.nomi;
    data['rasmi'] = this.img;
    return data;
  }
}