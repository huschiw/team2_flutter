// signUpPage.dart
// ignore_for_file: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signInPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // สถานะสำหรับรูปภาพโปรไฟล์
  String? _profileImageUrl;

  // URL รูปภาพเริ่มต้น
  static const String defaultImageUrl =
      "https://i.ebayimg.com/images/g/cQIAAOSwlpNkLfYC/s-l1600.webp";

  // ลงทะเบียนด้วย Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        // ดึงข้อมูลชื่อ, นามสกุล และรูปภาพจากบัญชี Google
        String fullName = account.displayName ?? "Unknown User";
        String email = account.email;

        // แยกชื่อและนามสกุลจาก fullName
        List<String> nameParts = fullName.split(' ');
        String firstName = nameParts.isNotEmpty ? nameParts.first : "";
        String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "";

        // ตั้งค่า username เป็นชื่อ
        String userName = "$firstName";

        // เก็บข้อมูลลงใน TextFields
        _userNameController.text = userName;
        _firstNameController.text = firstName;
        _lastNameController.text = lastName;
        _emailController.text = email;

        // เก็บ URL รูปภาพโปรไฟล์จาก Google
        _profileImageUrl = account.photoUrl;

        // บันทึกข้อมูลลง Firestore
        _saveUserToFirestore(userName, firstName, lastName, email, _profileImageUrl, null);

        print("Google Sign-In Successful");
        print("Username: $userName");
        print("First Name: $firstName");
        print("Last Name: $lastName");
        print("Email: $email");
        print("Profile Image URL: $_profileImageUrl");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Google Sign-In Failed: $error");
      }
    }
  }

  // บันทึกข้อมูลผู้ใช้ลง Firestore
  Future<void> _saveUserToFirestore(
      String userName, String firstName, String lastName, String email, String? profileImageUrl, String? password) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(email);
      await userRef.set({
        'userName': userName,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'profileImageUrl': profileImageUrl ?? defaultImageUrl,
        'password': password ?? "", // เพิ่มรหัสผ่านที่นี่
      });

      print("User data saved to Firestore.");
    } catch (e) {
      print("Error saving user data to Firestore: $e");
    }
  }

  void _signUp() {
    String userName = _userNameController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // ตรวจสอบว่าทุกฟิลด์มีการกรอกหรือไม่
    if (userName.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showAlertDialog("Please fill in all the fields.");
      return;
    }

    if (password != confirmPassword) {
      _showAlertDialog("Passwords do not match.");
      return;
    }

    // ถ้าไม่ใช้ Google Sign-In, ให้ค่า _profileImageUrl เป็น URL ที่กำหนด
    String? profileImageUrl = _profileImageUrl ?? defaultImageUrl;

    // บันทึกข้อมูลผู้ใช้ลง Firestore รวมถึงรหัสผ่าน
    _saveUserToFirestore(userName, firstName, lastName, email, profileImageUrl, password);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/signInPageBG.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextField(
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      minimumSize: const Size(double.infinity, 40.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Or sign up with'),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook, color: Colors.white),
                        label: const Text(
                          'Facebook',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _signInWithGoogle,
                        icon: const FaIcon(FontAwesomeIcons.google,
                            color: Colors.white),
                        label: const Text(
                          'Google',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
