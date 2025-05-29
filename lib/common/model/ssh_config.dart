class SSHConfig {
  final String host;
  final int port;
  final String username;
  final String password;
  final String? name;
  final String? id;

  SSHConfig({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    this.name,
    this.id,
  });

  factory SSHConfig.fromJson(Map<String, dynamic> json) {
    return SSHConfig(
      host: json['host'] as String,
      port: json['port'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      name: json['name'] as String?,
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      if (name != null) 'name': name,
      if (id != null) 'id': id,
    };
  }
} 