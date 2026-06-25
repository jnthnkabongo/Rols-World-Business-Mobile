import 'package:flutter/material.dart';

class Remise {
  final String name;
  final String description;
  final double percentage;
  final DateTime startDate;
  final DateTime endDate;
  final String code;
  final bool isActive;
  final IconData categoryIcon;

  Remise({
    required this.name,
    required this.description,
    required this.percentage,
    required this.startDate,
    required this.endDate,
    required this.code,
    required this.isActive,
    required this.categoryIcon,
  });
}

class RemisePage extends StatefulWidget {
  const RemisePage({super.key});

  @override
  State<RemisePage> createState() => _RemisePageState();
}

class _RemisePageState extends State<RemisePage> {
  final List<Remise> _remises = [
    Remise(
      name: 'Soldes d\'été',
      description: 'Réduction sur tous les produits électroniques',
      percentage: 20.0,
      startDate: DateTime(2024, 6, 1),
      endDate: DateTime(2024, 8, 31),
      code: 'SOLTE2024',
      isActive: true,
      categoryIcon: Icons.computer,
    ),
    Remise(
      name: 'Promo Chaussures',
      description: 'Remise sur la collection Nike',
      percentage: 15.0,
      startDate: DateTime(2024, 6, 15),
      endDate: DateTime(2024, 7, 15),
      code: 'NIKE15',
      isActive: true,
      categoryIcon: Icons.sports_basketball,
    ),
    Remise(
      name: 'VIP Client',
      description: 'Réduction exclusive pour clients fidèles',
      percentage: 10.0,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 12, 31),
      code: 'VIP2024',
      isActive: true,
      categoryIcon: Icons.card_giftcard,
    ),
    Remise(
      name: 'Flash Sale',
      description: 'Offre limitée sur les accessoires',
      percentage: 25.0,
      startDate: DateTime(2024, 5, 20),
      endDate: DateTime(2024, 5, 25),
      code: 'FLASH25',
      isActive: false,
      categoryIcon: Icons.watch,
    ),
    Remise(
      name: 'Back to School',
      description: 'Préparation rentrée scolaire',
      percentage: 12.0,
      startDate: DateTime(2024, 8, 15),
      endDate: DateTime(2024, 9, 15),
      code: 'SCHOOL24',
      isActive: false,
      categoryIcon: Icons.school,
    ),
    Remise(
      name: 'Black Friday',
      description: 'Meilleures offres de l\'année',
      percentage: 30.0,
      startDate: DateTime(2024, 11, 29),
      endDate: DateTime(2024, 12, 2),
      code: 'BLACK30',
      isActive: false,
      categoryIcon: Icons.local_offer,
    ),
    Remise(
      name: 'Nouveau Client',
      description: 'Bienvenue avec -10% sur première commande',
      percentage: 10.0,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 12, 31),
      code: 'WELCOME10',
      isActive: true,
      categoryIcon: Icons.person_add,
    ),
    Remise(
      name: 'Pâques 2024',
      description: 'Offre saisonnière de printemps',
      percentage: 18.0,
      startDate: DateTime(2024, 3, 25),
      endDate: DateTime(2024, 4, 10),
      code: 'PAQUES18',
      isActive: false,
      categoryIcon: Icons.celebration,
    ),
  ];

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _remises.length,
        itemBuilder: (context, index) {
          final remise = _remises[index];
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
                  color: remise.isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  remise.categoryIcon,
                  color: remise.isActive ? Colors.green : Colors.grey,
                  size: 28,
                ),
              ),
              title: Text(
                remise.name,
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
                        Icons.description_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          remise.description,
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
                      Icon(Icons.code, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        remise.code,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_formatDate(remise.startDate)} - ${_formatDate(remise.endDate)}',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '-${remise.percentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: remise.isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: remise.isActive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      remise.isActive ? 'Active' : 'Expirée',
                      style: TextStyle(
                        fontSize: 10,
                        color: remise.isActive ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
