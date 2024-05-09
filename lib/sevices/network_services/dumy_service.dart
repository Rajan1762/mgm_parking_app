import 'dart:convert';
import '../../model/dummy_model.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;

Future<List<DealsCardModel>?>? getAllDealsCardData() async{
  print("url = $baseUrl$dealsUrl");
  var response = await http.get(Uri.parse("$baseUrl$dealsUrl"));
  print("response = ${response.body}");
  if(response.body!="")
  {
    dealsCardList = [];
    List jsonBody = json.decode(response.body);
    for (var element in jsonBody) {
      dealsCardList?.add(DealsCardModel.fromJson(element));
    }
    return dealsCardList;
  }
  return null;
}