import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:google_sign_in/google_sign_in.dart'; // นำเข้า Google Sign-In

class PageSystem extends StatefulWidget {
  const PageSystem({super.key});

  @override
  _PageSystemState createState() => _PageSystemState();
}

class _PageSystemState extends State<PageSystem> {
  String userName = ""; // ตัวแปรสำหรับเก็บชื่อผู้ใช้
  String userImage = ""; // ตัวแปรสำหรับเก็บ URL ของรูปโปรไฟล์ผู้ใช้
  String? selectedOption; // ตัวแปรสำหรับเก็บค่าของ radio ที่เลือก
  final FlutterTts flutterTts = FlutterTts(); // ตัวแปรสำหรับ Flutter TTS
  final TextEditingController textController = TextEditingController(); // คอนโทรลเลอร์สำหรับ TextField

  // รายชื่อสมมติที่ต้องการแสดง
  List<String> names = [
    "น้องแข้งโต", // Option 1
    "น้องล่ำบึก", // Option 2
    "น้องสปาย", // Option 3
    "น้องเจ๋ง" // Option 4
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(); // ตัวแปรสำหรับ Google Sign-In

  @override
  void initState() {
    super.initState();
    _getUserInfo(); // เรียกฟังก์ชันเพื่อดึงข้อมูลผู้ใช้จาก Google
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้จาก Google
  Future<void> _getUserInfo() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.currentUser;
      if (account == null) {
        account = await _googleSignIn.signIn(); // ให้ผู้ใช้ลงชื่อเข้าใช้หากยังไม่ได้ลงชื่อ
      }
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

  // ฟังก์ชันการตั้งค่าเสียงต่าง ๆ สำหรับแต่ละ Option
  void _setVoiceForOption(String option) async {
    switch (option) {
      case 'Option 1':
        await flutterTts.setLanguage("th-TH");
        await flutterTts.setPitch(1); // เสียงปกติ
        break;
      case 'Option 2':
        await flutterTts.setLanguage("th-TH");
        await flutterTts.setPitch(2); // เสียงสูงขึ้น
        break;
      case 'Option 3':
        await flutterTts.setLanguage("th-TH");
        await flutterTts.setPitch(0.2); // เสียงต่ำลง
        break;
      case 'Option 4':
        await flutterTts.setLanguage("th-TH");
        await flutterTts.setPitch(0.8); // เสียงต่ำลง
        break;
      default:
        await flutterTts.setLanguage("th-TH");
        await flutterTts.setPitch(1);
        break;
    }
  }

  // ฟังก์ชันสำหรับการสร้างไฟล์เสียง MP3
  Future<void> _saveAsMp3(String text) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/output.mp3';

    // กำหนดไฟล์ output
    await flutterTts.synthesizeToFile(text, filePath);

    // แสดงข้อความเมื่อสร้างไฟล์สำเร็จ
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Saved MP3 to: $filePath'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(userImage.isNotEmpty ? userImage : 'assets/images/background.jpg'),
            ),
            const SizedBox(width: 10),
            Text(userName.isNotEmpty ? userName : 'User'), // ชื่อผู้ใช้
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _googleSignIn.signOut(); // ล็อกเอาท์จาก Google Sign-In
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demo system page',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Enter your text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageBox(1),
                  _buildImageBox(2),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageBox(3),
                  _buildImageBox(4),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _speak(textController.text);
                },
                child: const Text("Speak Text"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _saveAsMp3(textController.text);
                },
                child: const Text("Download MP3"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageBox(int index) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.image,
              size: 50,
              color: Colors.blueAccent,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<String>(
              value: 'Option $index',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
                _setVoiceForOption(value!);
              },
            ),
            Text(
              names[index - 1],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }
}
