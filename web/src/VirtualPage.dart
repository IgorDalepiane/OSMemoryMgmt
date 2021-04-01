import 'dart:core';

import 'Process.dart';

class VirtualPage {
  int pbits;
  int xpbits;
  int pageSize;
  int status = 0;
  Process process;

  VirtualPage(int pageSize, int nBits) {
    pageSize = pageSize;
    pbits = nBits - 12;
    xpbits = nBits - pbits;
  }

  void setPBits(int pbits) {
    this.pbits = pbits;
  }

  void setXpBits(int xpbits) {
    this.xpbits = xpbits;
  }

  void setStatus(int status) {
    this.status = status;
  }

  void setProcess(Process process) {
    this.process = process;
    setStatus(1);
  }

  int getPBits() {
    return pbits;
  }

  int getXpBits() {
    return xpbits;
  }

  int getStatus() {
    return status;
  }
}
