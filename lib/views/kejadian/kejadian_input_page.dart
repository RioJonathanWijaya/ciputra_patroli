import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InputLaporanPage extends StatefulWidget {
  const InputLaporanPage({super.key});

  @override
  State<InputLaporanPage> createState() => InputLaporanPageState();
}

class InputLaporanPageState extends State<InputLaporanPage> {
  final Color primaryColor = const Color(0xff11c3a6b);
  final TextEditingController titleController = TextEditingController();
  final TextEditingController responsibleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImages.add(File(image.path));
      });
    }
  }

  void showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 30),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Ambil dari Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Pilih dari Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void saveLaporan() {
    String title = titleController.text;
    String responsible = responsibleController.text;
    String location = locationController.text;
    String description = descriptionController.text;

    if (title.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        responsible.isEmpty ||
        location.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua bidang harus diisi")),
      );
      return;
    }

    print(
        "Laporan Disimpan:\nNama: $title\nTanggal: ${selectedDate!.toLocal()}\nJam: ${selectedTime!.format(context)}\nPenanggung Jawab: $responsible\nLokasi: $location\nDeskripsi: $description\nGambar: ${selectedImages.length}");

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Laporan"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle("Informasi Kejadian"),
            buildTextField(titleController, "Nama Kejadian", Icons.event),
            buildDatePicker("Tanggal Kejadian"),
            buildTimePicker("Jam Kejadian"),
            const SizedBox(height: 20),
            buildSectionTitle("Penanggung Jawab"),
            buildTextField(responsibleController, "Penanggung Jawab Kejadian",
                Icons.person),
            const SizedBox(height: 20),
            buildSectionTitle("Lokasi Kejadian"),
            buildTextField(
                locationController, "Lokasi Kejadian", Icons.location_on),
            const SizedBox(height: 20),
            buildSectionTitle("Foto Kejadian"),
            selectedImages.isNotEmpty
                ? SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(selectedImages[index],
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () => removeImage(index),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 12,
                                  child: Icon(Icons.close,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : const Text("Belum ada gambar yang dipilih",
                    style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: showImageSourceDialog,
              icon: const Icon(Icons.add_a_photo),
              label: const Text("Pilih Gambar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            buildSectionTitle("Deskripsi Kejadian"),
            buildTextField(
                descriptionController, "Deskripsi Kejadian", Icons.description,
                maxLines: 4),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveLaporan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Simpan Laporan",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryColor),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }

  Widget buildDatePicker(String label) {
    return buildPickerField(
        label,
        Icons.calendar_today,
        pickDate,
        selectedDate != null
            ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
            : "");
  }

  Widget buildTimePicker(String label) {
    return buildPickerField(label, Icons.access_time, pickTime,
        selectedTime != null ? selectedTime!.format(context) : "");
  }

  Widget buildPickerField(
      String label, IconData icon, VoidCallback onTap, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }
}
