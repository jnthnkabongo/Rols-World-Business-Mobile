import 'dart:core';
import 'package:flutter/material.dart';

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
}
