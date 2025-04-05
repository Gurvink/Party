import 'dart:ui';

class ObservableList<T> {
  List<T> _list = [];
  VoidCallback? onAdd;
  VoidCallback? onRemove;

  List<T> get list => _list;
  get length => _list.length;
  T operator [](int index) => _list[index];
  void operator []=(int index, T value) {
    _list[index] = value;
  }

  void forEach(void Function(T) action){
    _list.forEach(action);
  }

  void add(T item){
    _list.add(item);
    if(onAdd != null){
      onAdd!();
    }
  }

  void remove(T item){
    _list.remove(item);
    if(onRemove != null){
      onRemove!();
    }
  }

  void ClearListeners(){
    onAdd = null;
    onRemove = null;
  }
}