import 'dart:async';
import 'dart:html';
import 'dart:math' as math;
import 'PhysicalFrame.dart';
import 'Process.dart';
import 'ProcessMgr.dart';
import 'VirtualMemory.dart';
import 'VirtualPage.dart';

class PhysicalMemory {
  static Map pMap = {};
  static int nBits = 20;
  static int pageSize = 4096;
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

  static void alockProcess(int index, int alockQnt) {
    var process = ProcessMgr.processes[index];
    while (alockQnt > 0) {
      var i = math.Random().nextInt(pFrames);
      if (getPhysicalFrame(i)?.getStatus() == 0) {
        getPhysicalFrame(i)?.setProcess(process);
        alockQnt--;
      }
    }
    toHtmlProcess(index);
    runProcess(index, process);
  }

  static void runProcess(int index, Process process) {
    var count = 1;
    var processesDivs = querySelectorAll('#pDB${index}');
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (count == 5) {
        removeProcess(index);
        timer.cancel();
      }
      var length = processesDivs.length;
      for (var index = 0; index < length; index++) {
        processesDivs[index].className = "w-${count}/5 h-full";
      }
      count++;
    });
  }

  static void removeProcess(int index) {
    for (var i = 1; i <= pFrames; i++) {
      if (pMap[i].getProcess()?.getId() == index) {
        pMap[i] = PhysicalFrame(pageSize, nBits);
      }
    }
    toHtmlProcess(index);
    VirtualMemory.removeProcess(index);
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
      physicalPageDiv.id = "emptyPyDiv$k";
      physicalPageDiv.className =
          "flex flex-col w-full h-12 border-2 border-gray text-center ml-0 justify-between";
      physicalPageDiv.text = '${k} - FREE';

      pMTable.append(physicalPageDiv);
    });
  }

  static void toHtmlProcess(int index) {
    pMap.forEach((k, v) {
      var physicalPageDiv = querySelector('#emptyPyDiv$k');
      var physicalPageFull = querySelector('#pD$index');
      if (physicalPageDiv != null &&
          v.getStatus() == 1 &&
          v.getProcess()?.getId() == index) {
        var backgroundBar = DivElement();
        backgroundBar.style.backgroundColor = v.getProcess().getColor();
        backgroundBar.className = '';
        backgroundBar.id = 'pDB${index}';

        physicalPageDiv.text = '$k | Pr-$index';
        physicalPageDiv.id = 'pD$index';
        physicalPageDiv.append(backgroundBar);
      } else if(physicalPageDiv == null &&
          v.getStatus() == 0){
        physicalPageFull.id = 'emptyPyDiv$k';
        physicalPageFull.text = '$k - FREE';
      }
    });
  }
}
