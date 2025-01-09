import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'signInPage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

class SystemPage extends StatefulWidget {
  const SystemPage({super.key});

  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  String userName = ""; 
  String userImage = ""; 
  String? selectedOption;
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textController = TextEditingController();

  List<String> names = [
    "น้องแข้งโต",
    "น้องล่ำบึก",
    "น้องสปาย",
    "น้องเจ๋ง"
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้จาก Google หรือ Firebase Authentication
  Future<void> _getUserInfo() async {
    try {
      GoogleSignInAccount? googleAccount = _googleSignIn.currentUser;
      googleAccount ??= await _googleSignIn.signIn();
      if (googleAccount != null) {
        setState(() {
          userName = googleAccount?.displayName ?? "User";
          userImage = googleAccount?.photoUrl ?? "";
        });
      } else {
        User? firebaseUser = _auth.currentUser;
        if (firebaseUser != null) {
          setState(() {
            userName = firebaseUser.displayName ?? "User";
            userImage = firebaseUser.photoURL ?? "";
          });
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error getting user info: $error");
      }
    }
  }

  // ฟังก์ชันการตั้งค่าเสียงสำหรับแต่ละ Option
  void _setVoiceForOption(String option) async {
    switch (option) {
      case 'Option 1':
        await flutterTts.setLanguage("th-TH");
        await flutterTts.setPitch(1);
        break;
      case 'Option 2':
        await flutterTts.setLanguage("th-TH");
        await flutterTts.setPitch(2);
        break;
      case 'Option 3':
        await flutterTts.setLanguage("th-TH");
        await flutterTts.setPitch(0.2);
        break;
      case 'Option 4':
        await flutterTts.setLanguage("th-TH");
        await flutterTts.setPitch(0.8);
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
    await flutterTts.synthesizeToFile(text, filePath);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Saved MP3 to: $filePath'),
    ));
  }

  // ฟังก์ชันสำหรับล็อกเอาท์
  Future<void> _signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Demo system page', style: TextStyle(fontSize: 24)),
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
