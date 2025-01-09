import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'signUpPage.dart';
import 'homePage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignInPage> {
  bool _isRememberMeChecked = false;
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //ล็อกอินด้วย email/username และ password
  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String usernameOrEmail = _usernameOrEmailController.text.trim();
      final String password = _passwordController.text;

      String email = usernameOrEmail;
      if (!usernameOrEmail.contains('@')) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('userName', isEqualTo: usernameOrEmail)
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          email = snapshot.docs.first.get('email');
        } else {
          throw FirebaseAuthException(
              code: 'user-not-found', message: 'Username not found');
        }
      }

      // ตรวจสอบ email และ password ก่อนทำการล็อกอิน
      print('Email: $email');
      print('Password: $password');

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  //ล็อกอินด้วย google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
            code: 'sign-in-canceled', message: 'Google sign-in was canceled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase Authentication จะจัดการการตรวจสอบโดยตรง
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // ใช้ credential ที่ได้ในการลงชื่อเข้าใช้ Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  //ล็อกอินด้วย facebook
  Future<void> _signInWithFacebook() async {
    try {
      // เข้าสู่ระบบผ่าน Facebook
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // รับ AccessToken จากผลลัพธ์
        final AccessToken? accessToken = result.accessToken;

        if (accessToken != null) {
          // ใช้ tokenString ในการสร้าง credential
          final OAuthCredential credential =
              FacebookAuthProvider.credential(accessToken.tokenString);

          // ลงชื่อเข้าใช้ Firebase ด้วย Facebook credential
          await FirebaseAuth.instance.signInWithCredential(credential);

          // ไปยังหน้า HomePage หลังจากล็อกอินสำเร็จ
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          throw FirebaseAuthException(
              code: 'access-token-null', message: 'Access token is null');
        }
      } else {
        throw FirebaseAuthException(
            code: 'sign-in-canceled', message: 'Facebook sign-in was canceled');
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
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
                color: Colors.white.withOpacity(0.9),
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
                  TextField(
                    controller: _usernameOrEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Username or Email',
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
                    onPressed: _signInWithEmailAndPassword,
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
                        onPressed: _signInWithFacebook,
                        icon: const FaIcon(FontAwesomeIcons.facebook,
                            color: Colors.white),
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
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
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
