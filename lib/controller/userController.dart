import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quick_bocks/api/request.dart';
import 'package:quick_bocks/models/ChatListResponse.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class UserController extends GetxController{
  var chatListData = List<Data>().obs;


  @override
  void onInit() {
    _getUserList();
    super.onInit();
  }


  void _getUserList() async {
    Future.delayed(
        Duration.zero,
            () => Get.dialog(Center(child: CircularProgressIndicator()),
            barrierDismissible: false));

    Request request = Request(url: 'webservices/quickblocks/myChatUser', body: {
      "token":"7fd186b6a929c0b5c342068e889cbf10c0b0773d82590029142c4d1b436ec8accd53f093154ce5178264b4400f46c9133dc14ce70e6e00b15bcb0582c0c44a15"
    });
    request.postWithHeader().then((value) {
      ChatListResponse chatListResponse =
      ChatListResponse.fromJson(json.decode(value.body));
      chatListData.value = chatListResponse.data;
      Get.back();
    }).catchError((onError) {
      print(onError);
    });
  }



}