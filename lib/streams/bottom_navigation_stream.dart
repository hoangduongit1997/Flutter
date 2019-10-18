import 'dart:async';

enum NavBarItem { NEWFEET,SEND_REQUEST, LIST_REQUEST, NOTIFICATONS }

class BottomNavBarStream {
  StreamController<NavBarItem> _navBarController =
      StreamController<NavBarItem>.broadcast();

  NavBarItem defaultItem = NavBarItem.NEWFEET;

  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.NEWFEET);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.SEND_REQUEST);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.LIST_REQUEST);
        break;
      case 3:
        _navBarController.sink.add(NavBarItem.NOTIFICATONS);
        break;
    }
  }

  close() {
    _navBarController?.close();
  }
}
