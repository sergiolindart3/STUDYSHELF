import 'package:image_picker/image_picker.dart';
import 'package:studyshelf/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:studyshelf/models/user_model.dart';
import 'package:studyshelf/pages/widgets/custom_text_field.dart';
import 'package:studyshelf/pages/widgets/custom_buttom.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  _Perfil createState() => _Perfil();
}

class _Perfil extends State<Perfil> {
  final AuthController _authController = Get.find<AuthController>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _selectedImage; //Imagen seleccionada por el usuario

  @override
  void initState() {
    super.initState();
    _nameController.text = _authController.userModel.value?.name ?? '';
    _lastNameController.text = _authController.userModel.value?.lastName ?? '';
    _phoneController.text = _authController.userModel.value?.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    String name = _nameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String phone = _phoneController.text.trim();
    try {
      // Actualizar los datos del usuario
      await _authController.updateUserProfile(name, lastName, phone);

      // Si se ha seleccionado una imagen, subirla y actualizar la URL
      if (_selectedImage != null) {
        await _authController.updateProfileImage(_selectedImage!);
      }

      Get.snackbar("Éxito", "Perfil actualizado correctamente");
    } catch (e) {
      Get.snackbar("Error", "No se pudo actualizar el perfil");
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = _authController.userModel.value;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagen de perfil
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: _selectedImage == null && user.imageUrl == null
                    ? const Color.fromARGB(
                        255, 141, 192, 236) // Cambia el color de fondo a azul
                    : null,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : (user.imageUrl != null
                        ? NetworkImage(user.imageUrl!)
                        : null), // Si no hay imagen, dejar el fondo vacío
                child: _selectedImage == null && user.imageUrl == null
                    ? const Icon(Icons.person,
                        color: Colors.white,
                        size:
                            80) // Mostrar un ícono de persona si no hay imagen
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Campo de texto para el nombre
            CustomTextField(
              hintText: 'Nombre',
              controller: _nameController,
              obscureText: false,
            ),
            SizedBox(height: 10),

            // Campo de texto para el apellido
            CustomTextField(
              hintText: 'Apellido',
              controller: _lastNameController,
              obscureText: false,
            ),
            SizedBox(height: 10),

            // Campo de texto para el correo electrónico (usar el valor del usuario)
            CustomTextField(
              hintText: 'Correo Electrónico',
              controller: TextEditingController(
                  text: user.email), // Mostrar el correo del usuario
              obscureText: false,
              readOnly: true,
            ),
            SizedBox(height: 10),

            // Campo de texto para el celular
            CustomTextField(
              hintText: 'Telefono',
              controller: _phoneController,
              obscureText: false,
            ),
            SizedBox(height: 20),

            RegisterButton(
              text: "Guardar Cambios",
              onPressed: () {
                _updateProfile();
              },
            ),
            SizedBox(height: 10),

            // Botón para cerrar sesión
            ElevatedButton(
              onPressed: () {
                _authController.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Color rojo para el botón
              ),
              child: Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
