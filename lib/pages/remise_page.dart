import 'package:flutter/material.dart';
import 'package:rols/services/api_service.dart';

class Remise {
  final int id;
  final String nomRemise;
  final String telephoneRemise;
  final int quantite;
  final String nomProduit;
  final String prixVente;
  final int deviseId;
  final DateTime createdAt;
  final IconData categoryIcon;

  Remise({
    required this.id,
    required this.nomRemise,
    required this.telephoneRemise,
    required this.quantite,
    required this.nomProduit,
    required this.prixVente,
    required this.deviseId,
    required this.createdAt,
    required this.categoryIcon,
  });

  factory Remise.fromJson(Map<String, dynamic> json, IconData icon) {
    // Produit remise
    var produitRemise = json['produit_remise'];
    String nomProduit = 'Produit inconnu';
    String prixVente = '0';
    int deviseId = 1;

    if (produitRemise != null) {
      nomProduit = produitRemise['nom'] ?? 'Produit inconnu';
      prixVente = produitRemise['prix_vente']?.toString() ?? '0';
      deviseId = produitRemise['devise_id'] ?? 1;
    }

    // Date de création
    DateTime createdAt = DateTime.now();
    String createdAtStr = json['created_at'] ?? '';
    if (createdAtStr.isNotEmpty) {
      try {
        createdAt = DateTime.parse(createdAtStr);
      } catch (e) {
        createdAt = DateTime.now();
      }
    }

    return Remise(
      id: json['id'],
      nomRemise: json['nom_remise'] ?? 'Remise inconnue',
      telephoneRemise: json['telephone_remise'] ?? '',
      quantite: json['quantite'] ?? 0,
      nomProduit: nomProduit,
      prixVente: prixVente,
      deviseId: deviseId,
      createdAt: createdAt,
      categoryIcon: icon,
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

class RemisePage extends StatefulWidget {
  const RemisePage({super.key});

  @override
  State<RemisePage> createState() => _RemisePageState();
}

class _RemisePageState extends State<RemisePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  List<Remise> _listeRemises = [];

  @override
  void initState() {
    super.initState();
    _loadRemises();
  }

  Future _loadRemises() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final remisesData = await ApiService.getRemises();

      setState(() {
        _listeRemises = (remisesData['liste_remises'] as List<dynamic>? ?? [])
            .map(
              (json) => Remise.fromJson(
                json as Map<String, dynamic>,
                Icons.local_offer,
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

  List<Remise> get _filteredRemises {
    if (_searchController.text.isEmpty) {
      return _listeRemises;
    }
    final query = _searchController.text.toLowerCase();
    return _listeRemises.where((remise) {
      return remise.nomRemise.toLowerCase().contains(query) ||
          remise.nomProduit.toLowerCase().contains(query) ||
          remise.telephoneRemise.toLowerCase().contains(query);
    }).toList();
  }

  Future _retournerRemise(int remiseId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.retourRemiseProduit(
        produitIdRetour: remiseId.toString(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message'] ?? 'Produit retourné avec succès',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Recharger la liste des remises
        _loadRemises();
      }
    } catch (e) {
      print('Erreur retour remise: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du retour: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleMenuChoice(String choice, Remise remise) {
    switch (choice) {
      case 'Retour vente':
        _retournerRemise(remise.id);
        break;
    }
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
          'Remises',
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
                hintText: 'Rechercher une remise...',
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
              itemCount: _filteredRemises.length,
              itemBuilder: (context, index) {
                final remise = _filteredRemises[index];
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
                        remise.categoryIcon,
                        color: Colors.blue[900],
                        size: 28,
                      ),
                    ),
                    title: Text(
                      remise.nomRemise,
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
                                remise.telephoneRemise.isNotEmpty
                                    ? remise.telephoneRemise
                                    : 'Pas de téléphone',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
                              'Qté: ${remise.quantite}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(remise.createdAt),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                remise.nomProduit,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
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
                              '${remise.prixVente} ${remise.deviseSymbole}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                          color: Colors.white,
                          onSelected: (String choice) {
                            _handleMenuChoice(choice, remise);
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem<String>(
                                value: 'Retour vente',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.compare_arrows,
                                      color: Colors.blue[900],
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Text('Retour vente'),
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
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
