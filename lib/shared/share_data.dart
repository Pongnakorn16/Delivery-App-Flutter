import 'package:flutter/material.dart';
import 'package:mobile_miniproject_app/models/response/GetLotteryNumbers_Res.dart';
import 'package:mobile_miniproject_app/models/response/GetSendOrder_Res.dart';

class ShareData with ChangeNotifier {
  //Shared data
  int check_prizeOut = 1;
  late User_info user_info;
  late User_Info_Send user_info_send;
  late User_Info_Receive user_info_receive;

  List<GetLotteryNumbers> winlotto = [];
  List<GetSendOrder> send_order_share = [];
}

class User_info {
  int uid = 0;
  int wallet = 0;
  String username = '';
  int cart_length = 0;
}

class User_Info_Send {
  int uid = 0;
  String name = '';
  String user_type = '';
  String user_image = '';
}

class User_Info_Receive {
  int uid = 0;
  String name = '';
  String user_type = '';
  String user_image = '';
}
