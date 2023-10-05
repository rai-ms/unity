import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unity/model/firebase/user_profile_model.dart';
import 'package:unity/utils/app_helper/app_color.dart';
import 'package:unity/utils/routes/route_name.dart';
import 'package:unity/view/home_view/widgets/user_profile_dialog.dart';
import 'package:unity/view_model/home_view_model/home_view_model.dart';
import '../../services/unknown_page_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    UnknownPageService.checkAuthHomePage(context);
    SystemChannels.lifecycle.setMessageHandler((message) async
    {
      debugPrint(message);
      if(message.toString().contains("pause")) {
        HomeViewModel.setUserStatus(false);
      }
      else if(message.toString().contains('resume')){
        HomeViewModel.setUserStatus(true);
      }
      return Future.value(message);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double paddingBottom = MediaQuery.of(context).padding.bottom;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => HomeViewModel())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Consumer<HomeViewModel>(builder: (context, provider, child) {
                if(provider.appLoginUser == null){
                  return const SizedBox();
                }
                return Text("User is:${provider.appLoginUser!.name.toString()}");
              }),
            ],
          ),
          actions: [
            Consumer<HomeViewModel>(builder: (context, provider, child) {
              if(provider.appLoginUser == null){
                return const SizedBox();
              }
              return InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, RouteName.userProfileView, arguments: {'user':provider.appLoginUser});
                  },
                  child: const Icon(Icons.menu));
            }),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: paddingBottom),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Consumer<HomeViewModel>(
                      builder: (context, provider, child) {
                    return StreamBuilder<List<UserProfileModel>>(
                      stream: provider.getAllUser(),
                      builder: (context,
                          AsyncSnapshot<List<UserProfileModel>> snapshot) {
                        List<UserProfileModel>? users = snapshot.data;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Text("Error");
                        } else {
                          return ListView.builder(
                              itemCount: users!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Consumer<HomeViewModel>(
                                      builder: (context, provider, child) {
                                        if(users[index].uid == provider.appLoginUser!.uid){
                                          return const SizedBox();
                                        }
                                    return ListTile(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, RouteName.chatView,
                                            arguments: {"user": users[index]});
                                      },
                                      title: Text(users[index].name),
                                      // trailing: Text(provider.countMessage.toString()),
                                      leading: InkWell(
                                        onTap: (){
                                          showDialog(context: context, builder: (context)=> Dialog(child: UserProfileDialog(user: users[index],)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors
                                                  .blueSplashScreen, // Set your desired border color here
                                              width: 2.0, // Set the border width
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: users[index].image,
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              });
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
