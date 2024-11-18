import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyshelf/pages/auth_pages/ppal_page.dart';
import 'package:studyshelf/pages/widgets/custom_button.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Aplica el color de fondo al Scaffold
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
              16.0), // Mueve el padding aquí para afectar todo el contenido
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Get.to(PpalPage()); // Volver a la pantalla anterior
                    },
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Espacio debajo de la fila
              GoogleButton(onPressed: () {
                // Lógica para iniciar sesión con Google
              }),
              const SizedBox(height: 15),
              const Center(
                  child: Text('O', style: TextStyle(color: Colors.grey))),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _emailController,
                hintText: 'Correo',
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Obx(() => _authController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : _buildLoginButton(context)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Lógica para recuperar la contraseña
                },
                child: const Text(
                  '¿Has olvidado tu contraseña?',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: CustomButton(
        text: 'Iniciar Sesión',
        onPressed: () {
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();
          _authController.login(email, password);
        },
      ),
    );
  }
}
