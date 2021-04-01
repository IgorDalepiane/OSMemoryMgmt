import 'dart:html';
import 'dart:math' as math;
import 'PhysicalMemory.dart';
import 'ProcessMgr.dart';
import 'VirtualPage.dart';

class VirtualMemory {
  static Map vMap = {};
  int nBits = 20;
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
    var alockQnt = 4;
    for (var i = 1; i <= vPages && alockQnt > 0; i++) {
      if (getVirtualPage(i).getProcess() == process) {
        PhysicalMemory.alockProcess(index);
        alockQnt--;
      }
    }
    toHtml();
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
          "w-full h-12 border-2 border-gray text-center ml-0";
      if (v.getStatus() == 0) {
        virtualPageDiv.text = '${k} - FREE';
      } else {
        virtualPageDiv.text = '${k} | Process-${v.getProcess().getId()}';
        virtualPageDiv.style.backgroundColor = v.getProcess().getColor();
      }

      vMTable.append(virtualPageDiv);
    });
  }
}
