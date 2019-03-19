class Validator{
  static bool isValidUser(String user)
  {
    return user!=null&&user.length>0&&user.contains("@");
  }
  static bool isValidPass(String pass)
   {
     return pass!=null&&pass.length>0;
   }
}