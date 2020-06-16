import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:xzn/index.dart';
import 'package:xzn/models/order.dart';

import '../conf/config.dart';
import '../states/profile_change_notifier.dart';

getOrderList(BuildContext context, String token) async {
  List<Order> order_list = List<Order>();
  try {
    if (!Provider.of<OrderModel>(context, listen: false).is_loaded &&
        Provider.of<UserModel>(context, listen: false).isLogin) {
      String url = Config.baseUrl() + "user/order/list";
      var dio = new Dio();
      FormData formData = new FormData.fromMap({"token": token});
      var response = await dio.post(url, data: formData);
      var json = jsonDecode(response.data.toString());
      print(json);
      for (var item in json) {
        try {
          order_list.add(Order.fromJson(item));
        } catch (e) {
          print(e.toString());
        } finally {}
      }
      Provider.of<OrderModel>(context, listen: false).order = order_list;
      return order_list;
    } else if (Provider.of<OrderModel>(context, listen: false).is_loaded) {
      print(token);
      order_list = Provider.of<OrderModel>(context, listen: false).order;
      print(order_list);
    }
  } catch (e) {
    print(e.toString());
  }
  return order_list;
}

submitOrder(BuildContext context, String token, List<CartItem> orders,
    Address address, bool secret, String remark, double price) async {
  List<String> products = List<String>();
  try {
    String url = Config.baseUrl() + "user/order/paystate";
    for (CartItem cartItem in orders) {
      products.add(cartItem.product.product_id);
    }
    var dio = new Dio();
    FormData formData = new FormData.fromMap({
      "token": token,
      "orders": products,
      "address_id": address.address_id,
      "secret": secret,
      "remark": remark
    });
    var response = await dio.post(url, data: formData);
    var json = jsonDecode(response.data.toString());
    print(json);
    for (String product_id in products) {
      Provider.of<CartModel>(context, listen: true).delete(product_id);
    }
    Order.fromJson({
      "order_id": json["order_id"],
      "customer": {
        "phone": "",
        "sex": "",
        "nickname": ""
      },
      "address": address.toJson(),
      "note": remark,
      "total_price": price
    });

    return json["order_id"];
  } catch (e) {
    print(e.toString());
  }
}
