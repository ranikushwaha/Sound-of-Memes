// api_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sound_of_meme/MVVM/constants/strings.dart';
import 'package:sound_of_meme/Views/Auth/auth_service.dart';

class ApiService {
  final AuthService _authService = AuthService();

  Future<String?> signup(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['access_token'];
        print('Signup successful! Token: $token');
        await _authService.saveToken(token);
        return token;
      } else {
        print('Failed to sign up: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String?> login(
      {required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['access_token'];
        print('Login successful! Token: $token');
        await _authService.saveToken(token); // Use the instance method
        return token;
      } else {
        print('Failed to log in: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<dynamic>?> fetchAllSongs({required int page}) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/allsongs?page=$page'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['songs']; // Adjust according to the actual JSON structure
      } else {
        print('Failed to fetch songs: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createSong({
    required String songDetails,
  }) async {
    final token = await _authService.getToken();
    if (token == null) {
      print('No token available');
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'song': songDetails}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to create song: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createCustomSong({
    required String title,
    required String lyrics,
    required String genre,
  }) async {
    final token = await _authService.getToken();
    if (token == null) {
      print('No token available');
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/createcustom'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'title': title,
          'lyric': lyrics,
          'genere': genre,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to create custom song: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> cloneSong({
    required String filePath,
    required String prompt,
    required String lyrics,
  }) async {
    final token = await _authService.getToken();
    if (token == null) {
      print('No token available');
      return null;
    }

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.baseUrl}/clonesong'),
      )
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['prompt'] = prompt
        ..fields['lyrics'] = lyrics
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        print('Failed to clone song: $responseBody');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserDetails() async {
    final token = await _authService.getToken();
    if (token == null) {
      print('No token available');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to fetch user details: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
