import 'package:flutter/foundation.dart';
import 'package:metronomy/screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoginMode = true;
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';

  var _isAuthenticating = false;
  bool _passwordObscureText = true;

  ValueNotifier userCredential = ValueNotifier('');

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLoginMode) {
        // log in user
        // ignore: unused_local_variable
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        // sign up user
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'latency':0,
          'authentication-method': 'email-and-password'
        });
      }

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential

    final userCredentials =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final alreadyKnownUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentials.user!.uid)
        .get();

    if (alreadyKnownUser.data() == null) {
      // user unknow, we must create a new one
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': userCredentials.user?.displayName,
        'email': userCredentials.user?.email,
        'authentication-method': 'google',
        'language': 'fr',
        'latency':'0',
        'theme': 'dark'
      });
    } else {
      // user already known, we don't need to update data to firestore database.
    }

    return userCredentials;
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: Text(
            AppLocalizations.of(context)!.applicationTitle,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/MotifsNoirs.png"),
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.background.withOpacity(0.1),
                    BlendMode.dstATop),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  Card(
                      color: Colors.grey,
                      margin: const EdgeInsets.all(30),
                      child: SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 20,
                                            left: 20,
                                            right: 20,
                                          ),
                                          width: 100,
                                          child: Icon(
                                            Icons.lock,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            size: 30,
                                          ),
                                        ),
                                        /*if (!_isLoginMode) UserImagePicker(onPickedImage: (pickedImage){
                            _selectedImage = pickedImage;
                          },),*/
                                        if (!_isLoginMode)
                                          TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Username',
                                              hintStyle:
                                                  const TextStyle(fontSize: 12),
                                              floatingLabelStyle:
                                                  const TextStyle(fontSize: 12),
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              errorStyle:
                                                  const TextStyle(fontSize: 12),
                                              helperStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            autocorrect: false,
                                            textCapitalization:
                                                TextCapitalization.none,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty ||
                                                  value.trim().length < 4) {
                                                return 'Please enter a username at least 4 characters.';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _enteredUsername = value!;
                                            },
                                          ),
                                        TextFormField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.red
                                                  //Theme.of(context).colorScheme.secondary,
                                                  ),
                                          decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .emailAddress,
                                            hintStyle:
                                                const TextStyle(fontSize: 12),
                                            floatingLabelStyle:
                                                const TextStyle(fontSize: 12),
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            errorStyle:
                                                const TextStyle(fontSize: 12),
                                            helperStyle:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          autocorrect: false,
                                          textCapitalization:
                                              TextCapitalization.none,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty ||
                                                !value.contains('@')) {
                                              return AppLocalizations.of(
                                                      context)!
                                                  .pleaseEnterAValideEmailAddress;
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _enteredEmail = value!;
                                          },
                                        ),
                                        TextFormField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                          decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .password,
                                            hintStyle:
                                                const TextStyle(fontSize: 12),
                                            floatingLabelStyle:
                                                const TextStyle(fontSize: 12),
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            errorStyle:
                                                const TextStyle(fontSize: 12),
                                            helperStyle:
                                                const TextStyle(fontSize: 12),
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _passwordObscureText =
                                                      !_passwordObscureText;
                                                });
                                              },
                                              child: Icon(
                                                _passwordObscureText
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                              ),
                                            ),
                                          ),
                                          obscureText: _passwordObscureText,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().length < 6) {
                                              return 'Password must be at least 6 characters long.';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _enteredPassword = value!;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        if (_isAuthenticating)
                                          const CircularProgressIndicator(),
                                        if (!_isAuthenticating)
                                          ElevatedButton(
                                            onPressed: _submit,
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer),
                                            child: Text(
                                              _isLoginMode
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .signIn
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .signUp,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                            ),
                                          ),
                                        if (!_isAuthenticating)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _isLoginMode
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .needAnAccount
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .alreadHaveAnAccount,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                    ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isLoginMode =
                                                        !_isLoginMode;
                                                  });
                                                },
                                                child: Text(
                                                  _isLoginMode
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .signUp
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .signIn,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: 120,
                                                child: Divider(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  thickness: 1,
                                                )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!.or,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                                width: 120,
                                                child: Divider(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                  thickness: 1,
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    try {
                                                      userCredential.value =
                                                          await signInWithGoogle();

                                                      if (userCredential
                                                              .value !=
                                                          null) {
                                                        if (kDebugMode) {
                                                          print(userCredential
                                                              .value
                                                              .user!
                                                              .email);
                                                        }
                                                      }
                                                    } catch (error) {
                                                      if (kDebugMode) {
                                                        print(
                                                            "Network failure, go to offline mode : $error");
                                                      }
                                                    }

                                                    Navigator.pushReplacement(
                                                      // ignore: use_build_context_synchronously
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const HomeScreen()),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .shade100),
                                                  child: Row(children: [
                                                    SvgPicture.asset(
                                                        "assets/images/icons/android_neutral_rd_na.svg"),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .continueWithGoogle,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color: Colors
                                                                    .black))
                                                  ]))
                                            ])
                                      ])))))
                ])))));
  }
}
