import 'dart:ui';

import 'package:dart_rut_validator/dart_rut_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RUT Validator Example',
      theme: ThemeData(
          primarySwatch: Colors.blue, accentColor: Colors.amberAccent[700]),
      home: MyHomePage(title: 'RUT Validator Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //---------------------------------------
  // TEXT CONTROLLERS

  TextEditingController _rutController;

  @override
  void initState() {
    _rutController = TextEditingController(text: '');
    super.initState();
  }

  void onSubmitAction() {
    //_rutController.text = RUTValidator.formatFromText(_rutController.text);
    _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(shrinkWrap: true,
          //physics: NeverScrollableScrollPhysics(),
          children: [_buildForm()]),
    );
  }

  //--------------------------------------------
  //                   FORM

  ///Will build formulary which contains
  ///text inputs and submit button.
  Widget _buildForm() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      padding: EdgeInsets.symmetric(horizontal: 45),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
            ),

            //INPUT RUT
            _inputTextTemplate(
                controller: _rutController,
                hintText: 'Ingrese su RUT',
                onChanged: (String text) {
                  //print('TEXTING $text');
                  RUTValidator.formatFromTextController(_rutController);
                  //_rutController.text = text;
                },
                validator:
                    RUTValidator(validationErrorText: 'Not valid RUT').validate,
                maxLines: 1),

            Divider(
              height: 60,
            ),

            //SUBMIT BUTTON
            _buildSubmitButton(
                onPressed: onSubmitAction,
                mainColor: Colors.deepPurple,
                height: 45,
                width: 180),
          ],
        ),
      ),
    );
  }

  //--------------
  // SUBMIT BUTTON

  Widget _buildSubmitButton(
      {Function onPressed,
      Color mainColor = Colors.red,
      double height,
      double width}) {
    return Container(
      height: height,
      width: width,
      child: OutlineButton(
        onPressed: onPressed,
        color: mainColor,
        borderSide: BorderSide(color: mainColor, width: 2),
        child: Center(
          child: Text(
            'VALIDATE',
            style: TextStyle(
              fontSize: 18,
              color: mainColor,
              fontFamily: 'Roboto',
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  //--------------
  // INPUT TEXT

  Widget _inputTextTemplate(
      {TextEditingController controller,
      String hintText,
      int maxLines,
      Function(String) onChanged,
      String Function(String) validator}) {
    return TextFormField(
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              color: Colors.blue.withOpacity(0.6),
              letterSpacing: 0.6,
              fontFeatures: [FontFeature.tabularFigures()]),
          icon: Icon(
            Icons.person,
            size: 32,
          )),
      controller: controller,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.deepPurple[800].withOpacity(0.9),
          fontSize: 19,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.7),
      validator: validator,
      inputFormatters: [
        LengthLimitingTextInputFormatter(12),
      ],
    );
  }
}
