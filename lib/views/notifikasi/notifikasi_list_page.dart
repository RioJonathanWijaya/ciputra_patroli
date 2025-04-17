import 'package:ciputra_patroli/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ciputra_patroli/models/kejadian.dart';
import 'package:ciputra_patroli/viewModel/kejadian_viewModel.dart';

class NotifikasiListPage extends StatefulWidget {
  const NotifikasiListPage({super.key});

  @override
  State<NotifikasiListPage> createState() => _NotifikasiListPageState();
}

class _NotifikasiListPageState extends State<NotifikasiListPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialLoadComplete = false;
  List<Kejadian> _notifikasiList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final kejadianVM = Provider.of<KejadianViewModel>(context, listen: false);
    await kejadianVM.getAllKejadianDataNotifikasi();
    _updateNotifikasiList(kejadianVM);
    setState(() => _initialLoadComplete = true);
  }

  void _updateNotifikasiList(KejadianViewModel kejadianVM) {
    _notifikasiList = kejadianVM.kejadianList
        .where((kejadian) => kejadian.isNotifikasi)
        .toList();
  }

  void _handleNotificationTap(RemoteMessage message) {
    final kejadianId = message.data['kejadian_id'];
    if (kejadianId != null) {
      final kejadianVM = Provider.of<KejadianViewModel>(context, listen: false);
      final kejadian = kejadianVM.kejadianList.firstWhere(
        (k) => k.id == kejadianId,
        orElse: () => Kejadian.empty(),
      );
      if (kejadian.id.isNotEmpty) {
        _showNotifikasiDetail(context, kejadian);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KejadianViewModel>(
      builder: (context, kejadianVM, child) {
        if (_initialLoadComplete) {
          _updateNotifikasiList(kejadianVM);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: _buildContent(kejadianVM),
        );
      },
    );
  }

  Widget _buildContent(KejadianViewModel kejadianVM) {
    if (!_initialLoadComplete && !kejadianVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (kejadianVM.isLoading && !_initialLoadComplete) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () => kejadianVM.getAllKejadianDataNotifikasi(),
      child: _notifikasiList.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _notifikasiList.length,
              itemBuilder: (context, index) {
                final kejadian = _notifikasiList[index];
                return _buildNotifikasiCard(context, kejadian);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Tidak Ada Notifikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada notifikasi kejadian yang perlu ditindaklanjuti',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifikasiCard(BuildContext context, Kejadian kejadian) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showNotifikasiDetail(context, kejadian),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      kejadian.namaKejadian,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(kejadian.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(kejadian.status),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      kejadian.lokasiKejadian,
                      style: TextStyle(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm')
                        .format(kejadian.tanggalKejadian),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              if (kejadian.isKecelakaan || kejadian.isPencurian) ...[
                const Divider(height: 16),
                Row(
                  children: [
                    Icon(
                      kejadian.isKecelakaan ? Icons.car_crash : Icons.warning,
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      kejadian.isKecelakaan ? 'KECELAKAAN' : 'PENCURIAN',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifikasiDetail(BuildContext context, Kejadian kejadian) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail Notifikasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(kejadian.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(kejadian.status),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        icon: Icons.title,
                        title: 'Nama Kejadian',
                        value: kejadian.namaKejadian,
                      ),
                      _buildDetailItem(
                        icon: Icons.location_on,
                        title: 'Lokasi',
                        value: kejadian.lokasiKejadian,
                      ),
                      _buildDetailItem(
                        icon: Icons.access_time,
                        title: 'Waktu Kejadian',
                        value: DateFormat('EEEE, dd MMMM yyyy, HH:mm')
                            .format(kejadian.tanggalKejadian),
                      ),
                      _buildDetailItem(
                        icon: Icons.description,
                        title: 'Keterangan',
                        value: kejadian.keterangan,
                      ),
                      if (kejadian.fotoBuktiPath!.isNotEmpty) ...[
                        const Divider(height: 24),
                        const Text(
                          'Foto Bukti',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            kejadian.fotoBuktiPath ?? "",
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      if (kejadian.isKecelakaan || kejadian.isPencurian) ...[
                        const Divider(height: 24),
                        Text(
                          kejadian.isKecelakaan
                              ? 'Detail Kecelakaan'
                              : 'Detail Pencurian',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (kejadian.namaKorban!.isNotEmpty)
                          _buildDetailItem(
                            title: 'Nama Korban',
                            value: kejadian.namaKorban!,
                          ),
                        if (kejadian.alamatKorban!.isNotEmpty)
                          _buildDetailItem(
                            title: 'Alamat Korban',
                            value: kejadian.alamatKorban!,
                          ),
                        if (kejadian.keteranganKorban!.isNotEmpty)
                          _buildDetailItem(
                            title: 'Keterangan Korban',
                            value: kejadian.keteranganKorban!,
                          ),
                      ],
                      const Divider(height: 24),
                      _buildDetailItem(
                        icon: Icons.person,
                        title: 'Pelapor',
                        value: kejadian.satpamNama,
                      ),
                      _buildDetailItem(
                        icon: Icons.access_time,
                        title: 'Waktu Laporan',
                        value: DateFormat('EEEE, dd MMMM yyyy, HH:mm')
                            .format(kejadian.waktuLaporan),
                      ),
                      if (kejadian.waktuSelesai != null) ...[
                        _buildDetailItem(
                          icon: Icons.check_circle,
                          title: 'Waktu Selesai',
                          value: DateFormat('EEEE, dd MMMM yyyy, HH:mm')
                              .format(kejadian.waktuSelesai!),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ),
                  if (kejadian.status != 'selesai') ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          // Handle action button
                          Navigator.pop(context);
                        },
                        child: const Text('Tindak Lanjut',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem({
    IconData? icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
        return 'BARU';
      case 'diproses':
        return 'DIPROSES';
      case 'selesai':
        return 'SELESAI';
      default:
        return status.toUpperCase();
    }
  }
}
