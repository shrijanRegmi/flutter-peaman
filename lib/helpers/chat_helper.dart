
class ChatHelper {
  // get chat id from user's and friend's id;
  String getChatId({final String myId, final String friendId}) {
    final _result = myId.compareTo(friendId);
    if (_result > 0) {
      return '${myId}_$friendId';
    } else {
      return '${friendId}_$myId';
    }
  }
}
