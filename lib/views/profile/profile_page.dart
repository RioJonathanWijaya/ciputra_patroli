import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile_placeholder.png'),
              ),
            ),
            SizedBox(height: 16),
            Text('Nama Pengguna',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('user@example.com',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff11c3a6b).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileInfo('Nama Satpam', 'Ahmad Gozal'),
                  _buildProfileInfo('Status', 'Aktif'),
                  _buildProfileInfo('Lokasi Jaga', 'Gedung A - Lantai 3'),
                  _buildProfileInfo('Tanggal Masuk', '12 Januari 2020'),
                  SizedBox(height: 16),
                  _buildProfileOption(Icons.person, 'Edit Profil', () {}),
                  _buildProfileOption(Icons.lock, 'Ubah Kata Sandi', () {}),
                  _buildProfileOption(
                      Icons.notifications, 'Pengaturan Notifikasi', () {}),
                  _buildProfileOption(Icons.logout, 'Keluar', () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xff11c3a6b)),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildProfileInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff11c3a6b))),
          ),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
