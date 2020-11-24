import 'package:http/http.dart' as http;

class Request {
  var urlBase = 'http://demo.mbrcables.com/stoopup-app/';
  final String url;
  final dynamic body;
  String token='39ceb40d461e76cf21161d38ea6e752e60695a5b01f8541728966caac80d5b643efe88bfa96e9a21033ef284c01d06a653eadbeb738f92ad5392ba11b9ef5d23';

  Request({this.url, this.body});

  Future<http.Response> post() {

    return http.post(urlBase + url, body: body).timeout(Duration(minutes: 1));
  }

  Future<http.Response> get() {
    return http.get(urlBase + url).timeout(Duration(minutes: 1));
  }

  Future<http.Response> getWithHeader() {
    return http.get(urlBase + url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(Duration(minutes: 1));
  }

  Future<http.Response> postWithHeader() {
    return http.post(urlBase + url, body: body,headers: {
      'Accept': 'application/json',
      'Appversion': '1.0.',
      'Ostype': 'floater',
      'apikey': 'adsandurl_UI00HThkkL51r14yui3ertjui7f567',
      'id': '16',
    }).timeout(Duration(minutes: 1));
  }
}