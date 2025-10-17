class User {
  final String ra;
  final String name;
  final String password;

  User({required this.ra, required this.name, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(ra: json['ra'], name: json['name'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {"ra": ra, "name": name, "password": password};
  }
}
