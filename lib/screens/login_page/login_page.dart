import 'package:flutter/material.dart';
import '../home_page/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); 
  final TextEditingController _usernameController = TextEditingController(); 
  final TextEditingController _nonecontroller = TextEditingController();
  bool isLogin = true;

  void _handleLogin(){
    String email = _emailController.text;
    String password = _passwordController.text;
    String username = _usernameController.text; 

    if(username == 'irems' && password == '1234'){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => HomePage(username: username),
        )
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş Bilgileri Hatalı!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,            
            colors: [Color(0xFFffb44b),Color(0xFFff6363),
            ],
          ), 
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 48),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/transparent_icon.png',
                          height: 110,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 350,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black26.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 300),
                            alignment:
                                isLogin ? Alignment.centerLeft : Alignment.centerRight,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildToggleButton(
                                'Existing',
                                isSelected: isLogin,
                                onTap: () {
                                  setState(() {
                                    isLogin = true;
                                  });
                                },
                              ),
                              _buildToggleButton(
                                'New',
                                isSelected: !isLogin,
                                onTap: () {
                                  setState(() {
                                    isLogin = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: isLogin ? _buildLoginForm() : _buildSignupForm(),
                      ),
                    ],
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildToggleButton(String text, {required bool isSelected, required VoidCallback onTap}){
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected ? [const BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0,2),
          ),
          ] : [],
        ),
        child: Text(
          text, style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _buildLoginForm(){ 
    return Column(
      children: [
        Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 60),
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],),
            child: Column(
              children: [
                _buildTextField(controller: _usernameController, icon: Icons.alternate_email_outlined, hint: 'User Name'),
                const Divider(color: Colors.grey, thickness: 1),
                _buildTextField(controller: _passwordController, icon: Icons.lock, hint: 'Password', obscure: true),
              ],
            ),
          ),
          Positioned(
            bottom: -10,
            left: 0,
            right: 0,
            child: Center(
              child: _buildActionButton('LOGIN', _handleLogin),
            ),
          ),
        ],
      ),
      const SizedBox(height: 50),
        TextButton(
            onPressed: () {}, 
            child: const Text(
              'Forgot Password?', 
              style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white, color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
  Widget _buildSignupForm(){
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 60),
              decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
              _buildTextField(controller: _nonecontroller, icon: Icons.person_2_outlined, hint: 'Name'),
              const Divider(color: Colors.grey, thickness: 1),
              _buildTextField(controller: _nonecontroller, icon: Icons.person_2_outlined, hint: 'Surname'),
               const Divider(color: Colors.grey, thickness: 1),
              _buildTextField(controller: _nonecontroller,icon: Icons.email_outlined, hint: 'E-mail Address'),
              const Divider(color: Colors.grey, thickness: 1),
              _buildTextField(controller: _nonecontroller,icon: Icons.alternate_email_outlined, hint: 'User Name'),
              const Divider(color: Colors.grey, thickness: 1),
              _buildTextField(controller: _nonecontroller, icon: Icons.lock_outline_rounded, hint: 'Password'),
              const Divider(color: Colors.grey, thickness: 1),
              _buildTextField(controller: _nonecontroller, icon: Icons.lock, hint: 'Password Confirmation'),
            ],)
            ),
            Positioned(
              bottom: -10,
              left:0,
              right: 0,
              child: Center(
                child: _buildActionButton('SIGN UP', () {

                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildTextField({required controller,required IconData icon, required String hint, bool obscure = false}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller:controller,
        obscureText: obscure,
        decoration: InputDecoration(
          icon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: obscure ? const Icon(Icons.visibility) : null,
        ),
      )
    );
  }
  Widget _buildActionButton(String text, VoidCallback onPressed){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
      ),
      onPressed: onPressed, 
      child: Text(text, style: const TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
