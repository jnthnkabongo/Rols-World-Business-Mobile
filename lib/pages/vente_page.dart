import 'dart:core';

import 'package:flutter/material.dart';
import 'package:rols/services/api_service.dart';

class Vente {
  final int id;
  final String productName;
  final String? description;
  final double price;
  final int quantity;
  final double total;
  final String clientName;
  final DateTime saleDate;
  final String saleNumber;
  final IconData categoryIcon;
  final String statut;
  final int deviseId;

  Vente({
    required this.id,
    required this.productName,
    this.description,
    required this.price,
    required this.quantity,
    required this.total,
    required this.clientName,
    required this.saleDate,
    required this.saleNumber,
    required this.categoryIcon,
    required this.statut,
    required this.deviseId,
  });

  factory Vente.fromJson(Map<String, dynamic> json, IconData icon) {
    // Récupérer les détails de la vente
    List<dynamic> ventedetails = json['ventedetails'] ?? [];

    // Si pas de détails, valeurs par défaut
    String productName = 'Produit inconnu';
    double price = 0.0;
    int quantity = 0;

    if (ventedetails.isNotEmpty) {
      var firstDetail = ventedetails[0];
      var produitUnite = firstDetail['produit_unite'];
      if (produitUnite != null) {
        var produit = produitUnite['produit'];
        if (produit != null) {
          productName = produit['nom'] ?? 'Produit inconnu';
        }
        price =
            double.tryParse(firstDetail['prix_unitaire']?.toString() ?? '0') ??
            0.0;
        quantity = firstDetail['quantite'] ?? 0;
      }
    }

    // Client
    var client = json['client'];
    String clientName = client != null
        ? client['nom_client'] ?? 'Client inconnu'
        : 'Client inconnu';

    // Date de vente
    DateTime saleDate = DateTime.now();
    String dateVente = json['date_vente'] ?? '';
    if (dateVente.isNotEmpty) {
      try {
        saleDate = DateTime.parse(dateVente);
      } catch (e) {
        saleDate = DateTime.now();
      }
    }

    // Total
    double total = double.tryParse(json['total']?.toString() ?? '0') ?? 0.0;

    // Statut
    String statut = json['statut'] ?? 'inconnu';

    // Devise ID
    int deviseId = json['devise_id'] ?? 1;

    return Vente(
      id: json['id'],
      productName: productName,
      description: null,
      price: price,
      quantity: quantity,
      total: total,
      clientName: clientName,
      saleDate: saleDate,
      saleNumber: 'VTE-${json['id']}',
      categoryIcon: icon,
      statut: statut,
      deviseId: deviseId,
    );
  }

  String get deviseSymbole {
    if (deviseId == 1) {
      return '\$';
    } else if (deviseId == 2) {
      return 'FC';
    }
    return '';
  }
}

class VentePage extends StatefulWidget {
  const VentePage({super.key});

  @override
  State<VentePage> createState() => _VentePageState();
}

