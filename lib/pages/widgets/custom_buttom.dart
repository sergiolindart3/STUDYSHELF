import 'package:flutter/material.dart';

// Widget para el botón de "Registrarse"
class RegisterButton extends StatelessWidget {
  final String text; // Texto que aparecerá en el botón
  final VoidCallback onPressed;

  const RegisterButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 55),
        backgroundColor:
            Color(0xFF5292CA), // Color específico para "Registrarse"
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text, // Usamos el texto que recibimos
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}

// Widget para el botón de "Iniciar sesión"
class LoginButton extends StatelessWidget {
  final String text; // Texto que aparecerá en el botón
  final VoidCallback onPressed;

  const LoginButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size(double.infinity, 55),
        backgroundColor: Color.fromARGB(
            255, 194, 194, 194), // Color específico para "Iniciar sesión"
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text, // Usamos el texto que recibimos
        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 70, 70, 70)),
      ),
    );
  }
}

// Widget para el botón de "Continuar con Google"
class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 55),
        backgroundColor:
            const Color(0xFF286FAE), // Color específico para Google
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Agregar el icono de Google
          Image.asset(
            'assets/icon_google.png', // Asegúrate de que la ruta sea correcta
            height: 20, // Ajusta el tamaño del icono según lo necesites
            width: 20,
          ),
          SizedBox(width: 8), // Espacio entre el icono y el texto
          Text(
            'Continuar con Google',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// Widget para el botón de "Continuar con Apple"
class AppleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 55),
        backgroundColor: Colors.black, // Color específico para Apple
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.apple, color: Colors.white), // Icono de Apple
          ),
          Text(
            'Continuar con Apple',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
