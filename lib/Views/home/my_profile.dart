import 'package:flutter/material.dart';

import '../../MVVM/Service/api_service.dart';
import '../Auth/SignupScreen.dart';
import '../Auth/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? userDetails;
  bool isLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final details = await _apiService.fetchUserDetails();
    setState(() {
      userDetails = details;
      isLoading = false;
    });
  }

  Future<void> _handleLogout() async {
    await _authService.clearToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userDetails == null
              ? Center(child: Text('Error loading user details'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundImage: AssetImage(
                                  'assets/images/profile_meme_placeholder.png'), // Placeholder image
                              backgroundColor: Colors.grey.shade200,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        userDetails!['name'] ?? 'User Name',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        userDetails!['email'] ?? 'user@example.com',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      GestureDetector(
                        child: Text(
                          'Your Songs',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.deepPurple,
                                fontSize: 16, // Adjust the size here
                              ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      GestureDetector(
                        child: Text(
                          'Purchased Songs',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.deepPurple,
                                fontSize: 16, // Adjust the size here
                              ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // Placeholder for purchased songs
                      Expanded(
                        child: ListView.builder(
                          itemCount: 5, // Replace with actual count
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                child: Icon(Icons.music_note,
                                    color: Colors.deepPurple),
                              ),
                              title: Text('Song Name $index'),
                              subtitle: Text('Artist Name'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Handle song removal
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: _handleLogout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.logout, color: Colors.white),
                              SizedBox(width: 8.0),
                              Text(
                                'Logout',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
