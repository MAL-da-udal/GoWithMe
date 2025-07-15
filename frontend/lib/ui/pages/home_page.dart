import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/bottom_tabs/profile_tab.dart';
import 'package:frontend/ui/pages/bottom_tabs/search_tab.dart';
import 'package:frontend/ui/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  final String? index;
  const HomePage({super.key, this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = int.tryParse(widget.index ?? '0') ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [SearchTab(), ProfileTab()],
      ),
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,

              title: Text(
                'Найти компаньона',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCirc,
          );
        },
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
