import 'package:flutter/material.dart';
import 'package:rols/pages/navigation_page.dart';
import 'package:rols/services/api_service.dart';

class Produit {
  final int id;
  final String nom;
  final String? description;
  final String prixVente;
  final String deviseId;
  final String? modele;
  final String? statut;
  final String? taille;
  final String? numeroSerie;
  final int? quantiteProduit;
  final DateTime createdAt;
  final IconData categoryIcon;

  Produit({
    required this.id,
    required this.nom,
    this.description,
    required this.prixVente,
    required this.deviseId,
    this.modele,
    this.statut,
    this.taille,
    this.numeroSerie,
    this.quantiteProduit,
    required this.createdAt,
    required this.categoryIcon,
  });

  factory Produit.fromJson(Map<String, dynamic> json, IconData icon) {
    // Essayer de récupérer le numéro de série depuis différents emplacements possibles
    String? numeroSerie;

    // Directement dans l'objet produit
    if (json['numero_serie'] != null) {
      numeroSerie = json['numero_serie']?.toString();
    }
    // Dans produit_unite (si imbriqué)
    else if (json['produit_unite'] != null &&
        json['produit_unite']['numero_serie'] != null) {
      numeroSerie = json['produit_unite']['numero_serie']?.toString();
    }
    // Dans une liste de produit_unites
    else if (json['produit_unites'] != null &&
        json['produit_unites'] is List &&
        (json['produit_unites'] as List).isNotEmpty) {
      var firstUnite = (json['produit_unites'] as List)[0];
      if (firstUnite['numero_serie'] != null) {
        numeroSerie = firstUnite['numero_serie']?.toString();
      }
    }

    // Essayer de récupérer le statut depuis différents emplacements possibles
    String? statut;

    // Directement dans l'objet produit
    if (json['statut'] != null) {
      statut = json['statut']?.toString();
    }
    // Dans produit_unite (si imbriqué)
    else if (json['produit_unite'] != null &&
        json['produit_unite']['statut'] != null) {
      statut = json['produit_unite']['statut']?.toString();
    }
    // Dans une liste de produit_unites
    else if (json['produit_unites'] != null &&
        json['produit_unites'] is List &&
        (json['produit_unites'] as List).isNotEmpty) {
      var firstUnite = (json['produit_unites'] as List)[0];
      if (firstUnite['statut'] != null) {
        statut = firstUnite['statut']?.toString();
      }
    }

    // Essayer de récupérer la quantité produit depuis différents emplacements possibles
    int? quantiteProduit;

    // Directement dans l'objet produit
    if (json['quantite_produit'] != null) {
      quantiteProduit = json['quantite_produit'] as int?;
    }
    // Dans produit_unite (si imbriqué)
    else if (json['produit_unite'] != null &&
        json['produit_unite']['quantite_produit'] != null) {
      quantiteProduit = json['produit_unite']['quantite_produit'] as int?;
    }
    // Dans une liste de produit_unites
    else if (json['produit_unites'] != null &&
        json['produit_unites'] is List &&
        (json['produit_unites'] as List).isNotEmpty) {
      var firstUnite = (json['produit_unites'] as List)[0];
      if (firstUnite['quantite_produit'] != null) {
        quantiteProduit = firstUnite['quantite_produit'] as int?;
      }
    }

    return Produit(
      id: json['id'],
      nom: json['nom'] ?? '',
      description: json['description'],
      prixVente: json['prix_vente']?.toString() ?? '0',
      deviseId: json['devise_id']?.toString() ?? '0',
      modele: json['modele'],
      statut: statut,
      taille: json['taille'],
      numeroSerie: numeroSerie,
      quantiteProduit: quantiteProduit,
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

  final _produitController = TextEditingController();
  final _nomclientController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _adresseController = TextEditingController();
  final _quantiteController = TextEditingController();

  final _produitIdRemiseController = TextEditingController();
  final _nomRemiseRemiseController = TextEditingController();
  final _telephoneRemiseController = TextEditingController();
  final _quantiteRemiseController = TextEditingController();

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

  void _sauvegardeVente() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.postVente(
        produitId: _produitController.text,
        nomClient: _nomclientController.text,
        telephone: _telephoneController.text,
        email: _emailController.text,
        adresse: _adresseController.text,
        quantite: _quantiteController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeWithBottomNav()),
        );
      }
    } catch (e) {
      print(e);
      _showErrorSnackBar('Erreur de connexion: ${e.toString()}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion échouée'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sauvegarderRemise() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.postRemise(
        produitIdRemise: _produitIdRemiseController.text,
        nomRemise: _nomRemiseRemiseController.text,
        telephoneRemise: _telephoneRemiseController.text,
        quantiteRemise: _quantiteRemiseController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeWithBottomNav()),
        );
      }
    } catch (e) {
      print(e);
      _showErrorSnackBar('Erreur de connexion: ${e.toString()}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion échouée'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showDialogVente([Produit? produit]) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final TextEditingController produitController = TextEditingController(
      text: produit?.nom ?? '',
    );
    final TextEditingController produitIdController = TextEditingController(
      text: produit?.id.toString() ?? '',
    );
    final TextEditingController nomclientController = TextEditingController();
    final TextEditingController telephoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController adresseController = TextEditingController();
    final TextEditingController quantiteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.65,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Nouvelle vente",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: produitController,
                      decoration: const InputDecoration(
                        labelText: "Produit",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir le produit";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: nomclientController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Nom client",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir le nom du client";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: telephoneController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Téléphone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Veuillez saisir le numéro de téléphone";
                      //   }
                      //   return null;
                      // },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "E-mail",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Veuillez saisir l'e-mail du client";
                      //   }
                      //   return null;
                      // },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: adresseController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Adresse",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Veuillez saisir l'adresse";
                      //   }
                      //   return null;
                      // },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: quantiteController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Quantité",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir la quantité";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Copier les valeurs dans les contrôleurs de classe
                          _produitController.text = produitIdController.text;
                          _nomclientController.text = nomclientController.text;
                          _telephoneController.text = telephoneController.text;
                          _emailController.text = emailController.text;
                          _adresseController.text = adresseController.text;
                          _quantiteController.text = quantiteController.text;

                          Navigator.pop(context);
                          _sauvegardeVente();
                        }
                      },
                      child: const Text(
                        "Enregistrer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDialogRemise(Produit? produitRemise) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final TextEditingController produitRemiseController = TextEditingController(
      text: produitRemise?.nom ?? '',
    );
    final TextEditingController produitIdRemiseController =
        TextEditingController(text: produitRemise?.id.toString() ?? '');
    final TextEditingController nomclientRemiseController =
        TextEditingController();
    final TextEditingController telephoneRemiseController =
        TextEditingController();
    final TextEditingController quantiteRemiseController =
        TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.55,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Form(
                key: formKey,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Nouvelle remise",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: produitRemiseController,
                      decoration: const InputDecoration(
                        labelText: "Produit",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir le produit";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: nomclientRemiseController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Nom personne remise",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir le nom du client";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: telephoneRemiseController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Téléphone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez saisir le numéro de téléphone";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: quantiteRemiseController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Quantité",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Traitement des données
                          _produitIdRemiseController.text =
                              produitIdRemiseController.text;
                          _nomRemiseRemiseController.text =
                              nomclientRemiseController.text;
                          _telephoneRemiseController.text =
                              telephoneRemiseController.text;
                          _quantiteRemiseController.text =
                              quantiteRemiseController.text;
                          Navigator.pop(context);
                          _sauvegarderRemise();
                        }
                      },
                      child: const Text(
                        "Enregistrer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'N° Série: ${produit.numeroSerie ?? 'N/A'}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.inventory_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Quantité: ${produit.quantiteProduit ?? 0}',
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
                      'Enregistré le : ${_formatDate(produit.createdAt)}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(produit.statut),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Status: ${produit.statut ?? 'N/A'}',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
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

  Color _getStatusColor(String? statut) {
    if (statut == null) return Colors.grey;
    switch (statut.toLowerCase()) {
      case 'vendu':
        return Colors.red;
      case 'en_stock':
        return Colors.green;
      case 'remise':
        return const Color(0xFF0D47A1);
      default:
        return Colors.grey;
    }
  }

  void _handleMenuChoice(String choice, Produit produit) {
    switch (choice) {
      case 'remise':
        _showDialogRemise(produit);
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Remise: ${produit.nom}')));
        break;
      case 'vente':
        _showDialogVente(produit);
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Vente: ${produit.nom}')));
        break;
    }
  }
}
