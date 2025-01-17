// 数据格式说明：
// 0: 随机小数
// 1: [0,1]区间的小鼠
// 2: 整数
// "image": assets/image/下的文件名，不包括后缀
// "avatar": assets/avatar/下的文件名，不包括后缀
// "time,yymmdd hhmmss": 返回时间，并且设置格式，默认为yymmdd hhmmss 
// "":随机字符串，最长不超过40；
// "10": 随机字符串，设定长度
// "num,11": 字符串为数字，长度为11
// "alpha, 10": 字符串为字母，长度为10
// "enum[1,2,3]": 枚举属性
// "lowwerhash,11": hash值,此处表示MD*值,小写表示，长度为11
// "upperhash,11": hash值,此处表示MD*值,大写表示，长度为12

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:faker/faker.dart';

import 'fakedata.dart';

final Map<String, String> baseCode = {
  "utf": utf,
  "alpha": 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM',
  "lowwerhash": '0123456789qwertyuiopasdfghjklzxcvbnm',
  "upperhash": '0123456789QWERTYUIOPASDFGHJKLZXCVBNM',
  "num": '0123456789'
};

final Map<String, List<String>> baseData = {
  "food": food,
  "city": city,
  "sentence": sentence,
  "nickname": nickname,
  "name": name,
};

final _random = new Random();

String fakeData(String type) {
  return baseData[type][_random.nextInt(baseData[type].length)];
}

String getAssetImage() {
  var directory = new Directory(r"assets\image\");
  var files = directory.listSync().toList();
  String name = files[_random.nextInt(files.length)].path.toString();
  name = name.replaceAll(r"assets\image\", "").replaceAll(".webp", "");
  return name;
}

String getAssetAvatar() {
  var directory = new Directory(r"assets\avatar\");
  var files = directory.listSync().toList();
  String name = files[_random.nextInt(files.length)].path.toString();
  name = name.replaceAll(r"assets\avatar\", "").replaceAll(".webp", "");
  return name;
}

String generateString(String type) {
  List<String> root = type.split(",");
  int length = root.length == 1?10:int.parse(root[1]);
  String result = "";
  for (var i = 0; i < length; i++) {
    result += baseCode[root[0]][_random.nextInt(baseCode[root[0]].length)];
  }
  return result;
}

String generateUTF(String type) {
  if (type.isEmpty) type = "utf";
  else type = "utf,"+type;
  return generateString(type);
}

String randomEnum(String type) {
  type = type.substring(5, type.length-1);
  List<String> enumeration = type.split(",");
  return enumeration[_random.nextInt(enumeration.length)];
}

dynamic _fillAtomElement(dynamic type) {
  var faker = new Faker();
  if (type is String) {
    if (type == "image")
      return getAssetImage();
    else if (type == "avatar")
      return getAssetAvatar();
    else if (type.startsWith("time"))
      return DateTime.now().toString();
    else if (type.startsWith("num")|| type.startsWith("alpha") || type.startsWith("lowwerhash") || type.startsWith("upperhash")) {
      return generateString(type);
    } else if (type.startsWith("enum")) {
      return randomEnum(type);
    } else if (baseData.containsKey(type)) {
      return fakeData(type);
    }else {
      switch (type) {
        case "email": return faker.internet.email();
        case "sentences": return faker.lorem.sentences(10);
        default: return generateUTF(type);
      }
    }
  } else if (type is int) {
    if (type == 0)
      return (_random.nextDouble()*5000).truncate()/100;
    else if (type == 1)
      return (_random.nextDouble()*100).truncate()/100;
    else if (type == 2)
      return _random.nextInt(100);
  } else if (type is bool) {
    return true;
  }
}

dynamic _fillContent(dynamic obj) {
  if (obj is List<dynamic>) {
    int len = _random.nextInt(6)+1;
    if (obj[0] is String) {
      for (var i = 0; i < len - 1; i++) {
        obj.add(_fillAtomElement(obj[0]));
      }
      obj[0] = _fillAtomElement(obj[0]);
    } else {
      for (var i = 0; i < len; i++) {
        Map re_obj = json.decode(json.encode(obj[0]));
        obj.add(re_obj);
      }
      for (var i = 0; i < obj.length; i++) {
        obj[i] = _fillContent(obj[i]);
      }
    }
  } else if(obj is Map<String, dynamic>){
    obj.updateAll(
      (String key,dynamic value) {
        return _fillContent(value);
      }
    );
  } else {
    return _fillAtomElement(obj);
  }
  return obj;
}

String fillJSON(String json_text) {
  var map;
  try {
    // Map<String, dynamic> map = json.decode(json_text);
    map = json.decode(json_text);
    map.updateAll(
      (String key,dynamic value){
        return _fillContent(value);
      }
    ); 
  } catch (e) {
    map = new List();
    int len = _random.nextInt(10)+1;
    json_text = json_text.trim().substring(1, json_text.length - 1);
    for (var i = 0; i < len; i++) {
      var list_item = json.decode(json_text);
      list_item.updateAll(
        (String key,dynamic value){
          return _fillContent(value);
        }
      );
      map.add(list_item);
    }
  }
  return json.encode(map);
}