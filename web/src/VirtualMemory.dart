import 'dart:html';
import 'dart:math' as math;
import 'Log.dart';
import 'PhysicalMemory.dart';
import 'ProcessMgr.dart';
import 'VirtualPage.dart';

class VirtualMemory {
  static Map vMap = {};
  static int nBits = 20;
  static int pageSize = 4096;
  static int vPages;
  static int elements = 0;

  VirtualMemory(int nBits, int pageSize) {
    vPages = (math.pow(2, nBits) / pageSize) as int;
    for (var i = 1; i <= vPages; i++) {
      vMap[i] = VirtualPage(pageSize, nBits);
    }
  }

  static void alockProcess(int index) {
    var process = ProcessMgr.processes[index];
    var alockQnt = ((pageSize + process.getSize()) / pageSize).floor();

    for (var i = 1; i <= vPages && alockQnt > 0; i++) {
      if (getVirtualPage(i).getStatus() == 0) {
        getVirtualPage(i).setProcess(process);
        elements++;
        alockQnt--;
      }
    }
    toHtml();
  }

  static void runProcess(int index) {
    var process = ProcessMgr.processes[index];
    var alockQnt = 0;
    for (var i = 1; i <= vPages && alockQnt < 4; i++) {
      if (getVirtualPage(i).getProcess() == process) {
        alockQnt++;
      }
    }
    if (alockQnt == 0) {
      Log.createLog(
          'w-full h-7 border-2 border-t-0 border-gray gap-1 bg-green-100',
          'Process $index is completed!');

      var runBtn = querySelector('#runBtn$index');
      if (runBtn.text == 'Running' || runBtn.text == 'Run') {
        runBtn.text = 'Ended';
        runBtn.className = 'w-full h-full bg-black text-white';
      }
    } else {
      PhysicalMemory.alockProcess(index, alockQnt);
    }
  }

  static void removeProcess(int index, int timesToRemove) {
    var count = 0;
    for (var i = 1; i <= vPages && count < timesToRemove; i++) {
      if (vMap[i].getProcess()?.getId() == index) {
        vMap[i] = VirtualPage(pageSize, nBits);
        count++;
        elements--;
      }
    }
    toHtml();
    runProcess(index);
  }

  Map getVMap() {
    return vMap;
  }

  static VirtualPage getVirtualPage(int index) {
    return vMap[index];
  }

  // void setVirtualPage(int index, VirtualPage vp) {
  //   vMap[index] = vp;
  // }

  static void toHtml() {
    var vMTable = querySelector('#virtualTable');
    vMTable.children = [];
    vMap.forEach((k, v) {
      var virtualPageDiv = DivElement();
      virtualPageDiv.className =
          'flex flex-col w-full h-12 border-2 border-gray text-center ml-0 justify-between';
      if (v.getStatus() == 0) {
        virtualPageDiv.text = '$k - FREE';
      } else {
        var backgroundBar = DivElement();
        backgroundBar.style.backgroundColor = v.getProcess().getColor();
        backgroundBar.className = 'h-full w-full';
        backgroundBar.id = 'vDB${v.getProcess().getId()}';

        virtualPageDiv.text = '$k | Pr-${v.getProcess().getId()}';
        virtualPageDiv.id = 'vD${v.getProcess().getId()}';
        virtualPageDiv.append(backgroundBar);
      }

      vMTable.append(virtualPageDiv);
    });
  }
}
