import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account {
  @HiveField(0)
  String serviceName;

  @HiveField(1)
  String serviceType;

  @HiveField(2)
  String userName;

  @HiveField(3)
  String password;

  @HiveField(4)
  DateTime createdAt;

  Account({
    required this.serviceName,
    required this.serviceType,
    required this.userName,
    required this.password,
    required this.createdAt,
  });
}
