# dart_rut_validator

Librería acotada (conjunto de herramientas) de flutter para la manipulación, formato y validación de Rol Único Tributario, o **RUT** chileno.

El método de validación es el [algoritmo oficial](https://www.registrocivil.cl/PortalOI/Manuales/Validacion_de_Run.pdf) publicado por el registro civil de Chile.

## Utilidades

### Formato Automático

### Formato Manual
![Imgur](https://i.imgur.com/E5jRkyR.mp4)

### Validación 

> **Nota1**: Esta librería valida la estructura y formato del RUT de entrada pero no si este pertenece a una persona natural o empresa. Para esto es necesario contar con una API complementaria.

> **Nota2**: El validador toma en cuenta el dígito verificador _K_ y _0_ como iguales, (por ejemplo _10.841.332-K_ es igual a _10.841.332-0_). 

> **Nota 3**: El validador tomará como no válidos números de RUT inferiores a _900.000_, por ejemplo el RUT _0.891.345-2_ será tomado como no válido, mientras que _0.901.245-7_ será tomado en cuenta.

## Ejemplos de implementación