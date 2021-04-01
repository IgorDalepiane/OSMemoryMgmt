import 'dart:html';
import 'dart:math' as math;
import 'Process.dart';
import 'VirtualMemory.dart';

class ProcessMgr {
  static Map processes = {};

  ProcessMgr(int nProcess) {
    for (var i = 1; i <= nProcess; i++) {
      processes[i] = Process(math.Random().nextInt(131072), i);
    }
  }

  void toHtml() {
    var pTable = querySelector('#processesTable');
    pTable.children = [];
    processes.forEach((k, v) {
      var pIdDiv = DivElement();
      pIdDiv.className = "w-full h-7 border-2 border-gray ml-0";
      pIdDiv.text = '${k}';
      pTable.append(pIdDiv);

      var pSizeDiv = DivElement();
      pSizeDiv.className = "w-full h-7 border-2 border-l-0 border-gray ml-0";
      pSizeDiv.text = '${v.getSize()} B';
      pTable.append(pSizeDiv);

      var pActionsDiv = DivElement();
      pActionsDiv.className = "w-full h-7 border-2 border-l-0 border-gray ml-0";

      var processRunBtn = ButtonElement();
      processRunBtn.text = 'Alock';
      processRunBtn.id = 'alockBtn${k}';
      processRunBtn.className = "w-full h-full bg-yellow-200";
      processRunBtn.onClick.listen((event) {
        if(processRunBtn.id == 'alockBtn${k}'){
          var alockQnt = ((VirtualMemory.pageSize + v.getSize()) / VirtualMemory.pageSize).floor();
          if((VirtualMemory.vPages - VirtualMemory.elements)>=alockQnt){
            VirtualMemory.alockProcess(k);
            var alockToRunBtn = querySelector('#alockBtn${k}');
            alockToRunBtn.text = "Run";
            alockToRunBtn.id = 'runBtn${k}';
            alockToRunBtn.className = "w-full h-full bg-green-200";
          }else{
            var logTable = querySelector('#logsTable');
            var newLog = DivElement();
            newLog.className = "w-full h-7 border-2 border-t-0 border-gray gap-1 bg-red-100";
            newLog.text = 'There is no space for this process!';
            logTable.append(newLog);
          }
          
        }else if(processRunBtn.id == 'runBtn${k}'){
          var runBtn = querySelector('#runBtn${k}');
          if(runBtn.text == "Running"){
            var logTable = querySelector('#logsTable');
            var newLog = DivElement();
            newLog.className = "w-full h-7 border-2 border-t-0 border-gray gap-1 bg-red-100";
            newLog.text = 'This process is already running!';
            logTable.append(newLog);
          }else{
            runBtn.text = "Running";
            VirtualMemory.runProcess(k);
            runBtn.className = "w-full h-full bg-red-200";
          }
          
        }
      });
      pActionsDiv.children.add(processRunBtn);
      pTable.append(pActionsDiv);
    });
  }
}
