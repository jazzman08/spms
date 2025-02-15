



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spms/pages/auth/Login_Page.dart';
import 'package:spms/pages/auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:spms/pages/widgets/form_container_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

    @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("signUp")),
        backgroundColor: Colors.blue,
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal:15 ),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sign Up",style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),)
          ,const SizedBox(
            height: 30,
            ),
            FormContainerWidget(
controller: _usernameController,
              hintText: "username",
              isPasswordField: false,
            ),
            const SizedBox(
            height: 10,
            ),
            FormContainerWidget(
controller: _emailController,
              hintText: "email",
              isPasswordField: false,
            ),
            const SizedBox(height: 10,),
            FormContainerWidget(
controller: _passwordController,
              hintText: "password",
              isPasswordField: true,
            ),
            const SizedBox(
              height: 30,
              ),
          GestureDetector(
            onTap: _signUp,
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text("Sign Up",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),
              ),
            ),
            const SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("already have an account?"),
              const SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage()),
                      (route) => false);
                },
                child: const Text("Login", style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
              )
            ],)
          ],
          ),
        ),
      ),
    );
  }
void _signUp() async {
  // ignore: unused_local_variable
  String username = _usernameController.text;
  String email = _emailController.text;
  String password = _passwordController.text;

  User? user = await _auth.signUpWithEmailAndPassword(email, password);


  if (user != null) {
    print("user is successfully created");
    Navigator.pushNamed(context, "/home");
    } else {
      print("Some error happend");
    }

  }
}