class _VentePageState extends State<VentePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  List<Vente> _listeVentes = [];

  // final List<Vente> _ventes = [
  //   Vente(
  //     productName: 'iPhone 15 Pro',
  //     description: '256GB, Titanium',
  //     price: 1199.99,
  //     quantity: 2,
  //     total: 2399.98,
  //     clientName: 'Jean Dupont',
  //     saleDate: DateTime(2024, 6, 15),
  //     saleNumber: 'VTE-2024-001',
  //     categoryIcon: Icons.computer,
  //   ),
  //   Vente(
  //     productName: 'Nike Air Max 270',
  //     description: 'Taille 42, Noir',
  //     price: 149.99,
  //     quantity: 1,
  //     total: 149.99,
  //     clientName: 'Marie Martin',
  //     saleDate: DateTime(2024, 6, 14),
  //     saleNumber: 'VTE-2024-002',
  //     categoryIcon: Icons.sports_basketball,
  //   ),
  //   Vente(
  //     productName: 'MacBook Air M3',
  //     description: '13 pouces, 8GB RAM',
  //     price: 1299.99,
  //     quantity: 1,
  //     total: 1299.99,
  //     clientName: 'Pierre Bernard',
  //     saleDate: DateTime(2024, 6, 13),
  //     saleNumber: 'VTE-2024-003',
  //     categoryIcon: Icons.computer,
  //   ),
  //   Vente(
  //     productName: 'Adidas Ultraboost',
  //     description: 'Taille 43, Blanc',
  //     price: 179.99,
  //     quantity: 3,
  //     total: 539.97,
  //     clientName: 'Sophie Leroy',
  //     saleDate: DateTime(2024, 6, 12),
  //     saleNumber: 'VTE-2024-004',
  //     categoryIcon: Icons.sports_basketball,
  //   ),
  //   Vente(
  //     productName: 'Montre Apple Watch',
  //     description: 'Series 9, GPS',
  //     price: 399.99,
  //     quantity: 1,
  //     total: 399.99,
  //     clientName: 'Luc Petit',
  //     saleDate: DateTime(2024, 6, 11),
  //     saleNumber: 'VTE-2024-005',
  //     categoryIcon: Icons.watch,
  //   ),
  //   Vente(
  //     productName: 'AirPods Pro 2',
  //     description: 'USB-C, Active Noise Cancellation',
  //     price: 249.99,
  //     quantity: 2,
  //     total: 499.98,
  //     clientName: 'Emma Moreau',
  //     saleDate: DateTime(2024, 6, 10),
  //     saleNumber: 'VTE-2024-006',
  //     categoryIcon: Icons.computer,
  //   ),
  //   Vente(
  //     productName: 'Puma RS-X',
  //     description: 'Taille 41, Rouge',
  //     price: 119.99,
  //     quantity: 1,
  //     total: 119.99,
  //     clientName: 'Thomas Dubois',
  //     saleDate: DateTime(2024, 6, 9),
  //     saleNumber: 'VTE-2024-007',
  //     categoryIcon: Icons.sports_basketball,
  //   ),
  //   Vente(
  //     productName: 'Sac à dos Nike',
  //     description: 'Noir, 30L',
  //     price: 79.99,
  //     quantity: 2,
  //     total: 159.98,
  //     clientName: 'Camille Roux',
  //     saleDate: DateTime(2024, 6, 8),
  //     saleNumber: 'VTE-2024-008',
  //     categoryIcon: Icons.watch,
  //   ),
  // ];

  @override
  void initState() {
    super.initState();
    _loadVentes();
  }

  Future _loadVentes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ventesData = await ApiService.getVentes();

      setState(() {
        _listeVentes = (ventesData['liste_ventes'] as List<dynamic>? ?? [])
            .map(
              (json) =>
                  Vente.fromJson(json as Map<String, dynamic>, Icons.watch),
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

  List<Vente> get _filteredVentes {
    if (_searchController.text.isEmpty) {
      return _listeVentes;
    }
    final query = _searchController.text.toLowerCase();
    return _listeVentes.where((vente) {
      return vente.productName.toLowerCase().contains(query) ||
          vente.clientName.toLowerCase().contains(query) ||
          vente.saleNumber.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ventes',
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
                hintText: 'Rechercher une vente...',
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredVentes.length,
              itemBuilder: (context, index) {
                final vente = _filteredVentes[index];
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
                        vente.categoryIcon,
                        color: Colors.blue[900],
                        size: 28,
                      ),
                    ),
                    title: Text(
                      vente.productName,
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
                              Icons.person_outline,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                vente.clientName,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Qté: ${vente.quantity}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
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
                              'Vendu le: ${_formatDate(vente.saleDate)}',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.tag_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              vente.saleNumber,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${vente.total.toStringAsFixed(2)} ${vente.deviseSymbole}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                            Text(
                              '${vente.price.toStringAsFixed(2)} ${vente.deviseSymbole}/unité',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Action pour ajouter une nouvelle vente
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: const Text('Nouvelle vente'),
      //           content: const Text(
      //             'Formulaire d\'ajout de vente à implémenter',
      //           ),
      //           actions: [
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               },
      //               child: const Text('Fermer'),
      //             ),
      //           ],
      //         );
      //       },
      //     );
      //   },
      //   backgroundColor: Colors.blue[900],
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
