class PaymentRowData {
  bool isSelected = false;
  final String payment_id;
  final String first_name;
  final String last_name;
  final String paymentAmount;
  final String paymentDate;
  final String customerID;
  final String instrFirstName;
  final String instrLastName;
  final String instrID;
  final String paymentType;
  final String lastUpdate;

  factory PaymentRowData.fromJson(Map<String, dynamic> json) {
    return PaymentRowData(
      json['payment_id'] as String,
      json['customer_name'] as String,
      json['customer_last_name'] as String,
      json['amount'] as String,
      json['payment_date'] as String,
      json['customer_id'] as String,
      json['staff_id'] as String,
      json['instr_name'] as String,
      json['instr_last_name'] as String,
      json['last_update'] as String,
      json['payment_type'] as String,
    );
  }

  PaymentRowData(
      this.payment_id,
      this.first_name,
      this.last_name,
      this.paymentAmount,
      this.paymentDate,
      this.customerID,
      this.instrID,
      this.instrFirstName,
      this.instrLastName,
      this.lastUpdate,
      this.paymentType);

  static PaymentRowData cleanPayment() {
    return PaymentRowData("", "", "", "", "", "", "", "", "", "", "");
  }

/*Widget buildListTile(PaymentRowData _data) {
    return Container(
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_data.payment_id),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_data.first_name),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_data.last_name),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_data.paymentAmount),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_data.paymentDate),
        ),
      ]),
    );
  }*/
}