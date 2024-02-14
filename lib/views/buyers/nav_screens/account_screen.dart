import 'package:flutter/material.dart';
import '../../../controllers/auth_controller.dart';
import '../auth/login_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthController _authController = AuthController();
  UserDetails? _userDetails;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _editingFullName = false;
  bool _editingPhoneNumber = false;
  bool _editingAddress = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      UserDetails? userDetails = await _authController.fetchUserDetails();

      setState(() {
        _userDetails = userDetails;
        _fullNameController.text = userDetails?.fullName ?? '';
        _phoneNumberController.text = userDetails?.phoneNumber ?? '';
        _addressController.text = userDetails?.address ?? '';
      });
    } catch (e) {
      // Handle errors
      print('Error loading user data: $e');
    }
  }

  Future<void> _logout() async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Logout',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmLogout != null && confirmLogout) {
      try {
        await _authController.logOutAndDeleteData();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Handle errors
        print('Error logging out: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateDetails() async {
    try {
      await _authController.updateUserDetails(
        fullName: _fullNameController.text,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Details updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Handle errors
      print('Error updating user details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating details'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showConfirmationDialog(VoidCallback callback) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Update',
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to update your details?',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Update',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                callback();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _userDetails != null
            ? ListView(
          children: [
            ListTile(
              title: Text(
                'Email',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                _userDetails!.email,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ListTile(
              title: Text(
                'User ID',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                _userDetails!.buyerId,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            _buildEditableField(
              label: 'Full Name',
              controller: _fullNameController,
              isEditing: _editingFullName,
              toggleEdit: (value) async {
                if (value) {
                  await _showConfirmationDialog(() {
                    setState(() {
                      _editingFullName = true;
                    });
                  });
                } else {
                  setState(() {
                    _editingFullName = false;
                  });
                  _updateDetails();
                }
              },
              oldValue: _userDetails?.fullName ?? '',
            ),
            _buildEditableField(
              label: 'Phone Number',
              controller: _phoneNumberController,
              isEditing: _editingPhoneNumber,
              toggleEdit: (value) async {
                if (value) {
                  await _showConfirmationDialog(() {
                    setState(() {
                      _editingPhoneNumber = true;
                    });
                  });
                } else {
                  setState(() {
                    _editingPhoneNumber = false;
                  });
                  _updateDetails();
                }
              },
              oldValue: _userDetails?.phoneNumber ?? '',
            ),
            _buildEditableField(
              label: 'Address',
              controller: _addressController,
              isEditing: _editingAddress,
              toggleEdit: (value) async {
                if (value) {
                  await _showConfirmationDialog(() {
                    setState(() {
                      _editingAddress = true;
                    });
                  });
                } else {
                  setState(() {
                    _editingAddress = false;
                  });
                  _updateDetails();
                }
              },
              oldValue: _userDetails?.address ?? '',
            ),
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required void Function(bool) toggleEdit,
    required String oldValue,
  }) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      subtitle: TextFormField(
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          hintText: oldValue,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      trailing: IconButton(
        icon: isEditing
            ? Icon(Icons.check, color: Colors.green)
            : Icon(Icons.edit, color: Colors.blue),
        onPressed: () async {
          if (isEditing) {
            await _showConfirmationDialog(() {
              toggleEdit(!isEditing);
              _updateDetails();
            });
          } else {
            toggleEdit(!isEditing);
          }
        },
      ),
    );
  }
}