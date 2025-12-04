import 'package:flutter/material.dart';
import 'package:turbo_vets_assessment/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/screens/conversations_screen.dart';
import 'package:turbo_vets_assessment/features/web/presentation/screen/web_view_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final _screens = [const ConversationsScreen(), const WebViewScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [Expanded(child: _screens.elementAt(_selectedIndex))],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        currentIndex: _selectedIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          for (final tabItem in BottomNavBarItem.items)
            BottomNavBarItem(text: tabItem.text, icon: tabItem.icon),
        ],
        selectedItems: [
          for (final selectedTabItem in BottomNavBarItem.selectedItems)
            BottomNavBarItem(
              text: selectedTabItem.text,
              icon: selectedTabItem.icon,
            ),
        ],
      ),
    );
  }
}
