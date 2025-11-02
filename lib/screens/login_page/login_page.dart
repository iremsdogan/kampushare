import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kampushare/providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../home_page/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();  

  bool isLogin = true;
  bool _obscureLoginPassword = true;
  bool _obscureSignupPassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _nameController = TextEditingController();
   final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _signupPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _handleSignup() async{
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final email = _signupEmailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _signupPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if(name.isEmpty || surname.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }
    if(password != confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parolaların eşleştiğinden emin olun.')),
      );
      return;
    }

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'surname': surname,
          'email': email,
          'username': username,
          // password alanını kaydetmiyoruz
          'createdAt': FieldValue.serverTimestamp(), 
          'updatedAt': FieldValue.serverTimestamp(),
          'favorites': [],
          'cart': [], 
          'phoneNumber': '',
          'profileImage': 'https://www.gravatar.com/avatar/?d=mp', 
          'university': '', 
          'department': '', 
          'bioText': '', 
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt Başarılı! Giriş yapabilirsiniz.')),
        );

        if (!mounted) return;

        await Future.delayed(const Duration(seconds: 3));
        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        setState(() {
          isLogin = true;
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Kayıt sırasında bir hata oluştu.';
      if (e.code == 'email-already-in-use') {
        message = 'Bu e-posta ile zaten bir hesap mevcut.';
      } else if (e.code == 'weak-password') {
        message = 'Parola en az 6 karakter uzunluğunda olmalıdır.';
      }
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)),
      );
    }
  }
  
  void _handleLogin() async{
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          throw Exception("User data not found in Firestore.");
        }
        final userModel = UserModel.fromFirestore(userDoc);

        Provider.of<ProductsProvider>(context, listen: false).setUserId(user.uid);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(user: userModel),),);
      }
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.code}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-posta veya parola hatalı.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uygulamaya giriş sırasında hata: $e')),
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
            colors: [Color(0xFF0b7373), Color(0xFF6340a2), Color(0xFF17dba3),
            ],
          ), 
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                        children: [
                          const SizedBox(height: 10),
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
                              const SizedBox(height: 30),
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
                                        'Mevcut',
                                        isSelected: isLogin,
                                        onTap: () {
                                          setState(() {
                                            isLogin = true;
                                          });
                                        },
                                      ),
                                      _buildToggleButton(
                                        'Yeni',
                                        isSelected: !isLogin,
                                        onTap: ( ) {
                                          setState(() {
                                            isLogin = false;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Expanded(child: isLogin ? _buildLoginForm() : _buildSignupForm()),
                        ]),
                  ),
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
                _buildTextField(controller: _emailController, icon: Icons.mail_outline, hint: 'E-mail'),
                const Divider(color: Colors.grey, thickness: 1),
                _buildTextField(
                  controller: _passwordController, 
                  icon: Icons.lock_outline, 
                  hint: 'Parola', 
                  obscure: _obscureLoginPassword, 
                  isPassword: true,
                  onToggleVisibility: () => setState(() => _obscureLoginPassword = !_obscureLoginPassword)
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -10,
            left: 0,
            right: 0,
            child: Center(
              child: _buildActionButton('GİRİŞ', _handleLogin),
            ),
          ),
        ],
      ),
      const SizedBox(height: 40),
      Align(
        alignment: Alignment.bottomCenter,
        child: TextButton(
          onPressed: () {},
          child: const Text(
            'Parolamı Unuttum',
            style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.white, color: Colors.white, fontSize: 16),
          ),
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
              _buildTextField(controller: _nameController, icon: Icons.person_2_outlined, hint: 'Ad'),
              const Divider(color: Colors.grey, thickness: 1),
              _buildTextField(controller: _surnameController, icon: Icons.person_2_outlined, hint: 'Soyad'),
               const Divider(color: Colors.grey, thickness: 1),
              _buildTextField(controller: _signupEmailController,icon: Icons.email_outlined, hint: 'E-mail Adresi'),
              const Divider(color: Colors.grey, thickness: 1),
              _buildTextField(controller: _usernameController,icon: Icons.alternate_email_outlined, hint: 'Kullanıcı Adı'),
              const Divider(color: Colors.grey, thickness: 1),
              _buildTextField(
                controller: _signupPasswordController, 
                icon: Icons.lock_outline_rounded, 
                hint: 'Parola',
                obscure: _obscureSignupPassword,
                isPassword: true,
                onToggleVisibility: () => setState(() => _obscureSignupPassword = !_obscureSignupPassword)),
              const Divider(color: Colors.grey, thickness: 1),
              _buildTextField(
                controller: _confirmPasswordController, 
                icon: Icons.lock, 
                hint: 'Parola Tekrarı',
                obscure: _obscureConfirmPassword,
                isPassword: true,
                onToggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
            ],)
            ),
            Positioned(
              bottom: -10,
              left:0,
              right: 0,
              child: Center(
                child: _buildActionButton('KAYDOL', _handleSignup),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
  Widget _buildTextField({required TextEditingController controller, required IconData icon, required String hint, bool obscure = false, bool isPassword = false, VoidCallback? onToggleVisibility}){
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
          prefixIcon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility, color: Colors.black54,
              ),
              onPressed: onToggleVisibility,
            )
            : null,
            ),
        ),
    );
  }
  Widget _buildActionButton(String text, VoidCallback onPressed){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
      ),
      onPressed: onPressed, 
      child: Text(text, style: const TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
