class PaymentInitData {
  PaymentInitData(
      {this.is3DsV2,
      required this.terminalKey,
      required this.paymentId,
      this.serverTransId,
      this.threeDsMethod,
      this.html});

  final bool? is3DsV2;
  final String terminalKey;
  final String paymentId;
  final String? serverTransId;
  final String? threeDsMethod;
  final String? html;

  PaymentInitData.fromJson(Map<String, dynamic> json)
      : is3DsV2 = json['is3DsVersion2'],
        terminalKey = json['TerminalKey'],
        paymentId = json['PaymentId'],
        serverTransId = json['serverTransId'],
        threeDsMethod = json['ThreeDSMethodURL'],
        html = json['HTML'];
}

// {
//     "is3DsVersion2": true,
//     "TerminalKey": "1692261610441",
//     "PaymentId": "3841111576",
//     "serverTransId": "ad0d3cb1-6c2c-40b4-acff-d8e82f6d75a0",
//     "ThreeDSMethodURL": "https://3ds-ds1.mirconnect.ru/ma"
// }