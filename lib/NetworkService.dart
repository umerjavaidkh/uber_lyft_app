import 'package:uber_lyft_app/simulator/WebSocket.dart';
import 'package:uber_lyft_app/simulator/WebSocketListener.dart';

class NetworkService{

  WebSocket  createWebSocket(WebSocketListener webSocketListener)  {
  return WebSocket(webSocketListener);
  }

}