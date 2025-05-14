var cfg = Config();

class Config {
  String apiKey = "5cjshQoYsoagLBAPzzDQ0qXTi9JFNlFz"; // 测试用
  String apiUrl = "http://162.14.96.87:8090/api/v1"; // 测试用
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
