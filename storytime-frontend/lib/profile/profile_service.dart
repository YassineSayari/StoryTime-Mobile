import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../User.dart';
import '../databasehelper.dart';

class ProfileService {
  final DatabaseHelper _databaseHelper;
  final ImagePicker _imagePicker = ImagePicker();

  ProfileService(this._databaseHelper);

  Future<User?> getUserData(String email) async {
    try {
      return await _databaseHelper.getUserByEmail(email);
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
  }

  Future<void> saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_image', imagePath);
  }

  Future<void> loadImagePath(Function(String) onImagePathLoaded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imagePath = prefs.getString('user_image') ?? 'assets/images/backgroundlogin.jpg';
    onImagePathLoaded(imagePath);
  }

  Future<void> pickImage(Function(String) onImagePicked) async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      saveImagePath(pickedFile.path);
      onImagePicked(pickedFile.path);
    }
  }

  Future<bool> verifyAndUpdateProfile(User user, String oldPassword, String newPassword, String confirmPassword) async {
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      throw Exception("All fields must be filled.");
    }

    if (oldPassword != user.password) {
      throw Exception("Old password is incorrect.");
    }

    if (newPassword != confirmPassword) {
      throw Exception("New password and confirmation do not match.");
    }

    User updatedUser = User(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: newPassword,
    );

    await _databaseHelper.updateUser(updatedUser);
    return true;
  }
}
