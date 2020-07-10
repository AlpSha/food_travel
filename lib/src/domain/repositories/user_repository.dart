abstract class UserRepository {
  List<String> getUserAllergies();

  void updateAllergies(List<String> allergies);

  void updateLanguages(List<String> languages);

  List<String> getLanguagesOfUser();
}