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
    test('only with DocType', () {
      ebml.docType = new DocType('someType');
      var result = ebml.toBytes();

      var expected = new File('res/onlyDocType.example').readAsBytesSync();

      expect(result, equals(new Uint8List.fromList(expected)));
    });
  });
}
