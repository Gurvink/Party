import 'dart:ui';

class ObservableList<T> {
  List<T> _list = [];
  VoidCallback? onAdd;
  void Function(T)? onRemove;

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
      onRemove!(item);
    }
  }

  Iterable<T> where(bool Function(T) action){
    return _list.where(action);
  }

  T firstWhere(bool Function(T) action){
    return _list.firstWhere(action);
  }

  void ClearListeners(){
    onAdd = null;
    onRemove = null;
  }
}