import 'dart:html';

import 'VirtualPage.dart';
import 'dart:math';

class VirtualMemory {
  Map vMap = {};
  int nBits = 20;
  int pageSize = 4096;
  int vPages;

  VirtualMemory(int nBits, int pageSize) {
    vPages = (pow(2, nBits) / pageSize) as int;
    for (var i = 1; i <= vPages; i++) {
      vMap[i] = VirtualPage(pageSize, nBits);
    }
  }

  Map getVMap() {
    return vMap;
  }

  VirtualPage getVirtualPage(int index) {
    return vMap[index];
  }

  

  // void setVirtualPage(int index, VirtualPage vp) {
  //   vMap[index] = vp;
  // }

  void toHtml() {
    var vMTable = querySelector('#virtualTable');
    vMTable.children = [];
    vMap.forEach((k, v) {
      var virtualPageDiv = DivElement();
      virtualPageDiv.className = "w-full h-12 border-2 border-gray text-center ml-0";
      if (v.getStatus() == 0) {
        virtualPageDiv.text = '${k} - FREE';
      }else{
        virtualPageDiv.text = '${k} ProcessoTODO';
      }
     
      vMTable.append(virtualPageDiv);
    });
  }
}
