class Satpam {
  final String satpamId;
  final String nama;
  final String nip;
  final String email;
  final String nomorTelepon;
  final String alamat;
  final String tempatLahir;
  final String tanggalLahir;
  final String tanggalBergabung;
  final String pendidikanTerakhir;
  final String fotoProfile;
  final String namaLokasi;
  final int penugasanId;
  final int supervisorId;
  final String lokasiId;
  final int jenisKelamin;
  final int shift;
  final int jabatan;
  final int status;
  final int statusPernikahan;
  final String? fcmToken;

  Satpam(
      {required this.satpamId,
      required this.nama,
      required this.nip,
      required this.email,
      required this.nomorTelepon,
      required this.alamat,
      required this.tempatLahir,
      required this.tanggalLahir,
      required this.tanggalBergabung,
      required this.pendidikanTerakhir,
      required this.fotoProfile,
      required this.jenisKelamin,
      required this.namaLokasi,
      required this.shift,
      required this.jabatan,
      required this.status,
      required this.statusPernikahan,
      required this.supervisorId,
      required this.penugasanId,
      required this.lokasiId,
      this.fcmToken});

  factory Satpam.fromJson(Map<String, dynamic> json) {
    return Satpam(
        satpamId: json['satpam_id'] ?? '',
        nama: json['nama'] ?? '',
        nip: json['nip'] ?? '',
        email: json['email'] ?? '',
        nomorTelepon: json['nomor_telepon'] ?? '',
        alamat: json['alamat'] ?? '',
        tempatLahir: json['tempat_lahir'] ?? '',
        tanggalLahir: json['tanggal_lahir'] ?? '',
        tanggalBergabung: json['tanggal_bergabung'] ?? '',
        pendidikanTerakhir: json['pendidikan_terakhir'] ?? '',
        fotoProfile: json['foto_profile'] ?? '',
        jenisKelamin: json['jenis_kelamin'] ?? 0,
        shift: json['shift'] ?? 0,
        jabatan: json['jabatan'] ?? 0,
        status: json['status'] ?? 0,
        statusPernikahan: json['status_pernikahan'] ?? 0,
        supervisorId: json['supervisor_id'] ?? '',
        penugasanId: json['penugasan_id'] ?? '',
        lokasiId: json['lokasi_id'] ?? '',
        namaLokasi: json['nama_lokasi'] ?? '',
        fcmToken: json['fcm_token']);
  }
}
