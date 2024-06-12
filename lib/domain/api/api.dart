import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/contollers/app_controllers.dart';
import 'package:flutter_application_1/domain/model/users.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static List<Users> users = [];

  static Future<List<Users>> fetchUsers() async {
    final response = await http.get(Uri.parse('http://localhost:3000/users'));

    final json = jsonDecode(response.body) as List<dynamic>;

    final userData = json.map<Users>((e) {
      return Users.fromJson(e as Map<String, dynamic>);
    }).toList();

    users = userData;

    return users;
  }

  static Future<void> addUser(Users user) async {
    // final updatedUser = user.copyWith(createdBy: createdBy);
    final jsonData = jsonEncode(user.toJson());

    final response = await http.post(
      Uri.parse('http://localhost:3000/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    if (response.statusCode == 201) {
      users.add(user);
    } else {
      throw Exception('Failed to add user');
    }
  }

  //регистрация

  static Future<bool> register(BuildContext context) async {
    final token = await getTokenFromLocalStorage();
    final response = await http.post(
      Uri.parse('http://localhost:3000/register'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'username': AppControllers.nameController.text,
        'userLastName': AppControllers.lastNameController.text,
        'userEmail': AppControllers.emailController.text,
        'password': AppControllers.passwordController.text,
      }),
    );
    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final token = body['token'];
      // final username = body['username'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString(
          'username',
          AppControllers.nameController
              .text); // Сохраняем имя пользователя в SharedPreferences
      print('User registered successfully');
      return true;
    } else {
      print('Failed to register user');
      return false;
    }
  }

//авторизация
  static Future<bool> login(BuildContext context) async {
    final token = await getTokenFromLocalStorage();
    final response = await http.post(
      Uri.parse('http://localhost:3000/login'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userEmail': AppControllers.emailController.text,
        'password': AppControllers.passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'];
      final username = body['username'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('username', username); // Сохраняем имя пользователя
      print('User logged in successfully');
      return true;
    } else {
      print('Failed to login user');
      return false;
    }
  }

  static Future<String?> getTokenFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

//обновление данных
  static Future<void> updateUser(
      int? userId, Users userToUpdate, String createdBy) async {
    final updatedUser = userToUpdate.copyWith(createdBy: createdBy);
    final url = Uri.parse('http://localhost:3000/users/$userId');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedUser.toJson()),
      );

      if (response.statusCode == 200) {
        print('User data updated successfully');
        await fetchUsers();
      } else {
        print('Failed to update user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  //удаление данных
  static Future<void> deleteUser(int? userId) async {
    final url = Uri.parse('http://localhost:3000/users/$userId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        users.removeWhere((user) => user.id == userId);
        print('User data deleted successfully');
      } else {
        print('Failed to delete user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
