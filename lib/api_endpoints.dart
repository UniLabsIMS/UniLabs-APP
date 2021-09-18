/// API endpoints used in the app
abstract class APIEndpoints {
// API urls
  static final String kBaseURL = "https://unilabs-api.herokuapp.com";

  static final String kLoginURL = kBaseURL + '/auth/login/';
  static final String kRefreshAuthURL = kBaseURL + '/auth/refresh-auth/';
  static final String kLogoutURL = kBaseURL + '/auth/logout/';
}
