class MijozModel {
  String? mijozId;
  String? regionId;
  String? fio;
  String? inn;
  String? boshagan;
  String? telefon;
  String? parol;

  MijozModel(
      {this.mijozId,
        this.regionId,
        this.fio,
        this.inn,
        this.boshagan,
        this.telefon,
        this.parol});

  MijozModel.fromJson(Map<String, dynamic> json) {
    mijozId = json['mijoz_id'];
    regionId = json['region_id'];
    fio = json['fio'];
    inn = json['inn'];
    boshagan = json['boshagan'];
    telefon = json['telefon'];
    parol = json['parol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mijoz_id'] = this.mijozId;
    data['region_id'] = this.regionId;
    data['fio'] = this.fio;
    data['inn'] = this.inn;
    data['boshagan'] = this.boshagan;
    data['telefon'] = this.telefon;
    data['parol'] = this.parol;
    return data;
  }
}