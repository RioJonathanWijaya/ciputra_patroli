import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ciputra_patroli/models/kejadian.dart';
import 'package:ciputra_patroli/viewModel/kejadian_viewModel.dart';
import 'package:ciputra_patroli/viewModel/login_viewModel.dart';

class KejadianListPage extends StatefulWidget {
  const KejadianListPage({super.key});

  @override
  State<KejadianListPage> createState() => _KejadianListPageState();
}

class _KejadianListPageState extends State<KejadianListPage> {
  bool _initialLoadComplete = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return ChangeNotifierProvider<KejadianViewModel>(
          create: (_) => KejadianViewModel(),
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            body: Consumer<KejadianViewModel>(
              builder: (context, kejadianVM, child) {
                if (!_initialLoadComplete && !kejadianVM.isLoading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    kejadianVM.getAllKejadianData().then((_) {
                      setState(() {
                        _initialLoadComplete = true;
                      });
                    });
                  });
                }

                if (kejadianVM.isLoading && !_initialLoadComplete) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF1C3A6B)),
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: RefreshIndicator(
                          color: const Color(0xFF1C3A6B),
                          onRefresh: () => kejadianVM.getAllKejadianData(),
                          child: kejadianVM.kejadianList.isEmpty &&
                                  _initialLoadComplete
                              ? _buildEmptyState(context)
                              : ListView.separated(
                                  itemCount: kejadianVM.kejadianList.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final kejadian =
                                        kejadianVM.kejadianList[index];
                                    return GestureDetector(
                                      onTap: () => _showKejadianDetail(
                                          context, kejadian),
                                      child: _buildKejadianCard(kejadian),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/kejadianInput');
              },
              backgroundColor: const Color(0xFF1C3A6B),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Color(0xFF9E9E9E),
          ),
          SizedBox(height: 16),
          Text(
            'Tidak Ada Laporan Kejadian',
            style: TextStyle(
              color: Color(0xFF1C3A6B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Belum ada kejadian yang dilaporkan. Tekan tombol + di atas untuk membuat laporan baru.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF757575),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKejadianCard(Kejadian kejadian) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
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
                      color: Color(0xFF1C3A6B),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getColorForTipeKejadian(kejadian.tipeKejadian),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    kejadian.tipeKejadian,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: Color(0xFF757575)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    kejadian.lokasiKejadian,
                    style: const TextStyle(
                      color: Color(0xFF757575),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 16, color: Color(0xFF757575)),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm')
                      .format(kejadian.tanggalKejadian),
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 12,
                  ),
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
                    color: const Color(0xFF1C3A6B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    kejadian.isKecelakaan ? 'Kecelakaan' : 'Pencurian',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C3A6B),
                    ),
                  ),
                ],
              ),
              if (kejadian.namaKorban != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Korban: ${kejadian.namaKorban}',
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  void _showKejadianDetail(BuildContext context, Kejadian kejadian) {
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
                  const Text(
                    'Detail Kejadian',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C3A6B),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getColorForTipeKejadian(kejadian.tipeKejadian),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      kejadian.tipeKejadian,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
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
                        title: 'Deskripsi',
                        value:
                            kejadian.keteranganKorban ?? "Tidak ada keterangan",
                      ),
                      if (kejadian.isKecelakaan || kejadian.isPencurian) ...[
                        const Divider(height: 24),
                        Text(
                          kejadian.isKecelakaan
                              ? 'Detail Kecelakaan'
                              : 'Detail Pencurian',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C3A6B),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (kejadian.namaKorban != null)
                          _buildDetailItem(
                            title: 'Nama Korban',
                            value: kejadian.namaKorban!,
                          ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C3A6B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
                Icon(icon, size: 16, color: const Color(0xFF1C3A6B)),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C3A6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForTipeKejadian(String tipe) {
    switch (tipe.toLowerCase()) {
      case 'ringan':
        return Colors.green;
      case 'sedang':
        return Colors.orange;
      case 'berat':
        return Colors.red;
      case 'kritis':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}
