import 'dart:convert';
import 'dart:typed_data';
import 'package:motion_photos/src/constants.dart';
import 'package:xml/xml.dart';

///XMPExtractor class handles extraction of XMP data from the File's byte buffer.
///
///XMP stands for Adobe's Extensible Metadata Platform is a file labeling technology
///that lets you embed metadata into files themselves during the content creation process.
class XMPExtractor {
  /// The Method takes source file's buffer as argument and looks up for xmpmeta tag
  /// and extracts all the XML tag values in a Json format
  Map<String, dynamic> extract(Uint8List source) {
    try {
      var result = <String, String>{};

      ///create buffer string of the source file
      var buffer = latin1.decode(source, allowInvalid: false);

      ///start index of xmpmeta tag in the buffer
      int offsetBegin = buffer.indexOf(MotionPhotoConstants.markerBegin);

      ///end index of xmpmeta tag in the buffer
      int offsetEnd = buffer.indexOf(MotionPhotoConstants.markerEnd);

      if (offsetBegin != -1 || offsetEnd != -1) {
        var xmlBuffer = buffer.substring(
            offsetBegin, offsetEnd + MotionPhotoConstants.markerEnd.length);

        //create xml of the xmp buffer
        XmlDocument xml;
        xml = XmlDocument.parse(xmlBuffer);

        //retrive all the rdf tags
        var rdfDescription = xml.descendants.whereType<XmlElement>().toList();

        //extract all rdf key value pairs
        for (var element in rdfDescription) {
          _addAttribute(result, element);
        }

        return result;
      } else {
        throw 'No Metadata Found';
      }
    } catch (e) {
      rethrow;
    }
  }

  //The Method classifies and appends the rdf tags in the result Json
  void _addAttribute(Map<String, dynamic> result, XmlElement? element) {
    if (element == null) return;
    //create attribute list
    var attributeList = element.attributes.toList();

    // adds attributes to the result map
    for (var attribute in attributeList) {
      var attr = attribute.name.toString();
      if (!attr.contains('xmlns:') && !attr.contains('xml:')) {
        var key = attribute.name.toString();
        var value = attribute.value.toString();
        result[key.trim()] = value;
      }
    }

    // traverses through its childs recursively and adds attributes
    element.children.toList().forEach((child) {
      if (child is! XmlText) {
        _addAttribute(result, child as XmlElement);
      }
    });
  }
}
