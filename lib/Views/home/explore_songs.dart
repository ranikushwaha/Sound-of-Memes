import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../MVVM/Service/api_service.dart';
import '../detailedViews/song_details.dart';

class ExploreSongsScreen extends StatefulWidget {
  const ExploreSongsScreen({super.key});

  @override
  _ExploreSongsScreenState createState() => _ExploreSongsScreenState();
}

class _ExploreSongsScreenState extends State<ExploreSongsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _songs = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int? _currentPlayingSongId;
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMoreSongs = true;
  int _totalPages = 1; // Track the total number of pages

  @override
  void initState() {
    super.initState();
    _fetchSongs(page: _currentPage);
  }

  Future<void> _fetchSongs({required int page}) async {
    if (page <= 0 || page > _totalPages) return; // Validate page number

    setState(() {
      _isLoading = true;
    });

    final songs = await _apiService.fetchAllSongs(page: page);
    if (songs != null && songs.isNotEmpty) {
      setState(() {
        _songs = songs;
        _currentPage = page;
        _hasMoreSongs = songs.length == 10; // Assuming 10 is the page size
        _totalPages = (songs.length ~/ 20) + 1; // Update total pages
        _isLoading = false;
      });
    } else {
      setState(() {
        _hasMoreSongs = false;
        _isLoading = false;
      });
    }
  }

  void _playSong(String url, int songId) async {
    setState(() {
      _isLoading = true;
    });

    // Stop playing the current song if it's the same song
    if (_currentPlayingSongId == songId && _isPlaying) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
        _currentPlayingSongId = null;
        _isLoading = false;
      });
    } else {
      // Stop the current song if a different song is playing
      if (_isPlaying) {
        await _audioPlayer.stop();
      }

      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _isPlaying = true;
        _currentPlayingSongId = songId;
        _isLoading = false;
      });
    }
  }

  void _navigateToSongDetails(dynamic song) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongDetailsScreen(
          songId: song['song_id'],
          userId: song['user_id'],
          songName: song['song_name'],
          songUrl: song['song_url'],
          likes: song['likes'],
          views: song['views'],
          imageUrl: song['image_url'],
          lyrics: song['lyrics'],
          tags: List<String>.from(song['tags']),
          dateTime: DateTime.parse(song['date_time']),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Songs"),
        backgroundColor: Colors.pink.shade100,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _songs.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          padding: EdgeInsets.all(10.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _songs.length,
                          itemBuilder: (context, index) {
                            final song = _songs[index];
                            final isCurrentSongPlaying =
                                _currentPlayingSongId == song['song_id'] &&
                                    _isPlaying;
                            final isLoading =
                                _currentPlayingSongId == song['song_id'] &&
                                    _isLoading;

                            return GestureDetector(
                              onTap: () =>
                                  _playSong(song['song_url'], song['song_id']),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: isCurrentSongPlaying
                                      ? Border.all(
                                          color: Colors.pinkAccent, width: 5)
                                      : Border.all(
                                          color: Colors.pink.shade100,
                                          width: 2),
                                  boxShadow: [
                                    if (isCurrentSongPlaying)
                                      BoxShadow(
                                        color:
                                            Colors.pinkAccent.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 15,
                                      ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            song['image_url'],
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        if (isLoading)
                                          CircularProgressIndicator(),
                                        if (!isLoading)
                                          IconButton(
                                            icon: Icon(
                                              isCurrentSongPlaying
                                                  ? Icons.pause_outlined
                                                  : Icons.play_arrow,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            onPressed: () => _playSong(
                                                song['song_url'],
                                                song['song_id']),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      song['song_name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.favorite,
                                            color: Colors.red, size: 16),
                                        SizedBox(width: 5),
                                        Text(
                                          "${song['likes']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(Icons.remove_red_eye,
                                            color: Colors.grey, size: 16),
                                        SizedBox(width: 5),
                                        Text(
                                          "${song['views']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () => _navigateToSongDetails(song),
                                      child: const Text(
                                        "Song Details",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          shrinkWrap: true,
                          physics:
                              NeverScrollableScrollPhysics(), // Disable scrolling
                        )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _isLoading && !_hasMoreSongs
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: Text("No more songs to load")),
                    )
                  : !_isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_totalPages, (index) {
                              final pageNumber = index + 1;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (pageNumber != _currentPage) {
                                      _fetchSongs(page: pageNumber);
                                    }
                                  },
                                  child: Text(pageNumber.toString()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: pageNumber == _currentPage
                                        ? Colors.pinkAccent
                                        : Colors.pink.shade100,
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
