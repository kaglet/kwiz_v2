class Friend {
//Used so you can naviagte to the quiz from viewing bookmarks
  final String? userID;
  final String? friendID;
  final String? sender;
  final String? status;
  final String? friendName;

  Friend(
      {required this.userID,
      required this.sender,
      required this.friendID,
      required this.status,
      required this.friendName});
}
