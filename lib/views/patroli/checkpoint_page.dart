import 'dart:developer';

import 'package:ciputra_patroli/models/checkpoint.dart';
import 'package:ciputra_patroli/models/patroli.dart';
import 'package:ciputra_patroli/models/penugasan.dart';
import 'package:ciputra_patroli/viewModel/patroli_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CheckpointPage extends StatefulWidget {
  const CheckpointPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckpointPage> createState() => _CheckpointPageState();
}

class _CheckpointPageState extends State<CheckpointPage> {
  File? _selectedImage;
  final TextEditingController _keteranganController = TextEditingController();
  bool _isLoading = false;
  DateTime? _captureTime;
  final Color _primaryColor = const Color(0xFF1C3A6B);
  final Color _accentColor = const Color(0xFF4CAF50);
  final Color _errorColor = const Color(0xFFE53935);

  late Patroli patroli;
  late Penugasan penugasan;
  late int currentIndex;
  late PatroliViewModel patroliViewModel;

  List<Map<String, dynamic>> checkpoints = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    patroli = args['patroli'];
    penugasan = args['penugasan'];
    currentIndex = args['currentIndex'];
    patroliViewModel = args['patroliVM'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _captureTime = DateTime.now();
      });
    }
  }

  void _submitCheckpoint() async {
    if (_selectedImage == null) {
      _showErrorDialog('Foto Wajib', 'Ambil foto untuk bukti patroli.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await patroliViewModel.submitCheckpoint(
        patroli: patroli,
        penugasan: penugasan,
        currentIndex: currentIndex,
        imagePath: _selectedImage!.path,
        timestamp: _captureTime!,
        keterangan: _keteranganController.text,
      );

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog('Error', 'Gagal menyimpan checkpoint: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil', style: TextStyle(color: Colors.green)),
        content: const Text('Checkpoint berhasil disimpan!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, currentIndex);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkpoint = penugasan.titikPatroli[currentIndex];
    final progress = (currentIndex + 1) / penugasan.titikPatroli.length;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Checkpoint ${currentIndex + 1}/${penugasan.titikPatroli.length}',
        style: const TextStyle(color: Colors.white),
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: _accentColor,
              minHeight: 8,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Checkpoint Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Lat: ${checkpoint['lat']}, Lng: ${checkpoint['lng']}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Patrol Evidence Photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedImage == null
                        ? Colors.grey[400]!
                        : _accentColor,
                    width: 1.5,
                  ),
                ),
                child: _selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt,
                              size: 48, color: Colors.grey[500]),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to take photo',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 8),
              Text(
                'Photo taken: ${_captureTime?.toString() ?? 'Unknown time'}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Additional Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _keteranganController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                labelText: 'Enter notes (optional)',
                alignLabelWithHint: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitCheckpoint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'SAVE CHECKPOINT',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
