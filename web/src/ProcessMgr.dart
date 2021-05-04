import 'dart:html';
import 'dart:math' as math;
import 'Log.dart';
import 'Process.dart';
import 'VirtualMemory.dart';

class ProcessMgr {
  static Map processes = {};

  ProcessMgr(int nProcess) {
    for (var i = 1; i <= nProcess; i++) {
      processes[i] = Process(math.Random().nextInt(131072), i);
      // processes[i] = Process(math.Random().nextInt(20000), i);
    }
  }

  static void createProcess() {
    processes[processes.length + 1] =
        Process(math.Random().nextInt(131072), processes.length + 1);
    var pTable = querySelector('#processesTable');
    pTable.scrollTop =pTable.scrollHeight;
    toHtmlOne(processes.length,processes[processes.length]);
  }

  static void toHtml() {
    processes.forEach((k, v) {
      toHtmlOne(k, v);
    });
  }

  static void toHtmlOne(int k, Process v) {
    var pTable = querySelector('#processesTable');
    var pIdDiv = DivElement();
    pIdDiv.className = 'w-full h-7 border-2 border-gray ml-0';
    pIdDiv.text = '$k';
    pTable.append(pIdDiv);

    var pSizeDiv = DivElement();
    pSizeDiv.className = 'w-full h-7 border-2 border-l-0 border-gray ml-0';
    pSizeDiv.text = '${v.getSize()} B';
    pTable.append(pSizeDiv);

    var pActionsDiv = DivElement();
    pActionsDiv.className = 'w-full h-7 border-2 border-l-0 border-gray ml-0';

    var processRunBtn = ButtonElement();
    processRunBtn.text = 'Alock';
    processRunBtn.id = 'alockBtn$k';
    processRunBtn.className = 'w-full h-full bg-yellow-200';
    processRunBtn.onClick.listen((event) {
      if (processRunBtn.id == 'alockBtn$k') {
        var alockQnt =
            ((VirtualMemory.pageSize + v.getSize()) / VirtualMemory.pageSize)
                .floor();
        if ((VirtualMemory.vPages - VirtualMemory.elements) >= alockQnt) {
          VirtualMemory.alockProcess(k);
          var alockToRunBtn = querySelector('#alockBtn$k');
          alockToRunBtn.text = 'Run';
          alockToRunBtn.id = 'runBtn$k';
          alockToRunBtn.className = 'w-full h-full bg-green-200';
        } else {
          Log.createLog(
              'w-full h-7 border-2 border-t-0 border-gray gap-1 bg-yellow-200',
              'There is no virtual space for P-$k.');
        }
      } else if (processRunBtn.id == 'runBtn$k') {
        var runBtn = querySelector('#runBtn$k');
        if (runBtn.text == 'Running') {
          Log.createLog(
              'w-full h-7 border-2 border-t-0 border-gray gap-1 bg-red-100',
              'The process P-$k is already running!');
        } else if (runBtn.text == 'Ended') {
          Log.createLog(
              'w-full h-7 border-2 border-t-0 border-gray gap-1 bg-black text-white',
              'Process $k is already completed!');
        } else {
          runBtn.text = 'Running';
          runBtn.className = 'w-full h-full bg-red-200';
          VirtualMemory.runProcess(k);
        }
      }
    });
    pActionsDiv.children.add(processRunBtn);
    pTable.append(pActionsDiv);
  }
}
