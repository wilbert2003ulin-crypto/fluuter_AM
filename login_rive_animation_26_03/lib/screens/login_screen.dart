import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async'; // 3.1 importar el timer

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variable para controlar la visibilidad de la contraseña
  bool _obscureText = true;

  // Variable para el remember me (Solicitud de la actividad)
  bool _rememberMe = false;

  // Bandera anti-spam para evitar múltiples clics rápidos en el botón de login
  bool _isLoading = false;

  // Crear el cerebro de las animaciones
  StateMachineController? _controller;
  SMIBool? _isChecking;
  SMIBool? _isHandsUp;
  SMITrigger? _trigSuccess;
  SMITrigger? _trigFail;

  // 2.1 Variable para controlar el recorrido de la mirada del oso
  SMINumber? _numLook;

  // 3.2 Timer para detener la mirada al dejar de escribir
  Timer? _typingDebounce;

  // 1.1 crear variables para focusNode
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  // 4.1 controllers para manipular el texto escrito por usuario
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 4.2 Errores para mostrar en la UI
  String? emailError;
  String? passwordError;

  // 4.3 Validadores para email y password
  bool validateEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }
  
  bool validatePassword(String pass) {
    // minimo de 8, una mayuscula, una minuscula, un numero y un caracter especial
    final re = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
    return re.hasMatch(pass);
  }

  // 4.4 Accion del boton de login con control anti-spam
  void _onLogin() async {
    // Si ya está cargando o procesando, ignoramos clics repetidos (Anti-spam)
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // De lo que escribio el usuario, quita espacios en blanco
    final email = emailController.text.trim();
    final pass = passwordController.text;

    // Recalcular los errores
    final eError = validateEmail(email) ? null : 'Invalid email';
    final pError = validatePassword(pass) ? null : 'Invalid password';

    // 4.5 Avisar si hubo un error
    setState(() {
      emailError = eError;
      passwordError = pError;
    });

    // 4.6 cerrar el teclado y bajar las manos del oso
    FocusScope.of(context).unfocus();
    _typingDebounce?.cancel();
    _isChecking?.change(false);
    _isHandsUp?.change(false);
    _numLook?.value = 50; // Mirada neutral

    // 4.7 Activar triggers
    if(eError == null && pError == null){
      _trigSuccess?.fire();
    } else {
      _trigFail?.fire();
    }

    // Simulamos un pequeño retraso de animación/proceso para liberar el botón (Anti-spam)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 1.2 crear los listener
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

              // Fila de Remember me y Forgot Password (Diseño limpio y sencillo)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Checkbox de Remember me
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
                  // Forgot Password
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),

              // Botn de Login condicionado con _isLoading (Anti-spam)
              MaterialButton(
                minWidth: size.width,
                height: 50, 
                color: const Color(0xFFC21235),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),  
                onPressed: _isLoading ? null : _onLogin, // Desactiva clics si esta cargando
                child: Text(
                  _isLoading ? 'Loading...' : 'Login',
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),
              
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {},
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