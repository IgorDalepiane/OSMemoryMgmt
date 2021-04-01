import 'dart:async';
import 'dart:html';
import 'dart:math' as math;

import 'src/PhysicalMemory.dart';
import 'src/VirtualMemory.dart';

void main() {
  var virtualMemory = VirtualMemory(20, 4096);
  virtualMemory.toHtml();
  var physicalMemory = PhysicalMemory(18, 4096);
  physicalMemory.toHtml();
}
