import 'dart:async';
import 'dart:html';
import 'dart:math' as math;
import 'Log.dart';
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
  static int elements = 0;

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
    print((pFrames - elements));
    var initialAlockQnt = alockQnt;
    while (alockQnt > 0) {
      print((pFrames - elements) < alockQnt);
      if ((pFrames - elements) < alockQnt) {
        print(123123123);
        Log.createLog(
            'w-full h-7 border-2 border-t-0 border-gray gap-1 bg-yellow-200',
            'There is no physical space for P-$index.');
        var alockToRunBtn = querySelector('#runBtn$index');
        alockToRunBtn.text = 'Run';
        alockToRunBtn.className = 'w-full h-full bg-green-200';
        break;
      }
      var i = math.Random().nextInt(pFrames + 1);
      if (getPhysicalFrame(i)?.getStatus() == 0) {
        print("alocou");
        getPhysicalFrame(i).setProcess(process);
        elements++;
        alockQnt--;
      }
    }

    toHtmlProcess(index);
    runProcess(
      index,
      process,
      initialAlockQnt-alockQnt
    );
  }

  static void runProcess(int index, Process process, int timesToRemove) {
    var count = 1;
    var processesDivs = querySelectorAll('#pDB$index');
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (count == 5) {
        removeProcess(index, timesToRemove);
        timer.cancel();
      }
      var length = processesDivs.length;
      for (var index = 0; index < length; index++) {
        processesDivs[index].className = 'w-$count/5 h-full';
      }
      count++;
    });
  }

  static void removeProcess(int index, int timesToRemove) {
    for (var i = 1; i <= pFrames; i++) {
      if (pMap[i].getProcess()?.getId() == index) {
        pMap[i] = PhysicalFrame(pageSize, nBits);
        elements--;
      }
    }
    toHtmlProcess(index);
    VirtualMemory.removeProcess(index, timesToRemove);
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
      physicalPageDiv.id = 'emptyPyDiv$k';
      physicalPageDiv.className =
          'flex flex-col w-full h-12 border-2 border-gray text-center ml-0 justify-between';
      physicalPageDiv.text = '$k - FREE';

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
        backgroundBar.id = 'pDB$index';

        physicalPageDiv.text = '$k | Pr-$index';
        physicalPageDiv.id = 'pD$index';
        physicalPageDiv.append(backgroundBar);
      } else if (physicalPageDiv == null && v.getStatus() == 0) {
        physicalPageFull.id = 'emptyPyDiv$k';
        physicalPageFull.text = '$k - FREE';
      }
    });
  }
}
