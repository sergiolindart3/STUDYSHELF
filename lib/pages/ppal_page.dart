import 'package:flutter/material.dart';
import 'package:studyshelf/pages/login_page.dart';
import 'package:studyshelf/pages/register_page.dart';
import 'package:studyshelf/pages/widgets/custom_button.dart';
import 'package:get/get.dart'; // Importa Get para la navegación

void main() {
  runApp(PpalPage());
}

class PpalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                ),
                SizedBox(height: 10),
                Text(
                  "Te damos la bienvenida a",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(
                  "StudyShelf",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),

                // Botón de "Registrarse"
                CustomButton(
                  text: "Registrarse",
                  onPressed: () {
                    Get.to(RegisterPage());
                  },
                ),

                SizedBox(height: 15),

                // Botón de "Iniciar sesión"
                CustomButton(
                  text: "Iniciar sesión",
                  onPressed: () {
                    Get.to(LoginPage());
                  },
                  color: Color.fromARGB(255, 194, 194, 194),
                  textColor: Color.fromARGB(255, 70, 70, 70),
                ),

                SizedBox(height: 20),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    children: [
                      TextSpan(text: "Si continúas, aceptas los "),
                      TextSpan(
                        text: "Términos del servicio",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                              " de StudyShelf y confirmas que has leído nuestra "),
                      TextSpan(
                        text: "Política de privacidad",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ". "),
                      TextSpan(
                        text: "Aviso de recopilación de datos.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
