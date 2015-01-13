part of ebml;

/// The EBML container. Implementation follows RFC at
/// [http://matroska.org/technical/specs/rfc/index.html].
class Ebml {
  Uint8List id = new Uint8List.fromList([0x1a, 0x45, 0xdf, 0xa3]);
  int _length;

  EbmlVersion version;
  EbmlReadVersion readVersion;
  EbmlMaxIdLength maxIdLength;
  EbmlMaxSizeLength maxSizeLength;
  DocType docType;
  DocTypeVersion docTypeVersion;
  DocTypeReadVersion docTypeReadVersion;

  get length => _length;

  Uint8List toBytes() {
    List<int> bytes = [];
    bytes.addAll(id);
    var docTypeBytes = docType.toBytes();
    bytes.addAll(_encodeLength(docTypeBytes));
    bytes.addAll(docTypeBytes);
    return new Uint8List.fromList(bytes);
  }
}

class EbmlVersion {
  Uint8List id = new Uint8List.fromList([0x42, 0x86]);
  int version;
  EbmlVersion([this.version = 1]);
}

class EbmlReadVersion {
  Uint8List id = new Uint8List.fromList([0x42, 0xf7]);
  int readVersion;
  EbmlReadVersion([this.readVersion = 1]);
}

class EbmlMaxIdLength {
  Uint8List id = new Uint8List.fromList([0x42, 0xf2]);
  int maxIdLength;
  EbmlMaxIdLength([this.maxIdLength = 4]);
}

class EbmlMaxSizeLength {
  Uint8List id = new Uint8List.fromList([0x42, 0xf3]);
  int maxSizeLength;
  EbmlMaxSizeLength([this.maxSizeLength = 8]);
}

class DocType {
  Uint8List id = new Uint8List.fromList([0x42, 0x82]);
  String docType;
  /// The [docType] should only be Strings with codeUnits between 32 and 126.
  /// This is not checked and may result in unexpected or invalid files if not
  /// followed.
  DocType(this.docType);

  Uint8List toBytes() {
    List<int> bytes = [];
    bytes.addAll(id);

    var codeUnits = docType.split('').map((char) => char.codeUnitAt(0));

    bytes.addAll(_encodeLength(codeUnits));
    bytes.addAll(codeUnits);

    return new Uint8List.fromList(bytes);
  }
}

class DocTypeVersion {
  Uint8List id = new Uint8List.fromList([0x42, 0x87]);
  int version;
  DocTypeVersion([this.version = 1]);
}

class DocTypeReadVersion {
  Uint8List id = new Uint8List.fromList([0x42, 0x85]);
  int readVersion;
  DocTypeReadVersion([this.readVersion = 1]);
}



List<int> _encodeLength(Iterable<int> bytes) {
  var length = bytes.length;
  var lengthOfLength = 1;
  // - 2 to prevent 1111 1111 (reserved)
  while (pow(2, 7 * lengthOfLength) - 2 < length) {
    lengthOfLength++;
  }
  var codedLengthOfLength = 0x80 >> (lengthOfLength - 1);
  var codedLength = <int>[];
  if (codedLengthOfLength > length + 1) {
    codedLength.add(codedLengthOfLength + length);
  } else {
    codedLength.add(codedLengthOfLength);
    var index = codedLength.length;
    while (length != 0) {
      codedLength.insert(index, length & 0xff);
      length >>= 8;
    }
  }
  return codedLength;
}
