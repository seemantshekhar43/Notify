import 'dart:convert';
import 'dart:io';
import 'http_exception.dart';
import 'package:http/http.dart' as http;

const String  baseUrl = 'http://ec2-13-232-102-64.ap-south-1.compute.amazonaws.com';
const String endpoint = '/recognize';

Future<String> renderImageToText(String path) async{
  final bytes = File(path).readAsBytesSync();
  String img64 = base64Encode(bytes);
  print(img64.length);
  print(img64);
  String text = '';
  try{
    final url = '$baseUrl$endpoint';
    print(url);
    final Map<String, dynamic> data = {
      'image': 'data:image/png;base64,$img64',
    };
    final response = await http.post(url, body: json.encode({'image': 'data:image/png;base64,$img64',}), headers: {"Content-Type": "application/json"});

    if(response.statusCode == 200){
      final responseBody = jsonDecode(response.body);
      text =  responseBody['text'];
      print('text: $text');
    }else{
      print(jsonDecode(response.body));
      throw HttpException(message: 'Error Converting to Text');
    }
    return text;

  }catch(error){
    throw error;
  }

}


