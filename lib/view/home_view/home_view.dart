import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unity/utils/routes/route_name.dart';
import 'package:unity/view_model/home_view_model/home_view_model.dart';

import '../../utils/app_helper/firebase_database/firestore/user_profile_firestore/users_profile_firestore.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
    providers: 
    [
      ChangeNotifierProvider(create: ((context) => HomeViewModel())),
    ],
    child: Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<HomeViewModel>(builder: (context, provider, child) {
            return InkWell(
              onTap: () {
                provider.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.loginView, (route) => false);
              },
              child: Icon(Icons.logout_outlined),
            );
          })
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: UsersProfileFireStore.getAllUser(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text("Error");
                    } else {
                      return ListView.builder(
                          itemExtent: 20,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            var mess = data["name"].toString();
                            var image = data["image"].toString();
                            return ListTile(
                                title: Text(mess),
                                leading: CachedNetworkImage(
                                  imageUrl: image,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ));
                          });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),);
  }
}
