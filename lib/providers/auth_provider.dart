import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_social/models/user_model.dart';
import 'package:x_social/providers/dashboard_provider.dart';
import 'package:x_social/utils/dialogs.dart';
import 'package:x_social/utils/extensions.dart';
import 'package:x_social/views/dashboard.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({this.test = false});

  final bool test;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  FirebaseAuth get auth {
    if (test) {
      return MockFirebaseAuth(
        mockUser: MockUser(
          uid: "IVwBza8TjmU408wy26SrWAh7rcD2",
          email: "olawoleaeo@gmail.com",
          displayName: "Olawole Oyedele",
        ),
      );
    } else {
      return FirebaseAuth.instance;
    }
  }

  CollectionReference<Map<String, dynamic>> get userCollection {
    if (test) {
      return FakeFirebaseFirestore().collection("users");
    } else {
      return FirebaseFirestore.instance.collection("users");
    }
  }

  Future<bool> checkIfLoggedIn(BuildContext context) async {
    final user = auth.currentUser;
    if (user == null) return false;
    final results = await userCollection.where("user_id", isEqualTo: user.uid).get();
    if (results.docs.isNotEmpty) {
      final doc = results.docs.first.data();
      if (doc["user_id"] == null || doc["user_id"] == "") return false;
      if (context.mounted) context.read<DashboardProvider>().user = UserModel.fromJson(doc);
    } else {
      return false;
    }
    return true;
  }

  Future<void> login(BuildContext context) async {
    String? message;
    if (emailController.text.trim().isEmpty) {
      message = "Invalid email";
    } else if (passwordController.text.trim().length < 6) {
      message = "Invalid password (must be at least 6 characters)";
    }
    if (message != null) {
      context.showSnackBar(title: message);
      return;
    }

    try {
      AppDialogs.loadingDialog(context);
      final user = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final results = await userCollection.where("user_id", isEqualTo: user.user?.uid).get();
      if (results.docs.isNotEmpty) {
        final doc = results.docs.first.data();
        if (doc["user_id"] == null || doc["user_id"] == "") {
          if (context.mounted) context.back();
          if (context.mounted) context.showSnackBar(title: "Could not find user", isError: true);
          return;
        }
        if (context.mounted) {
          context.back();
          context.read<DashboardProvider>().user = UserModel.fromJson(doc);
          context.off(const Dashboard());
        }
      } else {
        if (context.mounted) context.back();
        if (context.mounted) context.showSnackBar(title: "Could not find user", isError: true);
        return;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      var message = "Login failed";
      switch (e.code) {
        case "invalid-email":
          message = "Invalid email address";
          break;
        case "user-disabled":
          message = "User account disabled";
          break;
        case "user-not-found":
          message = "User account not found";
          break;
        case "wrong-password":
          message = "Wrong password";
          break;
        case "invalid-credential":
          message = "Wrong email and password";
          break;
        case "network-request-failed":
          message = "Network error";
          break;
      }
      if (context.mounted) context.back();
      if (context.mounted) context.showSnackBar(title: message, isError: true);
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) context.back();
      if (context.mounted) context.showSnackBar(title: "Login failed", isError: true);
    }
  }

  Future<void> register(BuildContext context) async {
    String? message;
    if (emailController.text.trim().isEmpty) {
      message = "Invalid email";
    } else if (passwordController.text.trim().length < 6) {
      message = "Invalid password (must be at least 6 characters)";
    } else if (nameController.text.trim().isEmpty) {
      message = "Invalid full name";
    }
    if (message != null) {
      context.showSnackBar(title: message);
      return;
    }

    try {
      AppDialogs.loadingDialog(context);
      final user = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final results = await userCollection.add(UserModel(
        userID: user.user?.uid,
        email: emailController.text.trim(),
        name: nameController.text.trim(),
      ).toJson());
      await userCollection.doc(results.id).update(UserModel(id: results.id).toJson());
      if (context.mounted) {
        context.read<DashboardProvider>().user = UserModel(
          id: results.id,
          userID: user.user?.uid,
          email: emailController.text.trim(),
          name: nameController.text.trim(),
        );
        context.back();
        context.off(const Dashboard());
      }
    } on FirebaseAuthException catch (e) {
      var message = "Login failed";
      switch (e.code) {
        case "invalid-email":
          message = "Invalid email address";
          break;
        case "email-already-in-use":
          message = "Email already exists";
          break;
        case "weak-password":
          message = "Password is weak";
          break;
      }
      if (context.mounted) context.back();
      if (context.mounted) context.showSnackBar(title: message, isError: true);
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) context.back();
      if (context.mounted) context.showSnackBar(title: "Login failed", isError: true);
    }
  }
}
