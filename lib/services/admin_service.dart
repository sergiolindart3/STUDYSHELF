import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyshelf/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Cambiar el rol de un usuario (solo admin puede hacerlo)
  Future<void> updateUserRole(String uid, String newRole) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Verificamos si el usuario actual es admin
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();
        UserModel currentUserData = UserModel.fromFirestore(
          userDoc.data() as Map<String, dynamic>,
          currentUser.uid,
        );

        // Si es admin, cambiamos el rol del usuario
        if (currentUserData.isAdmin) {
          await _firestore.collection('users').doc(uid).update({
            'role': newRole, // Actualizamos el rol
          });
          print("Rol actualizado exitosamente.");
        } else {
          throw Exception("No tienes permisos para cambiar el rol.");
        }
      }
    } catch (e) {
      print("Error al cambiar el rol: $e");
      throw Exception("Error al cambiar el rol.");
    }
  }

  // Método para verificar si el usuario es administrador
  Future<bool> isAdmin() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        UserModel currentUserData = UserModel.fromFirestore(
          userDoc.data() as Map<String, dynamic>,
          user.uid,
        );
        return currentUserData.isAdmin;
      }
      return false;
    } catch (e) {
      print("Error al verificar si el usuario es admin: $e");
      return false;
    }
  }

  // Obtener todos los usuarios
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      List<UserModel> users = snapshot.docs.map((doc) {
        return UserModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
      return users;
    } catch (e) {
      print("Error al obtener todos los usuarios: $e");
      throw Exception("Error al obtener todos los usuarios.");
    }
  }

  // Método para eliminar un usuario y su foto de perfil
  Future<void> deleteUser(String uid) async {
    try {
      // Obtener datos del usuario para acceder a su URL de imagen
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        // Verificar si el usuario tiene una URL de imagen
        String? imageUrl = userData?[
            'imageUrl']; // Asegúrate de que el campo se llame 'imageUrl'

        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            // Eliminar la imagen de Firebase Storage
            Reference imageRef = _storage.refFromURL(imageUrl);
            await imageRef.delete();
            print("Imagen de perfil eliminada exitosamente.");
          } catch (e) {
            print("Error al eliminar la imagen de perfil: $e");
          }
        }
      }

      // Eliminar el documento del usuario en Firestore
      await _firestore.collection('users').doc(uid).delete();
      print("Usuario eliminado exitosamente.");
    } catch (e) {
      print("Error al eliminar usuario: $e");
      throw Exception("Error al eliminar el usuario.");
    }
  }

  String getCurrentUserUid() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    } else {
      // En lugar de lanzar una excepción, regresa una cadena vacía o maneja el error con un log
      print("No hay usuario autenticado.");
      return ''; // O manejar de forma adecuada
    }
  }
}
