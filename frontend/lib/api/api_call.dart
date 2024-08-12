import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:myapp/model/response_model.dart';

import '../model/req_model.dart';

Future<ResponseModel> uploadImage(File imageFile) async {
  var uri = Uri.parse('http://192.168.29.135:8000/getCatImgData');

  var request = http.MultipartRequest('POST', uri)
    ..headers['Accept'] = '*/*'
    ..fields['prompt'] = '"""""'
    ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();
  ResponseModel catImgDataRes = ResponseModel();
  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    catImgDataRes = ResponseModel.fromJson(responseData);
    return catImgDataRes;
  } else {
    return catImgDataRes;
  }
}

Future<ResponseModel> continueChats(ReqModel conversationHistory) async {
  var uri = Uri.parse('http://192.168.29.135:8000/continueChats');
  String req = jsonEncode(conversationHistory.toJson()['req']);
  var request = http.MultipartRequest('POST', uri)
    ..headers['Accept'] = '*/*'
    ..fields['conversationHistory'] = ''' $req ''';

  var response = await request.send();
  ResponseModel continueChatsRes = ResponseModel();
  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    continueChatsRes = ResponseModel.fromJson(responseData);
    return continueChatsRes;
  } else {
    return continueChatsRes;
  }
}
