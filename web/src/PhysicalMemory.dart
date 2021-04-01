import 'dart:html';
import 'dart:math' as math;
import 'PhysicalFrame.dart';
import 'ProcessMgr.dart';
import 'VirtualPage.dart';

class PhysicalMemory {
  static Map pMap = {};
  int nBits = 20;
  int pageSize = 4096;
  static int pFrames;

  PhysicalMemory(int nBits, int pageSize) {
    pFrames = (math.pow(2, nBits) / pageSize) as int;
    for (var i = 1; i <= pFrames; i++) {
      pMap[i] = PhysicalFrame(pageSize, nBits);
    }
  }

  // void setVirtualPage(int index, VirtualPage vp) {
  //   pMap[index] = vp;
  // }

  static void alockProcess(int index) {
    var process = ProcessMgr.processes[index];
    var alockQnt = 1;
    while (alockQnt > 0) {
      var i = math.Random().nextInt(pFrames);
      if (getPhysicalFrame(i).getStatus() == 0) {
        getPhysicalFrame(i).setProcess(process);
        alockQnt--;
      }
    }
    toHtml();
  }

  Map getPMap() {
    return pMap;
  }

  static PhysicalFrame getPhysicalFrame(int index) {
    return pMap[index];
  }

  static void toHtml() {
    var pMTable = querySelector('#physicalTable');
    pMTable.children = [];
    pMap.forEach((k, v) {
      var physicalPageDiv = DivElement();
      physicalPageDiv.className =
          "w-full h-12 border-2 border-gray text-center ml-0";
      if (v.getStatus() == 0) {
        physicalPageDiv.text = '${k} - FREE';
      } else {
        physicalPageDiv.text = '${k} | Process-${v.getProcess().getId()}';
        physicalPageDiv.style.backgroundColor = v.getProcess().getColor();
      }

      pMTable.append(physicalPageDiv);
    });
  }
}
