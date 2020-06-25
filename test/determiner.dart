import 'package:dart_rut_validator/dart_rut_validator.dart';

class Determiner {
  final ruts = <String>[
    '6111326-6',
    '7051242-4',
    '13877030-3',
    '20845245-2',
    '10912709-4',
    '23392490-3',
    '13721854-2',
    '15210292-5',
    '16048144-7',
    '10632183-3',
    '19515411-2',
    '8012397-3',
    '10367572-3',
    '23753587-1',
    '13416001-2',
    '12743156-6',
    '5035231-5',
    '21407251-3',
    '23781610-2',
    '22870087-8',
    '15714156-2',
    '16954665-7',
    '21683919-6',
    '17317924-3',
    '14318655-5',
    '11425368-5',
    '16318127-4',
    '23937312-7',
    '11804584-k',
    '14413662-4',
    '24000780-0',
    '11077797-3',
    '12124080-7',
    '16027843-9',
    '15157438-6',
    '19747507-2',
    '7233901-0',
    '12765164-7',
    '24966599-1',
    '18958285-4',
    '21936795-3',
    '16093120-5',
    '19124646-2',
    '6535173-0',
    '21720883-1',
    '14230878-9',
    '11291251-7',
    '16549832-1',
    '6193766-8',
    '11935393-9',
    '20804245-9',
    '22400110-k',
    '13688170-1',
    '21990224-7',
    '11360488-3',
    '6293007-1',
    '6326068-1',
    '15558590-0',
    '20756572-5',
    '18113546-8',
    '13193944-2',
    '24494639-9',
    '7456564-6',
    '24963403-4',
    '10693077-5',
    '15915089-5',
    '8032245-3',
    '8980612-7',
    '11625345-3',
    '12832646-4',
    '5694569-5',
    '20788733-1',
    '7149081-5',
    '17985364-7',
    '8623008-9',
    '11654207-2',
    '18650512-3',
    '16607503-3',
  ];

  int getSuccessValidations() {
    return this.ruts.length - this.getFailedValidations();
  }

  int getFailedValidations() {
    return this.getFailedMessages().where((result) => result == 'BAD').length;
  }

  Iterable<String> getFailedMessages() {
    List<String> failedMessages = [];
    ruts.forEach((rut) {
      String result = RUTValidator(validationErrorText: 'BAD').validator(rut);
      if (result != null) failedMessages.add(result);
    });
    return failedMessages;
  }

  List<String> getFailedValues() {
    List<String> failedMessages = [];
    ruts.forEach((rut) {
      String result = RUTValidator(validationErrorText: 'BAD').validator(rut);
      if (result != null) failedMessages.add(rut);
    });
    return failedMessages;
  }
}
