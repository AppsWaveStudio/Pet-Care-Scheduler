import 'package:flutter/material.dart';
import 'package:pet_care_scheduler/auth/signup.dart';
import 'package:pet_care_scheduler/screens/add_pet.dart';
import 'package:pet_care_scheduler/screens/home.dart';
import 'package:pet_care_scheduler/screens/profile.dart';
import 'package:pet_care_scheduler/auth/login.dart';

class Routes {
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String addPet = '/add-pet';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const Home(),
      login: (context) => const Login(),
      signup: (context) => const Signup(),
      profile: (context) => const Profile(),
      addPet: (context) => const AddPetPage(),
    };
  }
}
