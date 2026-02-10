  final List<String> locations = ['Kottayam', 'Ernakulam', 'Kozhikode'];
  final List<String> paymentOptions = ['Cash', 'Card', 'UPI'];

  
  final List<String> hours = List.generate(
    24,
    (i) => i.toString().padLeft(2, '0'),
  );
  final List<String> minutes = List.generate(
    60,
    (i) => i.toString().padLeft(2, '0'),
  );
