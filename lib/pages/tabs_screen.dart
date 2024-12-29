import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sywari/pages/schedule_screen.dart';
import 'package:sywari/pages/settings_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  late final bool isDark = Theme.of(context).brightness == Brightness.dark;

  void _selectPage(int index) async {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Widget activePage = const ScheduleScreen();
    if (_selectedPageIndex == 0) {
      activePage = const ScheduleScreen();
    }
    if (_selectedPageIndex == 1) {
      activePage = const SettingsScreen();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? Color.fromARGB(255, 40, 40, 40)
            : Color.fromARGB(255, 235, 235, 235),
        scrolledUnderElevation: 0,
        title: Container(
          height: 48,
          width: 77,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/navigation_top.png'),
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark
            ? Color.fromARGB(255, 40, 40, 40)
            : Color.fromARGB(255, 235, 235, 235),
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 20,
        elevation: 16,
        selectedItemColor: const Color.fromARGB(255, 40, 80, 200),
        unselectedItemColor: const Color(0xff979797),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: SvgPicture.asset('assets/icons/home_unselected.svg'),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: SvgPicture.asset('assets/icons/home_selected.svg'),
            ),
            label: 'Расписание',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: SvgPicture.asset('assets/icons/setting_unselected.svg'),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: SvgPicture.asset('assets/icons/setting_selected.svg'),
            ),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
