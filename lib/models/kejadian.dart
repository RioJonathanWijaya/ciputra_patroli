class Kejadian {
  final String id;
  final String namaKejadian;
  final DateTime tanggalKejadian;
  final String lokasiKejadian;
  final String tipeKejadian;
  final String keterangan;
  final String? fotoBuktiPath;
  final bool isKecelakaan;
  final bool isPencurian;
  final bool isNotifikasi;
  final String? namaKorban;
  final String? alamatKorban;
  final String? keteranganKorban;
  final String satpamId;
  final String satpamNama;
  final DateTime waktuLaporan;
  DateTime? waktuSelesai;
  String status;

  Kejadian({
    required this.id,
    required this.namaKejadian,
    required this.tanggalKejadian,
    required this.lokasiKejadian,
    required this.tipeKejadian,
    required this.keterangan,
    this.fotoBuktiPath,
    required this.isKecelakaan,
    required this.isPencurian,
    required this.isNotifikasi,
    this.namaKorban,
    this.alamatKorban,
    this.keteranganKorban,
    required this.satpamId,
    required this.satpamNama,
    required this.waktuLaporan,
    this.waktuSelesai,
    required this.status,
  });

  factory Kejadian.fromMap(Map<String, dynamic> map) {
    return Kejadian(
      id: map['id'] ?? '',
      namaKejadian: map['nama_kejadian'] ?? '',
      tanggalKejadian:
          DateTime.tryParse(map['tanggal_kejadian'] ?? '') ?? DateTime.now(),
      lokasiKejadian: map['lokasi_kejadian'] ?? '',
      tipeKejadian: map['tipe_kejadian'] ?? '',
      keterangan: map['keterangan'] ?? '',
      isKecelakaan: map['is_kecelakaan'] ?? false,
      isPencurian: map['is_pencurian'] ?? false,
      isNotifikasi: map['is_notifikasi'] ?? false,
      namaKorban: map['nama_korban'] ?? '',
      alamatKorban: map['alamat_korban'] ?? '',
      keteranganKorban: map['keterangan_korban'] ?? '',
      satpamId: map['satpam_id'] ?? '',
      satpamNama: map['satpam_nama'] ?? '',
      waktuLaporan:
          DateTime.tryParse(map['waktu_laporan'] ?? '') ?? DateTime.now(),
      waktuSelesai: map['waktu_selesai'] != null
          ? DateTime.tryParse(map['waktu_selesai'])
          : null,
      status: map['status'] ?? '',
      fotoBuktiPath: map['foto_bukti_kejadian'] is String
          ? map['foto_bukti_kejadian']
          : (map['foto_bukti_kejadian'] is List &&
                  map['foto_bukti_kejadian'].isNotEmpty
              ? map['foto_bukti_kejadian'][0]
              : null),
    );
  }

  factory Kejadian.empty() => Kejadian(
        id: '',
        namaKejadian: '',
        tanggalKejadian: DateTime.now(),
        lokasiKejadian: '',
        tipeKejadian: '',
        keterangan: '',
        fotoBuktiPath: '',
        isKecelakaan: false,
        isPencurian: false,
        isNotifikasi: false,
        namaKorban: '',
        alamatKorban: '',
        keteranganKorban: '',
        satpamId: '',
        satpamNama: '',
        waktuLaporan: DateTime.now(),
        waktuSelesai: null,
        status: '',
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_kejadian': namaKejadian,
      'tanggal_kejadian': tanggalKejadian.toIso8601String(),
      'lokasi_kejadian': lokasiKejadian,
      'tipe_kejadian': tipeKejadian,
      'keterangan': keterangan,
      'foto_bukti_kejadian': fotoBuktiPath ?? [],
      'is_kecelakaan': isKecelakaan,
      'is_pencurian': isPencurian,
      'is_notifikasi': isNotifikasi,
      'nama_korban': namaKorban ?? "",
      'alamat_korban': alamatKorban ?? "",
      'keterangan_korban': keteranganKorban ?? "",
      'satpam_id': satpamId,
      'satpam_nama': satpamNama,
      'waktu_laporan': waktuLaporan.toIso8601String(),
      'waktu_selesai': waktuSelesai?.toIso8601String() ?? "",
      'status': status
    };
  }
}
