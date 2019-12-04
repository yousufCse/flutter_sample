import 'package:flutter/material.dart';
import '../blocs//bloc.dart';
import '../blocs/provider.dart';

class LoginScreen extends StatelessWidget {
  Widget build(context) {
    final bloc = Provider.of(context);

    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          emailField(bloc),
          passwordField(bloc),
          SizedBox(height: 20.0),
          submitButton(context),
        ],
      ),
    );
  }

  Widget emailField(bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'you@example.com',
            labelText: 'Email Address',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        print('render password strem build as per onChange');
        return TextField(
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              errorText: snapshot.error),
        );
      },
    );
  }

  Widget submitButton(context) {
    return RaisedButton(
      child: Text('Login'),
      color: Colors.blue,
      onPressed: () {
        // Navigate to second screen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ForgotPasswordScreen(),
        //   ),
        // );
      },
    );
  }
}
