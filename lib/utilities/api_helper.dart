import 'dart:convert';
import 'dart:io';
import 'package:notify/providers/note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'http_exception.dart';
import 'package:http/http.dart' as http;

const String  baseUrl = 'http://ec2-13-232-102-64.ap-south-1.compute.amazonaws.com';
const String endpoint = '/recognize';

const shareBaseUrl = 'http://3.236.246.163:3000';
const shareEndpoint = '/shared-url-generator/';
const shareableUrl = 'https://biblography-6adfa.web.app';


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
    final response = await http.post(url, body: json.encode({'image': 'data:image/png;base64,$img64', 'source': 'js'}), headers: {"Content-Type": "application/json"});

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


Future<String> getShareableLink(Note note) async{
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String displayName = user.displayName??'Anonymous';
//  Map<String, String> data = ;
  print('$displayName ${note.title} ${note.body}');
  try{

    final url = '$shareBaseUrl$shareEndpoint';
    print(url);
    String id = '';
    final response = await http.post(url, body: jsonEncode({
      'username' : displayName,
      'title': note.title,
      'body': note.body
    }), headers: {"Content-Type": "application/json"});

    if(response.statusCode == 200){

      final responseBody = jsonDecode(response.body);
      print(responseBody);
       id =  responseBody['id'].toString();
      print('id: $id');
    }else{
      print(jsonDecode(response.body));
      throw HttpException(message: 'Failed to generate shareable link');
    }
    if(id.isNotEmpty){
      return '$shareableUrl/$id';
    }
    return id;

  }catch(error){
    throw error;
  }


}