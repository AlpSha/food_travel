class User {
  List<String> allergies;
  List<String> languages;
  List<String> favorites;
  String country;

  User({
    this.allergies,
    this.languages,
    this.country,
    this.favorites
  });

  User.fromUser(User user) {
    allergies = [...user.allergies];
    favorites = [...user.favorites];
    country = user.country;
    languages = [...user.languages];
  }
}
