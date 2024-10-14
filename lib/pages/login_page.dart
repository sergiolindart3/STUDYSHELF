import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyshelf/pages/ppal_page.dart';
import 'package:studyshelf/pages/widgets/custom_buttom.dart'; // Asegúrate de tener tus widgets aquí
import '../controllers/auth_controller.dart';
import '../pages/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(), // Espacio para empujar el container hacia abajo
            Container(
              height: MediaQuery.of(context).size.height *
                  0.95, // Tamaño del contenedor ajustado al 95%
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Alineación centrada
                  children: [
                    // Fila con el botón de retroceso y el texto "Iniciar sesión" centrado
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Get.to(PpalPage()); // Volver a la pantalla anterior
                          },
                        ),
                        Expanded(
                          // Usar Expanded para que el texto ocupe el espacio restante
                          child: Center(
                            child: Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                fontSize: 18, // Tamaño de fuente
                                fontWeight: FontWeight.bold, // Texto en negrita
                                color: Colors.black, // Color cambiado a negro
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // Espacio debajo de la fila

                    // Botones de inicio de sesión con Google y Apple reciclados
                    GoogleButton(onPressed: () {
                      // Lógica para iniciar sesión con Google
                    }),
                    SizedBox(height: 10),
                    AppleButton(onPressed: () {
                      // Lógica para iniciar sesión con Apple
                    }),
                    SizedBox(height: 15),
                    Center(
                        child: Text('O', style: TextStyle(color: Colors.grey))),
                    SizedBox(height: 15),

                    // Campos de texto
                    // Campo de texto personalizado para email
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Correo',
                    ),
                    SizedBox(height: 10),
                    // Campo de texto personalizado para contraseña
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Contraseña',
                      obscureText: true,
                    ),
                    SizedBox(height: 20),

                    // Botón de inicio de sesión
                    Obx(() => _authController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : _buildLoginButton(context)),
                    //SizedBox(height: 15),
                    Spacer(),
                    // Texto para recuperar la contraseña
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Lógica para recuperar la contraseña
                        },
                        child: Text(
                          '¿Has olvidado tu contraseña?',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16), // Color cambiado a negro
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir los campos de texto
  Widget _buildTextField(
      BuildContext context, String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: hintText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Método para el botón de inicio de sesión
  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: RegisterButton(
        text: 'Iniciar Sesión', // Texto del botón
        onPressed: () {
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();
          _authController.login(email, password); // Lógica de inicio de sesión
        },
      ),
    );
  }
}
