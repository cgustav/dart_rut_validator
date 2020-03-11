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

  TextEditingController _rutController = TextEditingController();

  final Color mainColor = Colors.deepPurple;
  final Color secondaryColor = Colors.teal.shade900;

  @override
  void initState() {
    //_rutController = TextEditingController(text: '');
    _rutController.clear();
    super.initState();
  }

  void onSubmitAction(BuildContext context) {
    bool result = _formKey.currentState.validate();
    if (result) Scaffold.of(context).showSnackBar(snack);
  }

  void onChangedApplyFormat(String text) {
    RUTValidator.formatFromTextController(_rutController);
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

            //-----------------------------
            //INPUT TEXT FIELD

            TextFormField(
              maxLines: 1,
              onChanged: onChangedApplyFormat,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: 'Ingrese RUT',
                hintStyle: TextStyle(
                    color: secondaryColor.withOpacity(0.6),
                    letterSpacing: 0.6,
                    fontFeatures: [FontFeature.tabularFigures()]),
                icon: Icon(
                  Icons.person,
                  size: 40,
                  color: mainColor.withOpacity(0.6),
                ),
              ),
              controller: _rutController,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.deepPurple[800].withOpacity(0.9),
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.7),
              validator:
                  RUTValidator(validationErrorText: 'RUT no válido').validator,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
                ///Permitir solo numeros y la letra K en el textFormField
                WhitelistingTextInputFormatter(RegExp(r'[0-9kK]')),
              ],
            ),

            Divider(
              height: 60,
            ),

            //-----------------------------
            //SUBMIT BUTTON

            Container(
              height: 45,
              width: 180,
              child: OutlineButton(
                onPressed: () {
                  onSubmitAction(context);
                },
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
            ),
          ],
        ),
      ),
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
