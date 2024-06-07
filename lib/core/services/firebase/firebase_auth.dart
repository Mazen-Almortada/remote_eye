import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:remote_eye/features/login/models/user_model.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  sendRestPasswordLink(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<User?> updateUser(UserModel userModel, String newPassword) async {
    User user = _auth.currentUser!;

    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: userModel.password,
    );
    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);

    return user;
  }

  Future<UserCredential?> signUp(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
        .createUserWithEmailAndPassword(email: email, password: password);
    await app.delete();
    return Future.sync(() => userCredential);
  }

  Future<void> deleteUser(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
        .signInWithEmailAndPassword(email: email, password: password);
    await userCredential.user?.delete();
    await app.delete();
  }

  signOut() async {
    await _auth.signOut();
  }
}
