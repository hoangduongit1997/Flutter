import 'dart:async';

class NumberStream {
  StreamController<int> number = new StreamController.broadcast();
  Stream get numberStream => number.stream;
  void pushNumber(int numbers) {
    number.sink.add(numbers);
  }

  void dispose() {
    number.close();
  }
}
