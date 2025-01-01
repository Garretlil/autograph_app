class UserData{
  UserData._privateConstructor();
  static final UserData instance = UserData._privateConstructor();

   String name = '';
   String surname = '';
   String email = '';
   String phoneNumber = '';
   String country = '';

  void getNameFromDB(){
    name='EMILIA';
  }
  void getSurname(){
    surname='BOBROVICH';
  }
  void getEmail(){
     email='SHESAIDEMMA@GMAIL.COM';
  }
  void getPhoneNumber(){
     phoneNumber='89692515672';
  }
  void getCountry(){
     country='USA';
  }
  void initUser(){
    getNameFromDB();
    getCountry();
    getEmail();
    getPhoneNumber();
    getSurname();
  }

}