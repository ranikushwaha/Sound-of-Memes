import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sound_of_meme/Views/detailedViews/song_details.dart';

import '../../MVVM/Service/api_service.dart';

class CreateSongScreen extends StatefulWidget {
  const CreateSongScreen({super.key});

  @override
  State<CreateSongScreen> createState() => _CreateSongScreenState();
}

class _CreateSongScreenState extends State<CreateSongScreen> {
  final GlobalKey<FormState> _createFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _customFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _cloneFormKey = GlobalKey<FormState>();

  String _title = '';
  String _style = '';
  String _lyrics = '';
  bool _isLoading = false;
  int _currentStep = 0;

  final List<String> _steps = [
    'Reading your input',
    'Preparing your masterpiece for the world',
    'Crafting the perfect rhythm',
    'Tuning the melody with magic',
    'Harmony in progress',
    'Adding a sprinkle of sparkle',
    'Adjusting the beat to perfection',
    'On the lookout for the ideal voice',
    'Capturing vocals with passion',
    'Blending sounds for harmony',
    'Polishing the final mix',
    'Applying the finishing touches',
    'Setting the stage for release',
    'Ready to dazzle the world',
    'A standing ovation for a job well done!',
    'From your imagination to reality',
    'Harmonizing every note to perfection',
    'A touch of magic in every beat',
    'Your song is about to shine',
    'Perfecting every detail with love',
  ];

  int songId = 0;
  String userId = '';
  String songName = '';
  String songUrl = '';
  int likes = 0;
  int views = 0;
  String imageUrl = '';
  String lyrics = '';
  List<String> tags = [];
  DateTime dateTime = DateTime.now();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final ApiService _apiService = ApiService();

  Future<void> _submitForm(String option) async {
    GlobalKey<FormState> currentFormKey;

    if (option == 'create') {
      currentFormKey = _createFormKey;
    } else if (option == 'custom') {
      currentFormKey = _customFormKey;
    } else if (option == 'clone') {
      currentFormKey = _cloneFormKey;
    } else {
      return;
    }

    if (currentFormKey.currentState!.validate()) {
      currentFormKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _currentStep = 0;
      });

      try {
        for (int i = 0; i < _steps.length; i++) {
          await Future.delayed(const Duration(seconds: 10));
          setState(() {
            _currentStep = i;
          });
        }

        Map<String, dynamic>? response;

        if (option == 'create') {
          response = await _apiService.createSong(songDetails: _lyrics);
        } else if (option == 'custom') {
          response = await _apiService.createCustomSong(
            title: _title,
            lyrics: _lyrics,
            genre: _style,
          );
        } else if (option == 'clone') {
          response = await _apiService.cloneSong(
            filePath: 'path/to/file.mp3',
            prompt: _title,
            lyrics: _lyrics,
          );
        }

        if (response != null) {
          songId = response['song_id'] ?? 0;
          userId = response['user_id'] ?? '';
          songName = response['song_name'] ?? '';
          songUrl = response['song_url'] ?? '';
          likes = response['likes'] ?? 0;
          views = response['views'] ?? 0;
          imageUrl = response['image_url'] ?? '';
          lyrics = response['lyrics'] ?? '';
          tags = List<String>.from(response['tags'] ?? []);
          dateTime = DateTime.parse(
              response['date_time'] ?? DateTime.now().toIso8601String());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongDetailsScreen(
                songId: songId,
                userId: userId,
                songName: songName,
                songUrl: songUrl,
                likes: likes,
                views: views,
                imageUrl: imageUrl,
                lyrics: lyrics,
                tags: tags,
                dateTime: dateTime,
              ),
            ),
          );
        }
      } catch (e) {
        print('Failed to process song: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Song'),
          backgroundColor: Colors.pink.shade100,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Create Song'),
              Tab(text: 'Create Custom Song'),
              Tab(text: 'Clone Song'),
            ],
          ),
        ),
        body: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: TabBarView(
            children: [
              _buildForm('create'),
              _buildCustomForm(),
              _buildCloneForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(String option) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _isLoading
            ? _buildCustomProgressBar()
            : Form(
                key: _createFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildTextField('Song Title', (value) => _title = value!),
                    _buildTextField('Song Style', (value) => _style = value!),
                    _buildTextField('Lyrics', (value) => _lyrics = value!,
                        maxLines: 5),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _submitForm(option),
                      icon: const Icon(Icons.music_note),
                      label: const Text('Generate Song'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCustomForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _isLoading
            ? _buildCustomProgressBar()
            : Form(
                key: _customFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildTextField('Song Title', (value) => _title = value!),
                    _buildTextField('Lyrics', (value) => _lyrics = value!,
                        maxLines: 5),
                    _buildTextField('Genre', (value) => _style = value!),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _submitForm('custom'),
                      icon: const Icon(Icons.edit),
                      label: const Text('Create Custom Song'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCloneForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _isLoading
            ? _buildCustomProgressBar()
            : Form(
                key: _cloneFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildTextField('MP3 File Path',
                        (value) => _title = value!), // Use for file path
                    _buildTextField('Prompt', (value) => _style = value!),
                    _buildTextField('Lyrics', (value) => _lyrics = value!,
                        maxLines: 5),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _submitForm('clone'),
                      icon: const Icon(Icons.copy),
                      label: const Text('Clone Song'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(String label, FormFieldSetter<String> onSaved,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.deepPurple[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onSaved: onSaved,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCustomProgressBar() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200, // Set a fixed width for the image and progress bar
              child: Image.asset(
                'assets/images/sing_meme.png', // Replace with your image path
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200, // Set the same width for the progress bar
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
                backgroundColor: Colors.grey[200],
                color: Colors.deepPurpleAccent,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200, // Set the same width for the text
              child: Text(
                _steps[_currentStep],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
