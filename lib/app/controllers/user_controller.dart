import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:olshop/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var isAuth = false.obs;
  var userId = "".obs;
  var name = "".obs;
  var photoUrl = "".obs;
  var email = "".obs;
  var loading = false.obs;

  @override
  void onInit() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("uid")) {
      name.value = await prefs.getString("name") ?? "";
      photoUrl.value = await prefs.getString("photoUrl") ?? "";
      userId.value = await prefs.getString("uid") ?? "";
    }

    super.onInit();
  }

  void signInWithGoogle() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      loading.value = true;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential response =
          await FirebaseAuth.instance.signInWithCredential(credential);

      isAuth.value = true;
      response.user!.uid;
      name.value = response.user!.displayName ?? "";
      photoUrl.value = response.user!.photoURL ?? "";
      email.value = response.user!.email ?? "";

      await prefs.setString("uid", response.user!.uid);
      await prefs.setString("name", response.user!.displayName ?? "");
      await prefs.setString("photoUrl", response.user!.photoURL ?? "");
      await prefs.setString("email", response.user!.email ?? "");
      loading.value = false;
      Get.offAllNamed(Routes.HOME);
    } catch (error) {
      loading.value = false;
      print(error);
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();

    FirebaseAuth auth = FirebaseAuth.instance;
    await GoogleSignIn().disconnect();
    await auth.signOut();

    await prefs.remove("uid");
    await prefs.clear();

    Get.offAllNamed(Routes.LOGIN);
  }
}
