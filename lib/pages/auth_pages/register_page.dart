import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyshelf/pages/auth_pages/login_page.dart';
import '../../controllers/auth_controller.dart';
import 'package:studyshelf/pages/widgets/custom_button.dart'; // Asegúrate de tener tus widgets aquí
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      Get.back(); // Volver a la pantalla anterior
                    },
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 65),
                      child: Text(
                        'Registrarse',
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

              // Botones de registro con Google
              GoogleButton(onPressed: () {
                // Lógica para registrarse con Google
              }),
              const SizedBox(height: 15),
              const Center(
                child: Text('O', style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 15),

              // Campos de texto
              CustomTextField(
                controller: _nameController,
                hintText: 'Nombre',
              ),
              const SizedBox(height: 15),

              // Campo de texto personalizado para email
              CustomTextField(
                controller: _emailController,
                hintText: 'Correo',
              ),
              const SizedBox(height: 15),

              // Campo de texto personalizado para contraseña
              CustomTextField(
                controller: _passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Botón de registro
              Obx(() => _authController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : _buildRegisterButton(context)),
              const SizedBox(height: 80),

              // Texto para iniciar sesión
              Center(
                child: GestureDetector(
                  onTap: () => Get.to(
                      LoginPage()), // Redirige a la página de inicio de sesión
                  child: const Text(
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
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Center(
      child: CustomButton(
        text: 'Registrarse',
        onPressed: () {
          String name = _nameController.text.trim();
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();
          _authController.register(
              email, password, name); // Lógica para el registro
        },
      ),
    );
  }
}
