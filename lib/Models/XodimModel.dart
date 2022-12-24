class XodimModel{
  final int id;
  final String telefon;
  final String document;
  final String fio;
  final String manzil;
  final String edit_narx;
  final int turi;
  final int viloyat_id;
  final int region_id;
  final String lat;
  final String lng;
  final String viloyat_nomi;

  XodimModel({ required this.id, required this.telefon, required this.document, required this.fio, required this.manzil,  required this.edit_narx, required this.turi, required this.viloyat_id, required this.region_id, required this.lat, required this.lng, required this.viloyat_nomi});

  factory XodimModel.fromJson(Map<String, dynamic> json) {
    return XodimModel(
      id: json['Id'],
      telefon: json['telefon'],
      document: json['document']??"",
      fio: json['fio'],
      manzil: json['manzil'],
      edit_narx: (json['edit_narx']??"").toString(),
      turi: json['turi'],
      viloyat_id: json['viloyat_id'],
      region_id: json['region_id']??0,
      lat: json['lat']??"",
      lng: json['lng']??"",
      viloyat_nomi: json['viloyat']??"",
    );
  }
   static List<XodimModel> fromJsonList(List list) {
    return list.map((item) => XodimModel.fromJson(item)).toList();
  }

}


