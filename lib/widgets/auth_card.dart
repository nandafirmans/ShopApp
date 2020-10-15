import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/auth_mode.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/utilities/dialogs.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _animationController;
  Animation<Offset> _animationOffset;
  Animation<double> _animationOpacity;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animationOffset = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _animationOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() => _isLoading = true);
    try {
      if (_authMode == AuthMode.Login) {
        await context.read<Auth>().signIn(
              email: _authData['email'],
              password: _authData['password'],
            );
      } else {
        await context.read<Auth>().signUp(
              email: _authData['email'],
              password: _authData['password'],
            );
      }
    } on HttpException catch (error) {
      Dialogs.showAlertDialog(
        context: context,
        message: error.message,
      );
    } catch (error) {
      Dialogs.showAlertDialog(
        context: context,
        message: 'unknown error occured',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() => _authMode = AuthMode.Signup);
      _animationController.forward();
    } else {
      setState(() => _authMode = AuthMode.Login);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final double containerHeight = _authMode == AuthMode.Signup ? 300 : 250;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        height: containerHeight,
        constraints: BoxConstraints(
          minHeight: containerHeight,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value.isEmpty || !value.contains('@')
                      ? 'Invalid email!'
                      : null,
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) => value != _passwordController.text
                      ? 'Passwords do not match!'
                      : null,
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                const SizedBox(height: 12),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  constraints: BoxConstraints(
                    maxHeight: _authMode == AuthMode.Signup ? 60 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _animationOpacity,
                    child: SlideTransition(
                      position: _animationOffset,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) => value != _passwordController.text
                                ? 'Passwords do not match!'
                                : null
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FlatButton(
                      child: Text(
                          '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                      onPressed: _switchAuthMode,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textColor: Theme.of(context).primaryColor,
                    ),
                    if (_isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: CircularProgressIndicator(),
                      )
                    else
                      RaisedButton(
                        child: Text(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                        onPressed: _submit,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 15,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============= Animate Using AnimatedBuilder =============
// class _AuthCardState extends State<AuthCard>
//     with SingleTickerProviderStateMixin {
//   AuthMode _authMode = AuthMode.Login;
//   AnimationController _animationHeightController;
//   Animation<Size> _animationHeight;
//
//   @override
//   void initState() {
//     _animationHeightController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );
//     _animationHeight = Tween<Size>(
//       begin: Size(double.infinity, 260),
//       end: Size(double.infinity, 320),
//     ).animate(
//       CurvedAnimation(
//         parent: _animationHeightController,
//         curve: Curves.fastOutSlowIn,
//       ),
//     );
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _animationHeightController.dispose();
//     super.dispose();
//   }
//
//   void _switchAuthMode() {
//     if (_authMode == AuthMode.Login) {
//       setState(() => _authMode = AuthMode.Signup);
//       _animationHeightController.forward();
//     } else {
//       setState(() => _authMode = AuthMode.Login);
//       _animationHeightController.reverse();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 8.0,
//       child: AnimatedBuilder(
//         animation: _animationHeight,
//         builder: (context, child) => Container(
//           height: _animationHeight.value.height,
//           constraints: BoxConstraints(
//             minHeight: _animationHeight.value.height,
//           ),
//           width: deviceSize.width * 0.75,
//           padding: const EdgeInsets.all(16.0),
//         ),
//       ),
//     );
//   }
// }
