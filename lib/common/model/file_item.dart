class FileItem {
  final String name;
  final String path;
  final bool isDirectory;
  final int? size;
  final int? items;
  final String? type;
  final String? permission;
  final DateTime? modifiedTime;

  FileItem({
    required this.name,
    required this.path,
    required this.isDirectory,
    this.size,
    this.items,
    this.type,
    this.permission,
    this.modifiedTime,
  });

  factory FileItem.fromJson(Map<String, dynamic> json) {
    return FileItem(
      name: json['name'],
      path: json['path'],
      isDirectory: json['isDir'] ?? false,
      size: json['size'],
      items: json['items'],
      type: json['type'],
      permission: json['permission'],
      modifiedTime: json['modifiedTime'] != null
          ? DateTime.parse(json['modifiedTime'])
          : null,
    );
  }
} 