class Post{
  var email;
  var password;
  Post({required this.email,required this.password});

  Map<String,dynamic> toJson(){
    return {
      "email": email,
      "password": password,
    };
  }
}