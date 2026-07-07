import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String get baseUrl {
    return 'https://rolsworldbusiness.alwaysdata.net/api';
  }
  // static const String baseUrl = 'https://rolsworldbusiness.alwaysdata.net/api';

  // static String get baseUrl {
  //   if (kIsWeb) {
  //     return 'http://localhost:8000/api';
  //   } else if (Platform.isAndroid) {
  //     return 'http://10.0.2.2:https://rolsworldbusiness.alwaysdata.net/api';
  //   } else if (Platform.isIOS) {
  //     return 'http://localhost:8000/api';
  //   }
  //   return 'http://localhost:8000/api';
  // }

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user';

  //Soumission de la logique de connexion
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message =
            data['message'] ?? 'Erreur de connexion lors de la connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //Sauvegarde des donnees de l'utilisateur connecter
  static Future<void> sauvegardeDonneesUser(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else {
      await prefs.setString(key, jsonEncode(value));
    }
  }

  //Recuperation des donnees de l'utilisateur connecter
  static Future<dynamic> recupererDonneesUser(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data != null) {
      try {
        return jsonDecode(data);
      } catch (e) {
        // Si ce n'est pas du JSON, retourner la chaîne brute
        return data;
      }
    }
    return null;
  }

  //Recuperation des donnes du Dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final token = await recupererDonneesUser(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouver');
      }

      // Extraire la partie token du format Laravel Sanctum (id|token)
      String tokenValue = token;
      if (token is String && token.contains('|')) {
        tokenValue = token.split('|')[1];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: {
          'Content-type': 'Application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Erreur de connexion';
        throw Exception(message);
      }
    } catch (e) {
      print('Exception catchée: $e');
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //Recuperation des donnees des produits
  static Future<Map<String, dynamic>> getProduits() async {
    try {
      final token = await recupererDonneesUser(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouver');
      }
      // Extraire la partie token du format Laravel Sanctum (id|token)
      String tokenValue = token;
      if (token is String && token.contains('|')) {
        tokenValue = token.split('|')[1];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/liste-produits'),
        headers: {
          'Content-type': 'Application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Erreur de connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //Recuperation des donnees des ventes
  static Future<Map<String, dynamic>> getVentes() async {
    try {
      final token = await recupererDonneesUser(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouver');
      }
      // Extraire la partie token du format Laravel Sanctum (id|token)
      String tokenValue = token;
      if (token is String && token.contains('|')) {
        tokenValue = token.split('|')[1];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/liste-ventes'),
        headers: {
          'Content-type': 'Application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Erreur de connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //Soumission d'une vente
  static Future<Map<String, dynamic>> postVente({
    required String produitId,
    required String nomClient,
    required String telephone,
    required String email,
    required String adresse,
    required String quantite,
  }) async {
    try {
      final token = await recupererDonneesUser(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouver');
      }
      // Extraire la partie token du format Laravel Sanctum (id|token)
      String tokenValue = token;
      if (token is String && token.contains('|')) {
        tokenValue = token.split('|')[1];
      }

      final body = {
        'nom_client': nomClient,
        'telephone': telephone,
        'email': email,
        'adresse': adresse,
        'quantite': quantite,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/ajout-vente/$produitId'),
        headers: {
          'Content-type': 'Application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Erreur de connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //Recuperation des donnees de remises
  static Future<Map<String, dynamic>> getRemises() async {
    try {
      final token = await recupererDonneesUser(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouver');
      }
      // Extraire la partie token du format Laravel Sanctum (id|token)
      String tokenValue = token;
      if (token is String && token.contains('|')) {
        tokenValue = token.split('|')[1];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/liste-remises'),
        headers: {
          'Content-type': 'Application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Erreur de connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> postRemise({
    required String produitIdRemise,
    required String nomRemise,
    required String telephoneRemise,
    required String quantiteRemise,
  }) async {
    try {
      final token = await recupererDonneesUser(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouver');
      }
      // Extraire la partie token du format Laravel Sanctum (id|token)
      String tokenValue = token;
      if (token is String && token.contains('|')) {
        tokenValue = token.split('|')[1];
      }

      final body = {
        'nom_remise': nomRemise,
        'telephone_remise': telephoneRemise,
        'quantite': quantiteRemise,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/ajout-remise/$produitIdRemise'),
        headers: {
          'Content-type': 'Application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Erreur de connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //Retourner le produit qui n'a pas ete vendu avec l'option remise
  static Future<Map<String, dynamic>> getRetourRemise() async {
    try {
      final token = await recupererDonneesUser(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouver');
      }
      // Extraire la partie token du format Laravel Sanctum (id|token)
      String tokenValue = token;
      if (token is String && token.contains('|')) {
        tokenValue = token.split('|')[1];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/retour/liste-remises'),
        headers: {
          'Content-type': 'Application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Erreur de connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> retourRemiseProduit({
    required String produitIdRetour,
  }) async {
    try {
      final token = await recupererDonneesUser(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouver');
      }
      // Extraire la partie token du format Laravel Sanctum (id|token)
      String tokenValue = token;
      if (token is String && token.contains('|')) {
        tokenValue = token.split('|')[1];
      }

      final response = await http.post(
        Uri.parse('$baseUrl/retourner-remise/$produitIdRetour'),
        headers: {
          'Content-type': 'Application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Erreur de connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }

  //Logout de l'utilisateur
  static Future<Map<String, dynamic>> getLogout() async {
    try {
      final token = await recupererDonneesUser(_tokenKey);
      if (token == null) {
        throw Exception('Token non trouver');
      }
      // Extraire la partie token du format Laravel Sanctum (id|token)
      String tokenValue = token;
      if (token is String && token.contains('|')) {
        tokenValue = token.split('|')[1];
      }

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-type': 'Application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Erreur de connexion';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Erreur de réseau : ${e.toString()}');
    }
  }
}
