import 'dart:async';
import 'dart:html';
import 'dart:math' as math;

import 'src/PhysicalMemory.dart';
import 'src/Process.dart';
import 'src/ProcessMgr.dart';
import 'src/VirtualMemory.dart';

void main() {
  VirtualMemory(20, 4096);
  VirtualMemory.toHtml();
  PhysicalMemory(18, 4096);
  PhysicalMemory.toHtml();
  var processes = ProcessMgr(30);
  processes.toHtml();
}