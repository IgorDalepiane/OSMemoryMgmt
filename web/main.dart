import 'dart:async';
import 'dart:html';
import 'dart:math' as math;

import 'src/Log.dart';
import 'src/PhysicalMemory.dart';
import 'src/Process.dart';
import 'src/ProcessMgr.dart';
import 'src/VirtualMemory.dart';

var stop = 0;
var lastCycle = 1;
void main() {
  VirtualMemory(20, 4096);
  VirtualMemory.toHtml();
  PhysicalMemory(18, 4096);
  PhysicalMemory.toHtml();
  ProcessMgr(10);
  ProcessMgr.toHtml();
  createButtons();
}

void createButtons() {
  var actions = querySelector('#actions');

  var simulateBtn = ButtonElement();
  simulateBtn.className = 'w-2/3 h-7 border-2 ml-0 bg-green-200';
  simulateBtn.text = 'Simulate';
  simulateBtn.id = 'simulateBtn';
  simulateBtn.onClick.listen((event) {
    if (simulateBtn.text == 'Stop') {
      simulateBtn.className = 'w-2/3 h-7 border-2 ml-0 bg-yellow-200';
      simulateBtn.text = 'Continue';
      stop = 1;
    } else if (simulateBtn.text == 'Ended') {
      Log.createLog(
          'w-full h-7 border-2 border-t-0 border-gray gap-1 bg-black text-white',
          'Simulation already done!');
    } else {
      stop = 0;
      simulateBtn.className = 'w-2/3 h-7 border-2 ml-0 bg-red-200';
      simulateBtn.text = 'Stop';
      simulate();
    }
  });
  actions!.append(simulateBtn);

  var createProcessBtn = ButtonElement();
  createProcessBtn.className = 'w-2/3 h-7 border-2 ml-0 bg-blue-300';
  createProcessBtn.text = 'Create process';
  createProcessBtn.id = 'createProcessBtn';
  createProcessBtn.onClick.listen((event) {
    var simulateBtn = querySelector('#simulateBtn');
    if (simulateBtn!.text == 'Ended') {
      simulateBtn!.className = 'w-2/3 h-7 border-2 ml-0 bg-yellow-200';
      simulateBtn!.text = 'Continue';
    }
    ProcessMgr.createProcess();
    Log.createLog(
        'w-full h-7 border-2 border-t-0 border-gray gap-1 bg-green-300 ',
        'Process created!');
  });
  actions!.append(createProcessBtn);
}

void simulate() {
  var count = lastCycle;
  Timer.periodic(Duration(milliseconds: 1000), (timer) {
    if (stop == 0) {
      if (count == ProcessMgr.processes.length) {
        var simulateBtn = querySelector('#simulateBtn');
        simulateBtn!.className = 'w-2/3 h-7 border-2 ml-0 bg-black text-white';
        simulateBtn!.text = 'Ended';
        timer.cancel();
      }
      print(count);
      var button = querySelector('#alockBtn$count');
      button!.click();

      var buttonRun = querySelector('#runBtn$count');
      buttonRun!.click();

      count++;
      lastCycle = count;
    } else {
      timer.cancel();
    }
  });
}
