import 'dart:math' as math;

class Process {
  int id;
  int size;
  int duration;
  String color =
      'rgb(${math.Random().nextInt(255)}, ${math.Random().nextInt(255)}, ${math.Random().nextInt(255)})';

  Process(int size, int id) {
    this.size = size;
    this.id = id;
  }

  int getId() {
    return id;
  }

  void setId(int id) {
    this.id = id;
  }

  int getSize() {
    return size;
  }

  String getColor() {
    return color;
  }
}
