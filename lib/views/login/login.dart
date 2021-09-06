import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unilabs_app/common_widgets/custom_button_icon.dart';
import 'package:unilabs_app/constants.dart';
import 'package:unilabs_app/views/login/bloc/login_bloc.dart';
import 'package:unilabs_app/views/login/bloc/login_event.dart';

import 'bloc/login_state.dart';

class LoginPage extends StatelessWidget {
  final _StyleSheet stylesheet = _StyleSheet();
  final FocusNode focusEmail = new FocusNode();
  final FocusNode focusPassword = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  final auth = {"email": "", "password": ""};

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.4), BlendMode.dstATop),
          image: AssetImage("assets/images/login.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  logoText(),
                  SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          emailInput(context),
                          passwordInput(context, loginBloc),
                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                                previous.loginFailed != current.loginFailed,
                            builder: (context, state) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                                height: state.loginFailed ? 20 : 0,
                                child: Text(
                                  'Email or Password is Incorrect.',
                                  style: stylesheet._errorText,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                                previous.loading != current.loading,
                            builder: (context, state) {
                              return AnimatedCrossFade(
                                duration: Duration(milliseconds: 500),
                                firstCurve: Curves.ease,
                                secondCurve: Curves.ease,
                                firstChild: CustomIconButton(
                                  text: 'Log In',
                                  onTap: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      // loginBloc.add(SubmitEvent(auth));
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/home',
                                      );
                                    }
                                  },
                                ),
                                secondChild: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                crossFadeState: state.loading
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                              );
                            },
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailInput(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 6),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Constants.kPrimary, width: 1.5),
          color: Colors.white),
      child: TextFormField(
        maxLines: 1,
        focusNode: focusEmail,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          isDense: true,
          icon: Padding(
            padding: EdgeInsets.only(bottom: 2),
            child: Icon(FontAwesomeIcons.solidEnvelope),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          border: InputBorder.none,
          hintText: "Email",
          hintStyle: stylesheet._hintText,
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => auth['email'] = value.trim(),
        onFieldSubmitted: (value) {
          focusEmail.unfocus();
          FocusScope.of(context).requestFocus(focusPassword);
        },
      ),
    );
  }

  Widget passwordInput(BuildContext context, LoginBloc bloc) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(top: 12, bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Constants.kPrimary, width: 1.5),
              color: Colors.white),
          child: TextFormField(
            maxLines: 1,
            focusNode: focusPassword,
            textInputAction: TextInputAction.done,
            obscureText: !state.showPass,
            decoration: InputDecoration(
              isDense: true,
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(FontAwesomeIcons.lock),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              hintText: "Password",
              hintStyle: stylesheet._hintText,
              suffixIcon: GestureDetector(
                onTap: () => bloc.add(TogglePasswordVisiblityEvent()),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 2, right: 4),
                  child: Icon(
                    state.showPass
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                  ),
                ),
              ),
              suffixIconConstraints:
                  BoxConstraints(maxHeight: 24, maxWidth: 24),
            ),
            validator: (value) =>
                value.isEmpty ? 'Password can\'t be empty' : null,
            onSaved: (value) => auth['password'] = value.trim(),
            onFieldSubmitted: (value) {
              focusEmail.unfocus();
            },
          ),
        );
      },
    );
  }

  Widget logoText() {
    return Column(
      children: [
        Hero(
          tag: 'logo',
          child: Container(
            margin: EdgeInsets.only(top: 50, bottom: 5),
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              boxShadow: [
                BoxShadow(
                  color: Constants.kPrimary.withOpacity(0.20),
                  blurRadius: 20,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Image.asset("assets/images/logo.png"),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'UniLabs',
          style: stylesheet._titleText,
        ),
      ],
    );
  }
}

class _StyleSheet {
  final TextStyle _hintText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Constants.kHintText,
  );
  final TextStyle _errorText = GoogleFonts.fredokaOne(
    textStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: Colors.red,
    ),
  );
  final TextStyle _titleText = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 2.5,
  );
}
