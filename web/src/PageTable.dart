import 'dart:html';

class PageTable {
  static Map links = {};

  static void createLink(int vAdress, int pAdress) {
    var pageTable = querySelector('#pageTable');
    var newLink = DivElement();
    newLink.className = 'flex w-full h-7 border-t-0 border-gray bg-gray-100';
    newLink.id = 'link$vAdress$pAdress';
    var vAdressLink = DivElement();
    vAdressLink.className = 'w-1/2 h-full text-center border border-l-0';
    vAdressLink.text = '$vAdress';
    newLink.append(vAdressLink);

    var vPhysicalAdress = DivElement();
    vPhysicalAdress.className = 'w-1/2 h-full text-center border border-l-0';
    vPhysicalAdress.text = '$pAdress';
    newLink.append(vPhysicalAdress);

    pageTable.append(newLink);
    links[vAdress] = pAdress;
  }

  static void removeLink(int vAdress, int pAdress) {
    var theLink = querySelector('#link$vAdress$pAdress');
    links.remove(vAdress);
    theLink.remove();
  }
}
