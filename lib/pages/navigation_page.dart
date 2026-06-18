// import 'package:flutter/material.dart';

// class HomeWithBottomNav extends StatefulWidget {
//   const HomeWithBottomNav({super.key});

//   @override
//   State<HomeWithBottomNav> createState() => _HomeWithBottomNavState();
// }

// class _HomeWithBottomNavState extends State<HomeWithBottomNav> {
//   int _index = 0;

//   final _pages = const [
//     Center(child: Text("Accueil")),
//     Center(child: Text("Produits")),
//     Center(child: Text("Panier")),
//     Center(child: Text("Profil")),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _pages[_index],
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           currentIndex: _index,
//           onTap: (i) => setState(() => _index = i),
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.white,
//           selectedItemColor: const Color(0xFF0D47A1),
//           unselectedItemColor: Colors.grey[400],
//           selectedFontSize: 14,
//           unselectedFontSize: 12,
//           iconSize: 24,
//           elevation: 0,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home_outlined),
//               activeIcon: Icon(Icons.home),
//               label: "Accueil",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_bag_outlined),
//               activeIcon: Icon(Icons.shopping_bag),
//               label: "Produits",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart_outlined),
//               activeIcon: Icon(Icons.shopping_cart),
//               label: "Ventes",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person_outline),
//               activeIcon: Icon(Icons.person),
//               label: "Renise",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.settings_outlined),
//               activeIcon: Icon(Icons.settings),
//               label: "Paramètres",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:rols/pages/home_page.dart';
import 'package:rols/pages/parametre_page.dart';
import 'package:rols/pages/produit_page.dart';
import 'package:rols/pages/remise_page.dart';
import 'package:rols/pages/vente_page.dart';

class HomeWithBottomNav extends StatefulWidget {
  const HomeWithBottomNav({super.key});

  @override
  State<HomeWithBottomNav> createState() => _HomeWithBottomNavState();
}

class _HomeWithBottomNavState extends State<HomeWithBottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ProduitPage(),
    VentePage(),
    RemisePage(),
    ParametrePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'Accueil',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.shopping_bag_outlined,
                  selectedIcon: Icons.shopping_bag,
                  label: 'Produits',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.shopping_cart_outlined,
                  selectedIcon: Icons.shopping_cart,
                  label: 'Ventes',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.compare_arrows_outlined,
                  selectedIcon: Icons.compare_arrows,
                  label: 'Remises',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings_rounded,
                  label: 'Paramètres',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0D47A1).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isSelected ? selectedIcon : icon,
                key: ValueKey(isSelected ? selectedIcon : icon),
                color: isSelected
                    ? const Color(0xFF0D47A1)
                    : Colors.grey.shade600,
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF0D47A1)
                    : Colors.grey.shade600,
                fontSize: isSelected ? 12 : 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
