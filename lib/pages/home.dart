import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mc/pages/auth/login.dart';
import 'package:mc/pages/news/news_page.dart';
import 'package:mc/pages/weather/weather_home.dart';

class Home extends StatelessWidget {
  const Home({Key? key});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void _navigateToNews(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const NewsPage(),
    ));
  }

  void _navigateToWeather(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const WeatherHome(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    String? email = FirebaseAuth.instance.currentUser?.email;
    String username = email != null ? email.split('@')[0] : 'User';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Welcome, $username',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/kk.png',
              width: 350,
              height: 350,
            ),
            const SizedBox(height: 20),
            _buildImageButton(
              context: context,
              color: Colors.deepPurple,
              onPressed: () => _navigateToNews(context),
              imagePath: 'assets/news_icon.png',
            ),
            const SizedBox(height: 20),
            _buildImageButton(
              context: context,
              color: Colors.deepOrange,
              onPressed: () => _navigateToWeather(context),
              imagePath: 'assets/weather_icon.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton({
    required BuildContext context,
    required Color color,
    required VoidCallback onPressed,
    required String imagePath,
  }) {
    return Container(
      width: 150,
      height: 150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return color.withOpacity(0.5);
            } else {
              return Colors.white;
            }
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white;
            } else {
              return color;
            }
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: color, width: 2),
            ),
          ),
          padding:
              MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(20)),
          elevation: MaterialStateProperty.all<double>(5),
          shadowColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        child: Ink.image(
          image: AssetImage(imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
