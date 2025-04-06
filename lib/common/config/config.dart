var cfg = Config();

class Config {
  String apiKey = "xxxx"; // 测试用
  String apiUrl = "http://xxxx/api/v1"; // 测试用
  // late UserInfo _userInfo;
  // UserInfo get userInfo => _userInfo;

  void setKey(key) {
    apiKey = key;
  }

  // void setUserInfo(UserInfo uf) {
  // _userInfo = uf;
  // _userInfo.userPortrait =
  // "http://162.14.96.87:4433/${_userInfo.userPortrait}";
  // }
}
