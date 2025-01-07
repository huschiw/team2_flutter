import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signInPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = ""; // ตัวแปรสำหรับเก็บชื่อผู้ใช้
  String userImage = ""; // ตัวแปรสำหรับเก็บ URL ของรูปโปรไฟล์ผู้ใช้

  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); // ตัวแปรสำหรับ Google Sign-In

  @override
  void initState() {
    super.initState();
    _getUserInfo(); // เรียกฟังก์ชันเพื่อดึงข้อมูลผู้ใช้จาก Google
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้จาก Google
  Future<void> _getUserInfo() async {
    try {
      GoogleSignInAccount? account = _googleSignIn.currentUser;
      account ??= await _googleSignIn
            .signIn();
      if (account != null) {
        setState(() {
          userName = account?.displayName ?? "User"; // กำหนดชื่อผู้ใช้
          userImage = account?.photoUrl ?? ""; // กำหนดรูปโปรไฟล์
        });
      }
    } catch (error) {
      print("Error getting user info: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  userImage.isNotEmpty
                      ? userImage
                      : 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fth.wikipedia.org%2Fwiki%2F%25E0%25B9%2582%25E0%25B8%2597%25E0%25B8%25A3%25E0%25B8%25A5%25E0%25B8%25A5%25E0%25B9%258C%25E0%25B9%2580%25E0%25B8%259F%25E0%25B8%258B&psig=AOvVaw2IEQ1a-stn-7_TLjt1BrO0&ust=1736263237246000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCPjEzd2y4YoDFQAAAAAdAAAAABAE',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userName.isNotEmpty ? userName : 'User',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // ล็อกเอาท์จาก Google Sign-In
                  await _googleSignIn.signOut();
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
