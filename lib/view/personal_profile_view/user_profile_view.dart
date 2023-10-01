import 'package:flutter/material.dart';
import 'package:unity/model/firebase/user_profile_model.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key, required this.user});
  final UserProfileModel user;
  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column
          (

          ),
      ),
    );
  }
}
