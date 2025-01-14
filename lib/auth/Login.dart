import 'package:flutter/material.dart';
import 'package:network_app/Utilities/custom_loader.dart';
import 'package:network_app/Utilities/utilities.dart';
import 'package:network_app/auth/viewModel/login_view_model.dart';
import 'package:network_app/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../network/NetworkResponse.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formState = GlobalKey<FormState>();
  bool isLoading = false;
  late LoginViewModel viewModel;
  String email = "";
  String password = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<LoginViewModel>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {

    return
        Consumer<LoginViewModel>(
          builder: (context, viewModel, child){
            if(viewModel.networkResponse.status == Status.COMPLETED) {
              Future.microtask(() => navigate(context, const HomeScreen()));
            }

            return SafeArea(
                child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (viewModel.networkResponse.status == Status.LOADING) ...[
                              const CustomLoader()
                            ]  else ...[
                              Center(
                                child: Form(
                                    key: formState,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text("Login",
                                              style: TextStyle(
                                                  fontSize: 26, fontWeight: FontWeight.bold)),
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Enter email',
                                              hintText: 'Enter email',
                                              border: OutlineInputBorder()),
                                          keyboardType: TextInputType.emailAddress,
                                          onChanged: (String text) {
                                            setState(() {
                                              email = text;
                                            });
                                          },
                                          validator: (String? text) {
                                            if (text == null || text.isEmpty) {
                                              return 'Email is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 15),
                                        TextFormField(
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Password',
                                            hintText: 'Enter Password',
                                          ),
                                          onChanged: (String text) {
                                            setState(() {
                                              password = text;
                                            });
                                          },
                                          validator: (String? text) {
                                            if (text == null || text.isEmpty) {
                                              return 'enter password';
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.text,
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                            width: double.infinity,
                                            child: FilledButton(
                                                onPressed: () {
                                                  if (formState.currentState!.validate()) {
                                                    viewModel.login(email, password);
                                                  }
                                                },
                                                child: const Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                )))
                                      ],
                                    )),
                              )
                            ]
                          ],
                        ),
                      ),
                    )
                )
            );
          },
        );
  }
}
