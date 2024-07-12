import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

const userPoolId = String.fromEnvironment('USERPOOL_ID');
const clientId = String.fromEnvironment('CLIENT_ID');

final userPool = CognitoUserPool(userPoolId, clientId);

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.setToken});
  void Function(String token) setToken;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _username = '';
  var _password = '';
  CognitoUserSession? session;

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final cognitoUser = CognitoUser(_username, userPool);
      final authDetails =
          AuthenticationDetails(username: _username, password: _password);
      try {
        session = await cognitoUser.authenticateUser(authDetails);
        widget.setToken(session!.getAccessToken().getJwtToken()!);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("wiegaaterkoffiehalen.nl"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/boy-and-girl-holding-coffee.png"),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('E-mailadres'),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (val) => _username = val!,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Wachtwoord'),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (val) => _password = val!,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSignIn,
                      child: const Text('Submit'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
