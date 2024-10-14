import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyshelf/pages/login_page.dart';
//import 'package:studyshelf/pages/ppal.dart';
import '../controllers/auth_controller.dart';
import 'package:studyshelf/pages/widgets/custom_buttom.dart'; // Asegúrate de tener tus widgets aquí
import '../pages/widgets/custom_text_field.dart';

class RegisterPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _nameController = TextEditingController();
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Fila con el botón de retroceso y el texto "Registro" centrado
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Get.back(); // Volver a la pantalla anterior
                          },
                        ),
                        Expanded(
                          // Usar Expanded para que el texto ocupe el espacio restante
                          child: Center(
                            child: Text(
                              'Registro',
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

                    // Botones de registro con Google y Apple reciclados
                    GoogleButton(onPressed: () {
                      // Lógica para registrarse con Google
                    }),
                    SizedBox(height: 10),
                    AppleButton(onPressed: () {
                      // Lógica para registrarse con Apple
                    }),
                    SizedBox(height: 15),
                    Center(
                      child: Text('O', style: TextStyle(color: Colors.grey)),
                    ),
                    SizedBox(height: 15),
                    // Campos de texto
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Nombre',
                    ),
                    SizedBox(height: 10),
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

                    // Botón de registro
                    Obx(() => _authController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : _buildRegisterButton(context)),
                    Spacer(),

                    // Texto para iniciar sesión
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.to(LoginPage()),
                        child: Text(
                          '¿Ya tienes cuenta? Inicia sesión',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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

  Widget _buildRegisterButton(BuildContext context) {
    return Center(
      child: RegisterButton(
        text: 'Registrarse', // Texto del botón
        onPressed: () {
          String name = _nameController.text.trim();
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();
          _authController.register(email, password, name);
        },
      ),
    );
  }
}
