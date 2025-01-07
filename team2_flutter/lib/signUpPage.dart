//signUpPage
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import ไอคอน
import 'package:google_sign_in/google_sign_in.dart'; // เพิ่มการล็อกอินด้วย Google
import 'signInPage.dart'; // นำเข้าไฟล์ SignInPage

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // กำหนด Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ฟังก์ชันการสมัครสมาชิกด้วย Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        print("Google Sign-In Successful");
        // เมื่อสมัครเสร็จแล้วไปหน้า SignInPage
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()), // นำทางไปที่หน้า SignInPage
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print("Google Sign-In Failed: $error");
      }
    }
  }

  // ฟังก์ชันตรวจสอบและสมัครสมาชิก
  void _signUp() {
    String fullName = _fullNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showAlertDialog("Please fill in all the fields.");
      return;
    }

    if (password != confirmPassword) {
      _showAlertDialog("Passwords do not match.");
      return;
    }

    // ถ้าทุกอย่างถูกต้อง ให้ไปที่หน้า SignInPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()), // นำทางไปที่หน้า SignInPage
    );
  }

  // ฟังก์ชันแสดง AlertDialog
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
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
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
                    onPressed: _signUp, // เรียกฟังก์ชันสมัครสมาชิก
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
                      // ปุ่ม Sign Up ด้วย Facebook
                      ElevatedButton.icon(
                        onPressed: () {
                          // ฟังก์ชันการสมัครสมาชิกด้วย Facebook
                        },
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
                      // ปุ่ม Sign Up ด้วย Google
                      ElevatedButton.icon(
                        onPressed: _signInWithGoogle, // เรียกฟังก์ชัน Google Sign-In
                        icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
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
