import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ciputra_patroli/models/kejadian.dart';
import 'package:ciputra_patroli/viewModel/kejadian_viewModel.dart';
import 'package:ciputra_patroli/viewModel/login_viewModel.dart';

class KejadianInputPage extends StatefulWidget {
  const KejadianInputPage({super.key});

  @override
  State<KejadianInputPage> createState() => _KejadianInputPageState();
}

class _KejadianInputPageState extends State<KejadianInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaKejadianController = TextEditingController();
  final TextEditingController _tanggalKejadianController =
      TextEditingController();
  final TextEditingController _lokasiKejadianController =
      TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _namaKorbanController = TextEditingController();
  final TextEditingController _alamatKorbanController = TextEditingController();
  final TextEditingController _keteranganKorbanController =
      TextEditingController();

  DateTime? _selectedDate;
  XFile? _imageFile;
  bool _isKecelakaan = false;
  bool _isPencurian = false;
  bool _isNotifikasi = false;
  String? _selectedTipeKejadian;

  List<String> tipeKejadianOptions = ['Ringan', 'Sedang', 'Berat', 'Kritis'];

  @override
  void initState() {
    super.initState();
    _tanggalKejadianController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _namaKejadianController.dispose();
    _tanggalKejadianController.dispose();
    _lokasiKejadianController.dispose();
    _keteranganController.dispose();
    _namaKorbanController.dispose();
    _alamatKorbanController.dispose();
    _keteranganKorbanController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalKejadianController.text =
            DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final loginVM = Provider.of<LoginViewModel>(context, listen: false);
      final kejadianVM = Provider.of<KejadianViewModel>(context, listen: false);

      final kejadian = Kejadian(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          namaKejadian: _namaKejadianController.text,
          tanggalKejadian: _selectedDate!,
          lokasiKejadian: _lokasiKejadianController.text,
          tipeKejadian: _selectedTipeKejadian!,
          keterangan: _keteranganController.text,
          fotoBuktiPath: _imageFile?.path,
          isKecelakaan: _isKecelakaan,
          isPencurian: _isPencurian,
          isNotifikasi: _isNotifikasi,
          namaKorban:
              _isKecelakaan || _isPencurian ? _namaKorbanController.text : null,
          alamatKorban: _isKecelakaan || _isPencurian
              ? _alamatKorbanController.text
              : null,
          keteranganKorban: _isKecelakaan || _isPencurian
              ? _keteranganKorbanController.text
              : null,
          satpamId: loginVM.satpamId ?? '',
          satpamNama: loginVM.satpam?.nama ?? 'Satpam',
          waktuLaporan: DateTime.now(),
          waktuSelesai: null,
          status: "Aktif");

      final success = await kejadianVM.saveKejadian(kejadian);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laporan kejadian berhasil disimpan')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan laporan kejadian')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Laporan Kejadian"),
        backgroundColor: const Color(0xFF1C3A6B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Satpam Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Consumer<LoginViewModel>(
                  builder: (context, loginVM, child) {
                    return Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1C3A6B).withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: Color(0xFF1C3A6B),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pelapor:",
                              style: TextStyle(
                                color: Color(0xFF757575),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              loginVM.satpam?.nama ?? "Satpam",
                              style: const TextStyle(
                                color: Color(0xFF1C3A6B),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Waktu: ${DateFormat('HH:mm').format(DateTime.now())}",
                              style: const TextStyle(
                                color: Color(0xFF757575),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detail Kejadian",
                      style: TextStyle(
                        color: Color(0xFF1C3A6B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _namaKejadianController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Kejadian',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan nama kejadian';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tanggalKejadianController,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Kejadian',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap pilih tanggal kejadian';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _lokasiKejadianController,
                      decoration: const InputDecoration(
                        labelText: 'Lokasi Kejadian',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan lokasi kejadian';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedTipeKejadian,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Kejadian',
                        border: OutlineInputBorder(),
                      ),
                      items: tipeKejadianOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTipeKejadian = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap pilih tipe kejadian';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _keteranganController,
                      decoration: const InputDecoration(
                        labelText: 'Keterangan Kejadian',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan keterangan kejadian';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Foto Bukti Kejadian',
                          style: TextStyle(
                            color: Color(0xFF757575),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _imageFile == null
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.camera_alt,
                                            size: 40, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text('Ambil Foto'),
                                      ],
                                    ),
                                  )
                                : FutureBuilder(
                                    future: _imageFile!.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                          child: Icon(Icons.error,
                                              color: Colors.red),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                          ),
                        ),
                        if (_imageFile != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextButton(
                              onPressed: () =>
                                  setState(() => _imageFile = null),
                              child: const Text(
                                'Hapus Foto',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Jenis Kejadian:',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _isKecelakaan,
                          onChanged: (bool? value) {
                            setState(() {
                              _isKecelakaan = value ?? false;
                              if (_isKecelakaan) {
                                _isPencurian = false;
                              }
                            });
                          },
                          activeColor: const Color(0xFF1C3A6B),
                        ),
                        const Text('Kecelakaan'),
                        const SizedBox(width: 16),
                        Checkbox(
                          value: _isPencurian,
                          onChanged: (bool? value) {
                            setState(() {
                              _isPencurian = value ?? false;
                              if (_isPencurian) {
                                _isKecelakaan = false;
                              }
                            });
                          },
                          activeColor: const Color(0xFF1C3A6B),
                        ),
                        const Text('Pencurian'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _isNotifikasi,
                          onChanged: (bool? value) {
                            setState(() {
                              _isNotifikasi = value ?? false;
                              log(_isNotifikasi.toString());
                            });
                          },
                          activeColor: const Color(0xFF1C3A6B),
                        ),
                        const Text('Kirim Notifikasi ke Satpam Lain'),
                      ],
                    ),
                  ],
                ),
              ),

              if (_isKecelakaan || _isPencurian) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isKecelakaan
                            ? 'Detail Korban Kecelakaan'
                            : 'Detail Korban Pencurian',
                        style: const TextStyle(
                          color: Color(0xFF1C3A6B),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _namaKorbanController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Korban',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((_isKecelakaan || _isPencurian) &&
                              (value == null || value.isEmpty)) {
                            return 'Harap masukkan nama korban';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _alamatKorbanController,
                        decoration: const InputDecoration(
                          labelText: 'Alamat Korban',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if ((_isKecelakaan || _isPencurian) &&
                              (value == null || value.isEmpty)) {
                            return 'Harap masukkan alamat korban';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _keteranganKorbanController,
                        decoration: const InputDecoration(
                          labelText: 'Keterangan Korban',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if ((_isKecelakaan || _isPencurian) &&
                              (value == null || value.isEmpty)) {
                            return 'Harap masukkan keterangan korban';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C3A6B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Simpan Laporan Kejadian',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
