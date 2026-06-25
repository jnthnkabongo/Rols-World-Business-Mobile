import 'package:flutter/material.dart';

class Produit {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int quantity;
  final String serialNumber;
  final DateTime registrationDate;
  final IconData categoryIcon;

  Produit({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.serialNumber,
    required this.registrationDate,
    required this.categoryIcon,
  });
}

class ProduitPage extends StatefulWidget {
  const ProduitPage({super.key});

  @override
  State<ProduitPage> createState() => _ProduitPageState();
}

class _ProduitPageState extends State<ProduitPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Produit> _electroniques = [
    Produit(
      name: 'iPhone 15 Pro',
      description: '256GB, Titanium',
      price: 1199.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 15,
      serialNumber: 'IPH-2024-001',
      registrationDate: DateTime(2024, 1, 15),
      categoryIcon: Icons.computer,
    ),
    Produit(
      name: 'MacBook Air M3',
      description: '13 pouces, 8GB RAM',
      price: 1299.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 8,
      serialNumber: 'MAC-2024-002',
      registrationDate: DateTime(2024, 2, 10),
      categoryIcon: Icons.computer,
    ),
    Produit(
      name: 'AirPods Pro 2',
      description: 'USB-C, Active Noise Cancellation',
      price: 249.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 32,
      serialNumber: 'APD-2024-003',
      registrationDate: DateTime(2024, 3, 5),
      categoryIcon: Icons.computer,
    ),
    Produit(
      name: 'Samsung Galaxy S24',
      description: '128GB, Phantom Black',
      price: 899.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 20,
      serialNumber: 'SAM-2024-004',
      registrationDate: DateTime(2024, 4, 20),
      categoryIcon: Icons.computer,
    ),
  ];

  final List<Produit> _chaussures = [
    Produit(
      name: 'Nike Air Max 270',
      description: 'Taille 42, Noir',
      price: 149.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 25,
      serialNumber: 'NIK-2024-001',
      registrationDate: DateTime(2024, 1, 20),
      categoryIcon: Icons.sports_basketball,
    ),
    Produit(
      name: 'Adidas Ultraboost',
      description: 'Taille 43, Blanc',
      price: 179.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 18,
      serialNumber: 'ADI-2024-002',
      registrationDate: DateTime(2024, 2, 15),
      categoryIcon: Icons.sports_basketball,
    ),
    Produit(
      name: 'Puma RS-X',
      description: 'Taille 41, Rouge',
      price: 119.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 12,
      serialNumber: 'PUM-2024-003',
      registrationDate: DateTime(2024, 3, 25),
      categoryIcon: Icons.sports_basketball,
    ),
  ];

  final List<Produit> _accessoires = [
    Produit(
      name: 'Montre Apple Watch',
      description: 'Series 9, GPS',
      price: 399.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 10,
      serialNumber: 'APL-2024-001',
      registrationDate: DateTime(2024, 1, 10),
      categoryIcon: Icons.watch,
    ),
    Produit(
      name: 'Sac à dos Nike',
      description: 'Noir, 30L',
      price: 79.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 45,
      serialNumber: 'NIK-2024-002',
      registrationDate: DateTime(2024, 2, 5),
      categoryIcon: Icons.watch,
    ),
    Produit(
      name: 'Lunettes Ray-Ban',
      description: 'Aviator, Polarized',
      price: 189.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 22,
      serialNumber: 'RAY-2024-003',
      registrationDate: DateTime(2024, 3, 12),
      categoryIcon: Icons.watch,
    ),
    Produit(
      name: 'Casquette Adidas',
      description: 'Noir, Adjustable',
      price: 29.99,
      imageUrl: 'https://via.placeholder.com/150',
      quantity: 50,
      serialNumber: 'ADI-2024-004',
      registrationDate: DateTime(2024, 4, 8),
      categoryIcon: Icons.watch,
    ),
  ];

  List<Produit> get _filteredElectroniques {
    if (_searchController.text.isEmpty) {
      return _electroniques;
    }
    final query = _searchController.text.toLowerCase();
    return _electroniques.where((produit) {
      return produit.name.toLowerCase().contains(query) ||
          produit.serialNumber.toLowerCase().contains(query) ||
          produit.description.toLowerCase().contains(query);
    }).toList();
  }

  List<Produit> get _filteredChaussures {
    if (_searchController.text.isEmpty) {
      return _chaussures;
    }
    final query = _searchController.text.toLowerCase();
    return _chaussures.where((produit) {
      return produit.name.toLowerCase().contains(query) ||
          produit.serialNumber.toLowerCase().contains(query) ||
          produit.description.toLowerCase().contains(query);
    }).toList();
  }

  List<Produit> get _filteredAccessoires {
    if (_searchController.text.isEmpty) {
      return _accessoires;
    }
    final query = _searchController.text.toLowerCase();
    return _accessoires.where((produit) {
      return produit.name.toLowerCase().contains(query) ||
          produit.serialNumber.toLowerCase().contains(query) ||
          produit.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Produits',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue[900],
              labelColor: Colors.blue[900],
              unselectedLabelColor: Colors.blue[900],
              tabs: const [
                Tab(text: 'Électroniques'),
                Tab(text: 'Chaussures'),
                Tab(text: 'Accessoires'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductList(_filteredElectroniques),
                _buildProductList(_filteredChaussures),
                _buildProductList(_filteredAccessoires),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Produit> produits) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: produits.length,
      itemBuilder: (context, index) {
        final produit = produits[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue[900]!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                produit.categoryIcon,
                color: Colors.blue[900],
                size: 28,
              ),
            ),
            title: Text(
              produit.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Quantité: ${produit.quantity}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.tag_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      produit.serialNumber,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Enregistré le: ${_formatDate(produit.registrationDate)}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Text(
              '${produit.price.toStringAsFixed(2)} €',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
