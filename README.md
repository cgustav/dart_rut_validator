# dart_rut_validator

Librería acotada (conjunto de herramientas) de flutter para la manipulación, formato y validación de Rol Único Tributario, o **RUT** chileno.

El método de validación es el [algoritmo oficial](https://www.registrocivil.cl/PortalOI/Manuales/Validacion_de_Run.pdf) publicado por el registro civil de Chile.

## Utilidades

### Formato Automático
![](https://media.giphy.com/media/Xf8OXRGsAmrAjwcBuN/giphy.gif)

### Formato Manual
![](https://media.giphy.com/media/fXuDNHRPjsohhUNKff/giphy.gif)

### Validación 
![](https://media.giphy.com/media/TIMEDXwoJ99HERBMWR/giphy.gif)


## Ejemplos de implementación

### *Formato automático

Para aplicar formato automático es necesario hacer uso de la clase de flutter ´TextEditingController´ para manejar los cambios del texto del campo RUT cada vez que el usuario ingrese una nueva letra o número.

```dart 
import 'package:dart_rut_validator/dart_rut_validator'

TextEditingController _rutController = TextEditingController();

@override
void initState(){
  _rutController.clear();
  super.initState();
}

//Método para aplicar formato de manera 
//automática: 
void onChangedApplyFormat(String text){
    RUTValidator.formatFromTextController(_rutController);
}

@override
Widget build(BuildContext context){
  return Scaffold(
  //... Código de tu app

	 //Es importante especificar:
	 //   *El controlador del texto que
	 //    en este caso es _rutController.
	 //    De esta manera se aplicará el 
	 //    formato cada vez que el usuario
	 //   ingrese un nuevo número o letra.
	 //
 	 //   *El método onChanged con la 
	 //    función `formatFromTextController`
	 //    de rut_validator en su interior.
	 TexFormField(
	   controller:_rutController,
	   onChanged: onChangedApplyFormat
	 )
  );
}

```

### Formato manual

Si lo que deseas es permitir ingresar cualquier número y letra para luego aplicar el formato de RUT mediante una acción específica/personalizada:

```dart
import 'package:dart_rut_validator/dart_rut_validator'

String _rutText = '157379704';

_rutText = RUTValidator.formatFromText(_rutText);

print(_rutText); //15.737.970-4

```

La siguiente implementación aplica el formato sólo cuando acciona el boton de envío del formulario:

```dart 
import 'package:dart_rut_validator/dart_rut_validator'

TextEditingController _rutController = TextEditingController();

@override
void initState(){
  //...
  _rutController.clear();
  super.initState();
}

//Método para aplicar formato de manera 
//automática: 
//void onSubmit(){
RUTValidator.formatFromText(_rutController.text);
}

@override
Widget build(BuildContext context){
  return Scaffold(
  //... Código de tu app
  
	 //Es importante especificar
	 //el controlador del texto que
	 //en este caso es _rutController.
	 //de esta manera se aplicará el 
	 //formato cada vez que el usuario
	 //ingrese un nuevo número o letra.
	 TexFormField(
	   controller:_rutController,
	   onChanged: onChangedApplyFormat
	 ),
	 
	 FlatButton(
	   onPressed: onSubmit
	   child: Text('Enviar')
	 )
	
  );
}

```
### Validación

Para aplicar validación dentro de un formulario
de flutter simplemente debes especificar el método
`RUTValidator().validator`en el parámetro `validator`
del widget `TextFormField` o relacionado como se muestra 
a continuación.

```dart
	 TexFormField(
	   controller: controller,
	   onChanged: onChanged,
     validator: RUTValidator().validator
	 ),
   
```

La validación se aplicará cuando se aplique 
la acción `validate` del formulario

```dart
  _formKey.currentState.validate()
```

Puedes personalizar el mensaje de error
para la validación:

```dart
	 TexFormField(
	   controller: controller,
	   onChanged: onChanged,
     validator: RUTValidator(validationErrorText: 'Ingrese RUT válido').validator
	 ),
```

## Notas 

> **Nota1**: El validador verifica la estructura y formato del RUT de entrada pero no si este pertenece a una persona natural o empresa. Para esto es necesario contar con una API complementaria.

> **Nota2**: El validador toma en cuenta el dígito verificador _K_ y _0_ como iguales, (por ejemplo _10.841.332-K_ es igual de válido que _10.841.332-0_).

> **Nota 3**: El validador tomará como no válidos números de RUT inferiores a _1.000.000_, por ejemplo el RUT _0.891.345-2_ será tomado como no válido, mientras que _1.001.245-7_ será tomado en cuenta.
