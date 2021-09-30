/// API endpoints used in the app
abstract class APIEndpoints {
// API urls
  static final String kBaseURL = "https://unilabs-api.herokuapp.com";

  static final String kLoginURL = kBaseURL + '/auth/login/';
  static final String kRefreshAuthURL = kBaseURL + '/auth/refresh-auth/';
  static final String kLogoutURL = kBaseURL + '/auth/logout/';

  static final String kItemSearchURL = kBaseURL + '/items/';
  static final String kItemStateChangeURL = kBaseURL + "/items/update/";
  static final String kItemDeleteURL = kBaseURL + "/items/delete/";

  static final String kStudentSearchURL = kBaseURL + '/students/';

  static final String kItemTempHandoverURL =
      kBaseURL + '/items/temporary-handover/';
}
