
abstract class WebSocketListener {

 onConnect();

 onMessage(String data);

 onDisconnect();

 onError(String error);

}