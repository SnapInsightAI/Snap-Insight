import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/api_call.dart';
import '../model/req_model.dart';
import '../model/response_model.dart';

class AppProvider extends ChangeNotifier {
  bool isLoading = false;
  TextEditingController inputController = TextEditingController();
  List<String> content = [];
  ReqModel conversationHistory = ReqModel(req: []);
  final ScrollController scrollController = ScrollController();

  Future<void> pickImage() async {
    setIsLoadingTrue();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      await uploadImageAPICall(File(pickedFile.path));
    }
    setIsLoadingFalse();
  }

  Future<void> uploadImageAPICall(File imageFile) async {
    ResponseModel catImgData = await uploadImage(imageFile);
    if (catImgData.response != null) {
      for (Candidate element in catImgData.response?.candidates ?? []) {
        content.add(element.content?.parts?.first.text ?? '');
      }
    }
  }

  Future<void> continueChatsAPICall(BuildContext context) async {
    if (inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter some text"),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      setIsLoadingTrue();
      conversationHistory.req?.add(Content(
        role: 'user',
        parts: [Part(text: inputController.text)],
      ));
      ResponseModel continueChatsRes = await continueChats(conversationHistory);
      if (continueChatsRes.response != null) {
        for (Candidate element in continueChatsRes.response?.candidates ?? []) {
          conversationHistory.req?.add(Content(
            role: 'model',
            parts: [Part(text: element.content?.parts?.first.text ?? '')],
          ));
          content.add('Q: ${inputController.text}');
          content.add(element.content?.parts?.first.text ?? '');
        }
        inputController.clear();
      }
      setIsLoadingFalse();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void setIsLoadingTrue() {
    isLoading = true;
    notifyListeners();
  }

  void setIsLoadingFalse() {
    isLoading = false;
    notifyListeners();
    _scrollToBottom();
  }
}
