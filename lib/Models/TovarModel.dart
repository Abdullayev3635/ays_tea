class TovarModel {
  String? brendId;
  String? tovarId;
  String? nomi;
  String? rasmi;
  String? kirimNarxi;
  String? nalichNarxi;
  String? perechNarxi;
  String? optomNarxi;
  String? artikul;
  String? blokSoni;
  String? bloklandi;
  String? norma;
  String? qoldiq;

  TovarModel(
      {this.brendId,
        this.tovarId,
        this.nomi,
        this.rasmi,
        this.kirimNarxi,
        this.nalichNarxi,
        this.perechNarxi,
        this.optomNarxi,
        this.artikul,
        this.blokSoni,
        this.bloklandi,
        this.norma,
        this.qoldiq});

  TovarModel.fromJson(Map<String, dynamic> json) {
    brendId = json['brend_id'];
    tovarId = json['tovar_id'];
    nomi = json['nomi'];
    rasmi = json['rasmi'];
    kirimNarxi = json['kirim_narxi'];
    nalichNarxi = json['nalich_narxi'];
    perechNarxi = json['perech_narxi'];
    optomNarxi = json['optom_narxi'];
    artikul = json['artikul'];
    blokSoni = json['blok_soni'];
    bloklandi = json['bloklandi']??"0";
    norma = json['norma']??"0";
    qoldiq = json['qoldiq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brend_id'] = this.brendId;
    data['tovar_id'] = this.tovarId;
    data['nomi'] = this.nomi;
    data['rasmi'] = this.rasmi;
    data['kirim_narxi'] = this.kirimNarxi;
    data['nalich_narxi'] = this.nalichNarxi;
    data['perech_narxi'] = this.perechNarxi;
    data['optom_narxi'] = this.optomNarxi;
    data['artikul'] = this.artikul;
    data['blok_soni'] = this.blokSoni;
    data['bloklandi'] = this.bloklandi;
    data['norma'] = this.norma;
    data['qoldiq'] = this.qoldiq;
    return data;
  }
}