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

  // 4.4 Accion del boton de login
  void _onLogin(){
    // De lo que escribio el usuario, quita espacios en blanco
    final email = emailController.text.trim();
    final pass = passwordController.text;

    // Recalcular los errores (Corregido para que devuelva null si es válido)
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
  }

  // 1.2 crear los listener
  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        // Verificar que no sea nulo
        if (_isHandsUp != null) {
          // Manos abajo en el email
          _isHandsUp!.change(false);
          // 2.2 Mirada Neutral
          _numLook?.value = 50;
        }
      }
    });

    _passwordFocusNode.addListener(() {
      // Manos arriba en password
      _isHandsUp?.change(_passwordFocusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Para obtener el tamaño de la pantalla
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40), // Espacio superior opcional
              SizedBox(
                height: 200,
                width: size.width,
                child: RiveAnimation.asset(
                  'assets/login_bear.riv',
                  stateMachines: const ['Login Machine'],
                  onInit: (artboard) {
                    // Inicializamos el controlador correctamente
                    _controller = StateMachineController.fromArtboard(
                      artboard,
                      'Login Machine',
                    );

                    // Si no se pudo crear, nos salimos para evitar errores
                    if (_controller == null) return;

                    // Agregamos el controlador al artboard
                    artboard.addController(_controller!);

                    // Vinculamos las variables usando findInput
                    _isChecking = _controller?.findSMI('isChecking');
                    _isHandsUp = _controller?.findSMI('isHandsUp');
                    _trigSuccess = _controller?.findSMI('trigSuccess');
                    _trigFail = _controller?.findSMI('trigFail');
                    
                    // 2.3 Vinculamos la variable de mirada numLook
                    _numLook = _controller?.findSMI('numLook');
                  },
                ),
              ),

              // Para separar widgets
              const SizedBox(height: 10),

              // Campo de texto para el email
              TextField(
                focusNode: _emailFocusNode,
                controller: emailController,
                onChanged: (value) {
                  if (_isChecking == null) return;

                  // Activar el modo chismoso
                  _isChecking!.change(true);

                  // 2.4 Implementar numLook para que el oso mire el email
                  final look = (value.length / 50.0 * 100.0).clamp(0.0, 100.0);
                  _numLook?.value = look;

                  // 3.3 Debounce: si vuelve a teclear, reinicia el contador
                  _typingDebounce?.cancel();
                  _typingDebounce = Timer(const Duration(seconds: 3), () {
                    if (!mounted) return;
                    _isChecking?.change(false);
                    _numLook?.value = 50; // Mirada neutral
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

              // Para separar widgets
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

              // Texto olvide mi contraseña
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: const Text(
                  'Forgot Password?',
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              
              const SizedBox(height: 10),
              MaterialButton(
                minWidth: size.width,
                height: 50, 
                color: const Color(0xFFC21235),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),  
                onPressed: _onLogin,
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),
              
              // Sección de registro corregida (estructura de llaves y widgets)
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
    // 1.4 Liberar los focusNodes y recursos al salir de la pantalla
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _typingDebounce?.cancel();
    // 4.11 Liberar los controllers
    emailController.dispose();
    passwordController.dispose(); 
    super.dispose();
  }
}