import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SongDetailsScreen extends StatefulWidget {
  final int songId;
  final String userId;
  final String songName;
  final String songUrl;
  final int likes;
  final int views;
  final String imageUrl;
  final String lyrics;
  final List<String> tags;
  final DateTime dateTime;

  const SongDetailsScreen({
    required this.songId,
    required this.userId,
    required this.songName,
    required this.songUrl,
    required this.likes,
    required this.views,
    required this.imageUrl,
    required this.lyrics,
    required this.tags,
    required this.dateTime,
    super.key,
  });

  @override
  _SongDetailsScreenState createState() => _SongDetailsScreenState();
}

class _SongDetailsScreenState extends State<SongDetailsScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _razorpay.clear(); // Clear Razorpay instance
    super.dispose();
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(widget.songUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _startPayment() {
    var options = {
      'key': 'YOUR_TEST_KEY', // Replace with your Razorpay test key
      'amount': 10000, // Amount in paise (e.g., 10000 paise = 100 INR)
      'name': 'Purchase Song',
      'description': 'Payment for the song ${widget.songName}',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Payment Successful! Payment ID: ${response.paymentId}')),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed! Error: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payment here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.songName),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Song Image with Play/Pause Button and Vibe Effect
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), // Circle
                      border: Border.all(
                        color: isPlaying
                            ? Colors.pinkAccent
                            : Colors.pink.shade100,
                        width: isPlaying ? 5 : 2,
                      ),
                      boxShadow: isPlaying
                          ? [
                              BoxShadow(
                                color: Colors.pinkAccent.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 15,
                              ),
                            ]
                          : [],
                    ),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(widget.imageUrl),
                    ),
                  ),
                  IconButton(
                    iconSize: 64.0,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.white,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Song Title
            Text(
              widget.songName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),

            // Buy Button and Song Info with Like and View Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _startPayment,
                  child: const Text('Buy Song'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 12),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    const SizedBox(width: 4.0),
                    Text(widget.likes.toString()),
                    const SizedBox(width: 16.0),
                    Icon(Icons.visibility, color: Colors.green),
                    const SizedBox(width: 4.0),
                    Text(widget.views.toString()),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Song Lyrics
            Text(
              'Lyrics:',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.deepPurple,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.lyrics,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),

            // Song Tags
            Wrap(
              spacing: 8.0,
              children: widget.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.deepPurple.shade100,
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),

            // Date
            Text(
              'Date: ${widget.dateTime}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
