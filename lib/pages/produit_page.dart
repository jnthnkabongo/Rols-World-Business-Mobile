import 'package:flutter/material.dart';
import 'package:rols/services/api_service.dart';

class Produit {
  final int id;
  final String nom;
  final String? description;
  final String prixVente;
  final String deviseId;
  final String? modele;
  final String status;
  final String? taille;
  final DateTime createdAt;
  final IconData categoryIcon;

  Produit({
    required this.id,
    required this.nom,
    this.description,
    required this.prixVente,
    required this.deviseId,
    this.modele,
    required this.status,
    this.taille,
    required this.createdAt,
    required this.categoryIcon,
  });

  factory Produit.fromJson(Map<String, dynamic> json, IconData icon) {
    return Produit(
      id: json['id'],
      nom: json['nom'] ?? '',
      description: json['description'],
      prixVente: json['prix_vente']?.toString() ?? '0',
      deviseId: json['devise_id']?.toString() ?? '0',
      modele: json['modele'],
      status: json['status'] ?? 'unknown',
      taille: json['taille'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      categoryIcon: icon,
    );
  }

  String get deviseSymbole {
    if (deviseId == '1') {
      return '\$';
    } else if (deviseId == '2') {
      return 'FC';
    }
    return '';
  }
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
  bool _isLoading = false;

  List<Produit> _electroniques = [];
  List<Produit> _chaussures = [];
  List<Produit> _accessoires = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProduits();
  }

  Future<void> _loadProduits() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final produitsData = await ApiService.getProduits();

      setState(() {
        _electroniques =
            (produitsData['listes_produits_electroniques'] as List<dynamic>? ??
                    [])
                .map(
                  (json) => Produit.fromJson(
                    json as Map<String, dynamic>,
                    Icons.phone_android,
                  ),
                )
                .toList();
        _chaussures =
            (produitsData['listes_produits_accesoires'] as List<dynamic>? ?? [])
                .map(
                  (json) => Produit.fromJson(
                    json as Map<String, dynamic>,
                    Icons.sports,
                  ),
                )
                .toList();
        _accessoires =
            (produitsData['listes_produits_chaussures'] as List<dynamic>? ?? [])
                .map(
                  (json) => Produit.fromJson(
                    json as Map<String, dynamic>,
                    Icons.headphones,
                  ),
                )
                .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur chargement produits: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Produit> get _filteredElectroniques {
    if (_searchController.text.isEmpty) {
      return _electroniques;
    }
    final query = _searchController.text.toLowerCase();
    return _electroniques.where((produit) {
      return produit.nom.toLowerCase().contains(query) ||
          (produit.modele?.toLowerCase().contains(query) ?? false) ||
          (produit.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  List<Produit> get _filteredChaussures {
    if (_searchController.text.isEmpty) {
      return _chaussures;
    }
    final query = _searchController.text.toLowerCase();
    return _chaussures.where((produit) {
      return produit.nom.toLowerCase().contains(query) ||
          (produit.modele?.toLowerCase().contains(query) ?? false) ||
          (produit.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  List<Produit> get _filteredAccessoires {
    if (_searchController.text.isEmpty) {
      return _accessoires;
    }
    final query = _searchController.text.toLowerCase();
    return _accessoires.where((produit) {
      return produit.nom.toLowerCase().contains(query) ||
          (produit.modele?.toLowerCase().contains(query) ?? false) ||
          (produit.description?.toLowerCase().contains(query) ?? false);
    }).toList();
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
                size: 20,
              ),
            ),

            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    produit.nom,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 25),
                Text(
                  '${produit.prixVente} ${produit.deviseSymbole}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
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
                      'Modèle: ${produit.modele ?? 'N/A'}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.tag_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    // Text(
                    //   'Status: ${produit.status}',
                    //   style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    // ),
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
                      'Enregistré le: ${_formatDate(produit.createdAt)}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                SizedBox(width: 1),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  color: Colors.white,
                  onSelected: (String choice) {
                    _handleMenuChoice(choice, produit);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'remise',
                        child: Row(
                          children: [
                            Icon(
                              Icons.discount,
                              color: Colors.blue[900],
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text('Remise'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'vente',
                        child: Row(
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              color: Colors.green[700],
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text('Vente'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleMenuChoice(String choice, Produit produit) {
    switch (choice) {
      case 'remise':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Remise: ${produit.nom}')));
        break;
      case 'vente':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Vente: ${produit.nom}')));
        break;
    }
  }
}
