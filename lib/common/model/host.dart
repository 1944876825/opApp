class Host {
  final int id;
  final String name;
  final String address;
  final int port;
  final String username;
  final String password;
  final String type;
  final String status;
  final String lastCheck;
  final String description;

  Host({
    required this.id,
    required this.name,
    required this.address,
    required this.port,
    required this.username,
    required this.password,
    required this.type,
    required this.status,
    required this.lastCheck,
    required this.description,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      port: json['port'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      lastCheck: json['lastCheck'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'port': port,
      'username': username,
      'password': password,
      'type': type,
      'status': status,
      'lastCheck': lastCheck,
      'description': description,
    };
  }
}

class HostStatus {
  final String status;
  final String message;
  final Map<String, dynamic>? data;

  HostStatus({
    required this.status,
    required this.message,
    this.data,
  });

  factory HostStatus.fromJson(Map<String, dynamic> json) {
    return HostStatus(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }
} 