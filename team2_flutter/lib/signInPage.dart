//signInPage
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import ไอคอน
import 'package:google_sign_in/google_sign_in.dart'; // เพิ่มการล็อกอินด้วย Google
import 'signUpPage.dart'; // นำเข้าไฟล์ SignUpPage
import 'homePage.dart'; // นำเข้าไฟล์ HomePage

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignInPage> {
  bool _isRememberMeChecked = false;

  // กำหนด Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ฟังก์ชันการล็อกอินด้วย Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        if (kDebugMode) {
          print("Google Sign-In Successful");
        }
        // เปลี่ยนหน้าไปที่ SystemPage หลังจากล็อกอินสำเร็จ
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), // นำทางไปที่หน้า SystemPage
        );
      }
    } catch (error) {
      print("Google Sign-In Failed: $error");
    }
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
                    'Sign In',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _isRememberMeChecked,
                            onChanged: (value) {
                              setState(() {
                                _isRememberMeChecked = value!;
                              });
                            },
                          ),
                          const Text('Remember Me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forget Password'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // เปลี่ยนหน้าไปที่ HomePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()), // นำทางไปที่หน้า HomePage
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      minimumSize: const Size(double.infinity, 40.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Or sign in with'),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // เพิ่มฟังก์ชัน Login ด้วย Facebook
                        },
                        icon: const Icon(Icons.facebook, color: Colors.white),
                        label: const Text('Facebook',
                        style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _signInWithGoogle, // เรียกฟังก์ชัน Google Sign-In
                        icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
                        label: const Text('Google',
                        style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // นำทางไปหน้า Register
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()), // นำทางไปที่หน้า SignUpPage
                      );
                    },
                    child: const Text("Don't have an account? Register"),
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
