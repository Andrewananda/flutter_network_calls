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
  bool passwordHidden = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<LoginViewModel>(context, listen: false);
  }

  Future<void> _showDialog(BuildContext context, String message) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Text("Error!", textAlign: TextAlign.center),
            ),
            content: Text(message, textAlign: TextAlign.center),
            actions: [
              TextButton(
                child: const Center(
                  child: Text('OK', textAlign: TextAlign.center),
                ),
                onPressed: () {
                 viewModel.clearErrorMessage();
                  Navigator.of(context).pop();
                  // Navigator.of(context).dispose();
                },
              )
            ],
          );
    }
    );
  }


  @override
  Widget build(BuildContext context) {

    return
        Consumer<LoginViewModel>(
          builder: (context, viewModel, child){
            if(viewModel.networkResponse.status == Status.COMPLETED) {
              Future.microtask(() => navigate(context, const HomeScreen()));
            }
            else if (viewModel.networkResponse.status == Status.ERROR) {
              Future.microtask(() => _showDialog(context, viewModel.networkResponse.message ?? "An error occurred"));
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
                                          obscureText: passwordHidden,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: 'Password',
                                            hintText: 'Enter Password',
                                            suffixIcon: InkWell(
                                              child: Icon(passwordHidden ? Icons.visibility_off_sharp : Icons.visibility),
                                              onTap: () {
                                                setState(() {
                                                  passwordHidden = !passwordHidden;
                                                });
                                              },
                                            )
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
