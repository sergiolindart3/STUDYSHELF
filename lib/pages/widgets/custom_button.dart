import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; // Texto que aparecerá en el botón
  final VoidCallback onPressed;
  final Color? color; // Color opcional para el botón
  final Color? textColor;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color, // Agregamos el parámetro opcional para el color
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55),
        backgroundColor: color ??
            const Color(
                0xFF5292CA), // Usamos el color recibido o un predeterminado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
      child: Text(
        text, // Usamos el texto que recibimos
        style: TextStyle(fontSize: 18, color: textColor ?? Colors.white),
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
        elevation: 5,
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
          const SizedBox(width: 8), // Espacio entre el icono y el texto
          const Text(
            'Continuar con Google',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
