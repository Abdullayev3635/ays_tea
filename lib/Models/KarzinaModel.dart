class KarzinaModel {
  late int id;
  late String nomi;
  late String tovarId;
  late String brendId;
  late String blokSoni;
  late String kirimNarxi;
  late String nalichNarxi;
  late String perechNarxi;
  late String optomNarxi;
  late String rasmi;
  late String userId;
  late String qoldiq;
  late String miqdorBlok;
  late String miqdorSoni;

  KarzinaModel(
      {required this.id,
      required this.nomi,
      required this.tovarId,
      required this.brendId,
      required this.blokSoni,
      required this.kirimNarxi,
      required this.nalichNarxi,
      required this.perechNarxi,
      required this.optomNarxi,
      required this.rasmi,
      required this.userId,
      required this.qoldiq,
      required this.miqdorBlok,
      required this.miqdorSoni});

  KarzinaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    nomi = json['nomi'] ?? 0;
    tovarId = json['tovarId'] ?? 0;
    brendId = json['brendId'] ?? 0;
    blokSoni = json['blokSoni'] ?? 0;
    kirimNarxi = json['kirimNarxi'] ?? "";
    nalichNarxi = json['nalichNarxi'] ?? "0";
    perechNarxi = json['perechNarxi'] ?? 0;
    optomNarxi = json['optomNarxi'] ?? "";
    rasmi = json['rasmi'] ?? "";
    userId = json['userId'] ?? "";
    qoldiq = json['qoldiq'] ?? "";
    miqdorBlok = json['miqdorBlok'] ?? "";
    miqdorSoni = json['miqdorSoni'] ?? "";
  }

  factory KarzinaModel.fromMap(Map<String, dynamic> json) => KarzinaModel(
        id: json['id'],
        nomi: json['nomi'],
        tovarId: json['tovarId'],
        brendId: json['brendId'],
        blokSoni: json['blokSoni'],
        kirimNarxi: json['kirimNarxi'],
        nalichNarxi: json['nalichNarxi'],
        perechNarxi: json['perechNarxi'],
        optomNarxi: json['optomNarxi'],
        rasmi: json['rasmi'],
        userId: json['userId'],
        qoldiq: json['qoldiq'],
        miqdorBlok: json['miqdorBlok'],
        miqdorSoni: json['miqdorSoni'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nomi'] = this.nomi;
    data['tovarId'] = this.tovarId;
    data['brendId'] = this.brendId;
    data['blokSoni'] = this.blokSoni;
    data['kirimNarxi'] = this.kirimNarxi;
    data['nalichNarxi'] = this.nalichNarxi;
    data['perechNarxi'] = this.perechNarxi;
    data['optomNarxi'] = this.optomNarxi;
    data['rasmi'] = this.rasmi;
    data['userId'] = this.userId;
    data['qoldiq'] = this.qoldiq;
    data['miqdorBlok'] = this.miqdorBlok;
    data['miqdorSoni'] = this.miqdorSoni;
    return data;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "nomi": nomi,
        "tovarId": tovarId,
        "brendId": brendId,
        "blokSoni": blokSoni,
        "kirimNarxi": kirimNarxi,
        "nalichNarxi": nalichNarxi,
        "perechNarxi": perechNarxi,
        "optomNarxi": optomNarxi,
        "rasmi": rasmi,
        "userId": userId,
        "qoldiq": qoldiq,
        "miqdorBlok": miqdorBlok,
        "miqdorSoni": miqdorSoni
      };
}
