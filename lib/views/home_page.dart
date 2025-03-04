import 'package:ciputra_patroli/views/kejadian/kejadian_list_page.dart';
import 'package:ciputra_patroli/views/notifikasi/notifikasi_page.dart';
import 'package:ciputra_patroli/views/patroli/patroli_page.dart';
import 'package:ciputra_patroli/views/profile/profile_page.dart';
import 'package:ciputra_patroli/widgets/appbar/appbar.dart';
import 'package:ciputra_patroli/widgets/navbar/custom_navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<String> titles = [
    "Patroli",
    "Notifikasi",
    "Pelaporan Kejadian",
    "Profile"
  ];

  final List<Widget> pages = [
    const PatroliPage(),
    NotifikasiPage(),
    const ListKejadian(),
    ProfilePage(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: titles[selectedIndex]),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: selectedIndex,
        onItemSelected: _onItemSelected,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: pages,
      ),
    );
  }
}
