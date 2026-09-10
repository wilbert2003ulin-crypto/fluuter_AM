import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

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

  @override
  Widget build(BuildContext context) {
    // Para obtener el tamaño de la pantalla
    final Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: size.width,
                child: RiveAnimation.asset(
                  'login_bear.riv', // Asegúrate de incluir la ruta de assets/
                  stateMachines: const ['Login Machine'],
                  onInit: (artboard) {
                    //  Inicializamos el controlador correctamente
                    _controller = StateMachineController.fromArtboard(
                      artboard, 
                      'Login Machine',
                    );

                    //  Si no se pudo crear, nos salimos para evitar errores
                    if (_controller == null) return;

                    //  Agregamos el controlador al artboard
                    artboard.addController(_controller!);

                    //  Vinculamos las variables usando findInput
                    _isChecking = _controller?.findSMI('isChecking');
                    _isHandsUp = _controller?.findSMI('isHandsUp');
                    _trigSuccess = _controller?.findSMI('trigSuccess');
                    _trigFail = _controller?.findSMI('trigFail');
                  },
                ),
              ),
              
              // Para separar widgets
              const SizedBox(height: 10),
              
              // Campo de texto para el email
              TextField(
                onChanged: (value) {
                  if (_isHandsUp != null) {
                    //No se tapa los ojos
                    _isHandsUp!.change(false);
                  }
                  //Si ischecking es nulo
                  if (_isChecking != null) return; {
                    //Activar el modo chismoso
                    _isChecking!.change(true);

                  }
                },
                //Para mostrar el tipo de teclado adecuado para el email
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
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
                onChanged: (value) {
                  if (_isHandsUp != null) {
                    //No se tapa los ojos
                    _isHandsUp!.change(true);
                  }
                  //Si ischecking es nulo
                  if (_isChecking != null) return; {
                    //Activar el modo chismoso
                    _isChecking!.change(false);

                  }
                },
                obscureText: _obscureText, // Oculta los caracteres para la contraseña
                decoration: InputDecoration(
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
            ],
          ),
        ),
      ),
    );
  }
}