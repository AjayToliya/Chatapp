import 'package:chatterbox/utils/Auth_Hepler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Drawers extends StatefulWidget {
  final User user;
  Drawers({required this.user});

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  final GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? name;
  String? password;

  @override
  void initState() {
    super.initState();
    name = (widget.user.displayName == null) ? null : widget.user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: (widget.user.isAnonymous)
                      ? null
                      : (widget.user.photoURL == null)
                          ? null
                          : NetworkImage(widget.user.photoURL!),
                ),
                SizedBox(height: 12),
                Text(
                  name ?? "Guest User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                (!widget.user.isAnonymous)
                    ? Text(
                        widget.user.email!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      )
                    : Text(
                        'user.email@example.com',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Name'),
            onTap: () {
              showEditNameDialog();
            },
          ),
          if (!widget.user.isAnonymous)
            ListTile(
              leading: Icon(Icons.password),
              title: Text('Change Password'),
              onTap: () {
                _showChangePasswordDialog();
              },
            ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await Auth_Helper.auth_helper.SignOutUser();
              Navigator.of(context).pushNamedAndRemoveUntil(
                'Login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void showEditNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Name"),
          content: Form(
            key: nameKey,
            child: TextFormField(
              controller: nameController,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Please enter a name.";
                }
                return null;
              },
              onSaved: (val) {
                name = val;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameController.clear();
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameKey.currentState!.validate()) {
                  nameKey.currentState!.save();
                  User? updatedUser =
                      await Auth_Helper.auth_helper.updateUsername(name!);
                  if (updatedUser != null) {
                    setState(() {
                      name = updatedUser.displayName;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Name updated successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to update name."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change Password"),
          content: Form(
            key: passwordKey,
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Please enter a new password.";
                }
                return null;
              },
              onSaved: (val) {
                password = val;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "New Password",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                passwordController.clear();
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (passwordKey.currentState!.validate()) {
                  passwordKey.currentState!.save();
                  bool isUpdated =
                      await Auth_Helper.auth_helper.updatePassword(password!);
                  if (isUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Password updated successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to update password."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
