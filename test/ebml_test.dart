library ebml_test;

import 'dart:typed_data';
import 'dart:io';

import 'package:unittest/unittest.dart';
import 'package:ebml/ebml.dart';


void main() {
  group('EBML', () {
    Ebml ebml;
    setUp(() {
      ebml = new Ebml();
    });
    test('only with a DocType', () {
      ebml.docType = new DocType('someType');
      var result = ebml.toBytes();

      var expected = new File('res/onlyDocType.example').readAsBytesSync();

      expect(result, equals(new Uint8List.fromList(expected)));
    });
    test('with a length of 127 creates encoded length of 0x407f instead of 0x7f', () {
      // DocType length needs to be 124 = 127 - 2 (id) - 1 (encoded length)
      ebml.docType = new DocType('1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234');
      var result = ebml.toBytes();

      expect(result[4], equals(0x40));
      expect(result[5], equals(0x7f));
    });
  });
}
