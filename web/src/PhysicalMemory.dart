import 'dart:html';

import 'PhysicalFrame.dart';
import 'VirtualPage.dart';
import 'dart:math';

class PhysicalMemory {
  Map pMap = {};
  int nBits = 20;
  int pageSize = 4096;
  int pFrame;

  PhysicalMemory(int nBits, int pageSize) {
    pFrame = (pow(2, nBits) / pageSize) as int;
    for (var i = 1; i <= pFrame; i++) {
      pMap[i] = VirtualPage(pageSize, nBits);
    }
  }

  Map getPMap() {
    return pMap;
  }

  PhysicalFrame getPhysicalFrame(int index) {
    return pMap[index];
  }

  // void setVirtualPage(int index, VirtualPage vp) {
  //   pMap[index] = vp;
  // }

  void toHtml() {
    var pMTable = querySelector('#physicalTable');
    pMTable.children = [];
    pMap.forEach((k, v) {
      var physicalFrameDiv = DivElement();
      physicalFrameDiv.className = "w-full h-12 border-2 border-gray text-center ml-0";
      if (v.getStatus() == 0) {
        physicalFrameDiv.text = '${k} - FREE';
      }else{
        physicalFrameDiv.text = '${k} ProcessoTODO';
      }
     
      pMTable.append(physicalFrameDiv);
    });
  }
}
