import 'package:flutter/material.dart';
import 'package:flutter_auction_app/view/screens/home_screen.dart';
import 'package:flutter_auction_app/view/screens/user_messanger.dart';
import 'package:flutter_auction_app/view/widgets/auth_appbar.dart';
import 'package:flutter_auction_app/view/widgets/auth_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/authentication_controller.dart';
import '../../model/constants.dart';
import '../../model/input_validation.dart';
import '../widgets/custom_inputfield.dart';

final isClientProvider = StateProvider<bool>((ref) => false);
final isManagerProvider = StateProvider<bool>((ref) => false);
final isCleanerProvider = StateProvider<bool>((ref) => false);
final isGuardProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String id = '/';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool islogged = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding:
              EdgeInsets.symmetric(horizontal: 22, vertical: size.height * 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///===========================> appbar
              AuthAppBar(size: size),

              ///=============================> inputfields
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Helper.spacer(size, 0.04),
                    //email field
                    CustomTextInputfield(
                      textController: _emailController,
                      hintText: "Enter your email",
                      prefixIcon: Icons.mail_outline,
                      isPrefixIcon: true,
                      keyBoardType: TextInputType.emailAddress,
                      screenName: "login",
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return FormValidator.emailValidator(value);
                      },
                    ),

                    Helper.spacer(size, 0.02),
                    //password field
                    CustomTextInputfield(
                      textController: _passwordController,
                      hintText: "Enter your password",
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      isPrefixIcon: true,
                      screenName: "login",
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        return "Invalid password";
                      },
                    ),
                    // Text( ?? ""),
                    Helper.spacer(size, 0.03),
                  ],
                ),
              ),

              ///=====================================> forgetbutton
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ///tracking of going to the forget screens
                  },
                  child: const Text(
                    'Forget Password?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff6A707C),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              ///=========================================> buttons
              AuthButton(
                buttonText: "Login",
                onTriger: () async {
                  FocusScope.of(context).unfocus();
                  if (FormValidator.validateAndSave(_formkey)) {
                    /// if the user is verified then go farther or show error..
                    ///
                    if (_emailController.text == "manager@gmail.com") {
                      //login in as manager
                      if (_passwordController.text == "1234") {
                        ref.read(isManagerProvider.notifier).state = true;
                        Navigator.pushReplacementNamed(context, HomeScreen.id);
                      }
                    } else if (_emailController.text == "nirob@gmail.com") {
                      // login as client
                      if (_passwordController.text == "1234") {
                        ref.read(isClientProvider.notifier).state = true;
                        Navigator.pushReplacementNamed(context, HomeScreen.id);
                      }
                    } else if (_emailController.text == "cleaner@gmail.com") {
                      // login as client
                      if (_passwordController.text == "1234") {
                        ref.read(isCleanerProvider.notifier).state = true;
                        Navigator.pushReplacementNamed(
                            context, MessengerUserScreen.id);
                      }
                    } else if (_emailController.text == "guard@gmail.com") {
                      // login as client
                      if (_passwordController.text == "1234") {
                        ref.read(isGuardProvider.notifier).state = true;
                        Navigator.pushReplacementNamed(
                            context, MessengerUserScreen.id);
                      }
                    }
                  }
                },
              ),
              Helper.spacer(size, 0.04),
              // AuthtextButton(
              //   msg: "Don't have an account?",
              //   buttonText: 'Register Now',
              //   onTriger: () {},
              // ),

              Align(
                alignment: Alignment.center,
                child: Column(
                  children: const [
                    Text(
                      "OR",
                      style: TextStyle(
                        color: KConstColors.secondaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Login with social media",
                      style: TextStyle(
                        color: KConstColors.greyColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              ///==============================>> signin with google.
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final isValid = await ref
                        .read(googleAuthProvider.notifier)
                        .signInWithGoogle();
                    if (isValid) {
                      // navigate to the homescreen
                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.width * 0.08),
                    child: CircleAvatar(
                      radius: size.width * 0.08,
                      backgroundColor: KConstColors.primaryColor,
                      child: Image.asset("assets/images/google.png"),
                    ),
                  ),
                ),
              ),
              Helper.spacer(size, 0.15),
            ],
          ),
        ),
      ),
    );
  }
}
