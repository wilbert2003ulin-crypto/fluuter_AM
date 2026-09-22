import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async'; //3.1 importar el timer

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

  //2.1 Variable para controlar el recorrido de la mirada del oso

  SMINumber? _numLook;

  //3.2 Timer para detener la mirada al dejar de escribir
  Timer? _typingDebounce;

  //1.1 crear variables para focusNode
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  //1.2 crear los listeners (Oyentes/Chismosos)

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener( () {
      if (_emailFocusNode.hasFocus) {
        //verificar que no sea nulo
        if (_isHandsUp != null) {
          //Manos arriba en el email
          _isHandsUp!.change(false);
          //2.2 Mirada Neutral
          _numLook?.value = 50;
        }
      }
    } )  ;
    _passwordFocusNode.addListener( () {
      //Manos arriba en password
      _isHandsUp?.change (_passwordFocusNode.hasFocus) ; 
        
      
    } )  ;
    
  }

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
                    //2.3 Vinculamos la variable de mirada numLook
                    _numLook = _controller?.findSMI('numLook');
                  },
                ),
              ),
              
              // Para separar widgets
              const SizedBox(height: 10),
              
              // Campo de texto para el email
              TextField(
                //1.3 Asignamos el focusNode al campo de email
                focusNode: _emailFocusNode, // Asignamos el focusNode al campo de email,
                onChanged: (value) {
                  if (_isHandsUp != null) {
                    //No se tapa los ojos
                    //_isHandsUp!.change(false);
                  }
                  //Si ischecking es nulo
                  if (_isChecking == null) return; {
                    //Activar el modo chismoso
                    _isChecking!.change(true);
                    //2.4 Implementar nomLook para que el oso mire el email
                    // Ajuste de limites de 0 a 100
                    // 80 es la medida de calibracion
                    final look = (value.length / 50.0 * 100.0).clamp(0.0, 100.0);
                    //clamp es el rango (abrazadera)
                    _numLook?.value = look;


                    //3.3 Debounce : si vuelve a teclear, reinicia el contador
                    //Cancelar cualquier timer existente
                    _typingDebounce?.cancel();
                    //Crear un nuevo timer
                    _typingDebounce = Timer(const Duration (seconds: 3), () {
                      //Si se cierra la pantalla (!mounted es que no esta activa)
                      if (!mounted) return;
                      _isChecking?.change(false);
                      _numLook?.value = 50; // Mirada neutral
                    });
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
                //1.3 Asignamos el focusNode al campo de email
                focusNode: _passwordFocusNode, // Asignamos el focusNode al campo de email,
                onChanged: (value) {
                  if (_isChecking != null) {
                    //No se tapa los ojos
                    //_isChecking!.change(false);
                  }
                  //Si ischecking es nulo
                  if (_isHandsUp != null) return; {
                    //Activar el modo chismoso
                    _isHandsUp!.change(true);

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

  @override

  void dispose() {
    //1.4 Liberar los focusNodes cuando el widget se elimine del árbol de widgets, liberar memoria o recursos
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    //3.4 Liberar el timer
    _typingDebounce?.cancel();
    super.dispose();
  }


}
