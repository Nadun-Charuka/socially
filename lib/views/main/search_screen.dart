import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/models/user_model.dart';
import 'package:socially/services/user/user_services.dart';
import 'package:socially/utils/constants/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];

  Future<void> _fetchAllUser() async {
    try {
      List<UserModel> users = await UserService().getAllUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
      });
    } catch (e) {
      debugPrint("error in fethcin users: $e");
    }
  }

  //serach users
  void _seacrchUser(String query) {
    setState(
      () {
        _filteredUsers = _users
            .where(
              (user) => user.name.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                  ),
                  hintText: "Search user",
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: mainOrangeColor),
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  //todo search user
                  _seacrchUser(_searchController.text.trim());
                },
              ),
              _filteredUsers.isNotEmpty
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: ClipOval(
                              child: CachedNetworkImage(
                                width: 40,
                                height: 40,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.person),
                                imageUrl: user.photoUrl,
                              ),
                            ),
                            title: Text(user.name),
                            onTap: () {
                              GoRouter.of(context).push(
                                "/single-user-screen",
                                extra: user,
                              );
                            },
                          ),
                        );
                      },
                    )
                  : Text("No users")
            ],
          ),
        ),
      ),
    );
  }
}
