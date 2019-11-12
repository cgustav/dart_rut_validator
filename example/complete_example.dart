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
          primarySwatch: Colors.teal, //0xFF004D40
          accentColor: Colors.amberAccent[700]),
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

  final Color mainColor = Colors.deepPurple;
  final Color secondaryColor = Colors.teal.shade900;

  @override
  void initState() {
    _rutController = TextEditingController(text: '');
    super.initState();
  }

  void onSubmitAction(BuildContext context) {
    bool result = _formKey.currentState.validate();
    if (result) Scaffold.of(context).showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Builder(builder: (BuildContext context) {
          return ListView(children: [_buildForm(context)]);
        }));
  }

  //--------------------------------------------
  //                   FORM

  ///Will build formulary which contains
  ///text inputs and submit button.
  Widget _buildForm(BuildContext context) {
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
                hintText: 'Ingrese RUT',
                icon: Icon(
                  Icons.person,
                  size: 40,
                  color: mainColor.withOpacity(0.6),
                ),
                onChanged: (String text) {
                  //print('TEXTING $text');
                  RUTValidator.formatFromTextController(_rutController);
                  //_rutController.text = text;
                },
                validator:
                    RUTValidator(validationErrorText: 'RUT no válido').validate,
                maxLines: 1),

            Divider(
              height: 60,
            ),

            //SUBMIT BUTTON
            _buildSubmitButton(
                onPressed: () {
                  onSubmitAction(context);
                },
                mainColor: mainColor,
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
            // 'VALIDAR',
            'ENVIAR',
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
      Widget icon,
      Function(String) onChanged,
      String Function(String) validator}) {
    return TextFormField(
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              color: secondaryColor.withOpacity(0.6),
              letterSpacing: 0.6,
              fontFeatures: [FontFeature.tabularFigures()]),
          icon: icon),
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

  final SnackBar snack = SnackBar(
      elevation: 1,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0)
            .add(EdgeInsets.only(left: 10.0)),
        //margin: EdgeInsets.only(bottom: 8.0),
        child: Text(
          'Datos enviados con éxito :)',
          style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              wordSpacing: 0.7,
              fontStyle: FontStyle.italic),
        ),
      ));
}
