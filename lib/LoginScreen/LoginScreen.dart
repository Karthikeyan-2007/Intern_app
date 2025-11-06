import 'package:flutter/material.dart';
import 'package:school_app/Admin/Navigator.dart';
import '../Parent/Navigator.dart';
import '../Staff/Navigator.dart';
import '../Student/Navigator.dart';
import '../principal/Navigator.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final schoolBlue = const Color(0xFF0062B1);
  bool isAuthorityMode = false;
  String selectedRole = "Student";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    final roles = isAuthorityMode ? ["Staff", "Adm/prc"] : ["Student", "Parent"];

    return Scaffold(
      backgroundColor: schoolBlue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 25),
            Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "ABC Hr. Sec. School",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: schoolBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Sign in to continue your journey",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          _buildRoleButton(
                            title: roles[0],
                            isActive: selectedRole == roles[0],
                            onTap: () {
                              setState(() {
                                selectedRole = roles[0];
                              });
                            },
                            color: schoolBlue,
                          ),
                          const SizedBox(width: 12),
                          _buildRoleButton(
                            title: roles[1],
                            isActive: selectedRole == roles[1],
                            onTap: () {
                              setState(() {
                                selectedRole = roles[1];
                              });
                            },
                            color: schoolBlue,
                          ),
                        ],
                      ),

                      SizedBox(height: 30),

                      _buildTextField(
                        label: "Email",
                        icon: Icons.email_outlined,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        error: _emailError,
                      ),
                      SizedBox(height: 20),

                      _buildTextField(
                        label: "Password",
                        icon: Icons.lock_outline,
                        obscureText: true,
                        controller: passwordController,
                        error: _passwordError,
                      ),
                      SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: schoolBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _validateLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: schoolBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isAuthorityMode
                                ? "If Student/Parent sign in "
                                : "If Authorities sign in ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isAuthorityMode = !isAuthorityMode;
                                selectedRole = isAuthorityMode ? "Staff" : "Student";
                              });
                            },
                            child: Text(
                              "Here",
                              style: TextStyle(
                                color: schoolBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      Center(
                        child: Text(
                          "Need help? Contact admin@abcschool.edu",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateLogin() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();
    if (email == "karthi@gmail.com" && password == "123456" && selectedRole == "Student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudentNavigatorScreen(), 
        ),
      );
      return;
    }

    if (email == "parent@gmail.com" && password == "123456" && selectedRole == "Parent") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ParentNavigatorScreen(),
        ),
      );
      return;
    }

    if (email == "staff@gmail.com" && password == "123456" && selectedRole == "Staff") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StaffNavigatorScreen(),
        ),
      );
      return;
    }

    if (email == "prc@gmail.com" && password == "123456" && selectedRole == "Adm/prc") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PrcNavigatorScreen(),
        ),
      );
      return;
    }

    if (email == "adm@gmail.com" && password == "123456" && selectedRole == "Adm/prc") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminNavigatorScreen(),
        ),
      );
      return;
    }
    setState(() {
      if (email != "karthi@gmail.com" && email != "parent@gmail.com" && email != "staff@gmail.com" && email != "prc@gmail.com" && email !="adm@gmail.com") {
        _emailError = "Invalid email";
      } else {
        _passwordError = "Incorrect password";
      }
    });
  }


  Widget _buildRoleButton({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? error,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        prefixIcon: Icon(icon, color: const Color(0xFF757575)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }
}