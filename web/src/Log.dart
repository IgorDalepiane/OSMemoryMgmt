import 'dart:html';

class Log {
  static void createLog(String className, String text) {
    var logTable = querySelector('#logsTable');
    var newLog = DivElement();
    newLog.className = className;
    newLog.text = text;
    logTable.append(newLog);
    logTable.scrollTop =logTable.scrollHeight;
  }
}
