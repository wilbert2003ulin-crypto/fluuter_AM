import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:async';

import 'package:donut_app/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Controladores de animaciones Rive
  StateMachineController? _controller;
  SMIBool? _isChecking;
  SMIBool? _isHandsUp;
  SMITrigger? _trigSuccess;
  SMITrigger? _trigFail;
  SMINumber? _numLook;

  Timer? _typingDebounce;

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  bool validateEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }

  bool validatePassword(String pass) {
    final re = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
    );
    return re.hasMatch(pass);
  }

  bool _validarCampos(String email, String pass) {
    final eError = validateEmail(email) ? null : 'Correo inválido';
    final pError = validatePassword(pass)
        ? null
        : 'Mín. 8 caracteres, mayús., minús., número y símbolo';

    setState(() {
      emailError = eError;
      passwordError = pError;
    });

    FocusScope.of(context).unfocus();
    _typingDebounce?.cancel();
    _isChecking?.change(false);
    _isHandsUp?.change(false);
    _numLook?.value = 50;

    return eError == null && pError == null;
  }

  // 1. INICIAR SESIÓN CON CORREO Y CONTRASEÑA
  void _onLogin() async {
    if (_isLoading) return;

    final email = emailController.text.trim();
    final pass = passwordController.text;

    if (!_validarCampos(email, pass)) {
      _trigFail?.fire();
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      _trigSuccess?.fire();
      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _trigFail?.fire();
      String mensaje = 'Error al iniciar sesión';
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        mensaje = 'Correo no registrado o contraseña incorrecta.';
      } else if (e.code == 'wrong-password') {
        mensaje = 'Contraseña incorrecta.';
      } else if (e.code == 'too-many-requests') {
        mensaje = 'Demasiados intentos. Intenta más tarde.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensaje), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 2. REGISTRAR NUEVO USUARIO CON CORREO
  void _onRegister() async {
    if (_isLoading) return;

    final email = emailController.text.trim();
    final pass = passwordController.text;

    if (!_validarCampos(email, pass)) {
      _trigFail?.fire();
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      _trigSuccess?.fire();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Cuenta creada con éxito! Bienvenido.'),
            backgroundColor: Colors.green,
          ),
        );
      }

      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _trigFail?.fire();
      String mensaje = 'Error al registrar usuario';
      if (e.code == 'email-already-in-use') {
        mensaje = 'Este correo ya está registrado. Presiona Login.';
      } else if (e.code == 'weak-password') {
        mensaje = 'La contraseña es muy débil.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensaje), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 3. INICIAR SESIÓN CON GOOGLE
  Future<void> _onGoogleSignIn() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // El usuario cerró el selector de cuentas de Google
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      _trigSuccess?.fire();
      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      _trigFail?.fire();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar con Google: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        if (_isHandsUp != null) {
          _isHandsUp!.change(false);
          _numLook?.value = 50;
        }
      }
    });

    _passwordFocusNode.addListener(() {
      _isHandsUp?.change(_passwordFocusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              SizedBox(
                height: 200,
                width: size.width,
                child: RiveAnimation.asset(
                  'assets/login_bear.riv',
                  stateMachines: const ['Login Machine'],
                  onInit: (artboard) {
                    _controller = StateMachineController.fromArtboard(
                      artboard,
                      'Login Machine',
                    );

                    if (_controller == null) return;

                    artboard.addController(_controller!);

                    _isChecking = _controller?.findSMI('isChecking');
                    _isHandsUp = _controller?.findSMI('isHandsUp');
                    _trigSuccess = _controller?.findSMI('trigSuccess');
                    _trigFail = _controller?.findSMI('trigFail');
                    _numLook = _controller?.findSMI('numLook');
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Campo de texto para el email
              TextField(
                focusNode: _emailFocusNode,
                controller: emailController,
                onChanged: (value) {
                  if (_isChecking == null) return;
                  _isChecking!.change(true);

                  final look = (value.length / 50.0 * 100.0).clamp(0.0, 100.0);
                  _numLook?.value = look;

                  _typingDebounce?.cancel();
                  _typingDebounce = Timer(const Duration(seconds: 3), () {
                    if (!mounted) return;
                    _isChecking?.change(false);
                    _numLook?.value = 50;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  errorText: emailError,
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Campo de texto para la contraseña
              TextField(
                focusNode: _passwordFocusNode,
                controller: passwordController,
                onChanged: (value) {
                  if (_isHandsUp != null) {
                    _isHandsUp!.change(true);
                  }
                },
                obscureText: _obscureText,
                decoration: InputDecoration(
                  errorText: passwordError,
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              // Fila de Remember me y Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Botón de Login tradicional
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: const Color(0xFFC21235),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: _isLoading ? null : _onLogin,
                child: Text(
                  _isLoading ? 'Loading...' : 'Login',
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 12),

              // Botón de Inicio de Sesión con Google
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(size.width, 50),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _onGoogleSignIn,
                icon: const Icon(
                  Icons.g_mobiledata,
                  size: 32,
                  color: Colors.red,
                ),
                label: const Text(
                  'Continuar con Google',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Botón de Register
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: _isLoading ? null : _onRegister,
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _typingDebounce?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
