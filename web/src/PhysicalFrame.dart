import 'dart:core';

import 'Process.dart';

class PhysicalFrame {
  int qbits;
  int xqbits;
  int frameSize;
  int status = 0;
  Process process;

  PhysicalFrame(int frameSize, int nBits) {
    frameSize = frameSize;
    qbits = nBits - 12;
    xqbits = nBits - qbits;
  }

  void setQBits(int qbits) {
    this.qbits = qbits;
  }

  void setXqBits(int xqbits) {
    this.xqbits = xqbits;
  }

  void setStatus(int status) {
    this.status = status;
  }

  void setProcess(Process process) {
    this.process = process;
    setStatus(1);
  }

  int getQBits() {
    return qbits;
  }

  int getXqBits() {
    return xqbits;
  }

  int getStatus() {
    return status;
  }

  Process getProcess() {
    return process;
  }
}

