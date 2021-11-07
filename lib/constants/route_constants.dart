part of 'constants.dart';

class Routes {
  //initial
  static const initial = splashScreen;

  //main
  static const main = 'main';

  //login
  static const login = Symbols.forwardSlash + 'loginRoute';

  //signup
  static const signupPhoneNumber = Symbols.forwardSlash + 'signupPhoneNumber';

  //Account
  static const profileEdit = 'profileEdit';
  static const profilePasswordEdit = 'profilePasswordEdit';
  static const contact = 'contact';

  //List of Request wait to collect
  static const requestsWaitToCollect = 'listRequestsWaitToCollect';

  //Request Detail
  static const requestDetail = 'requestDetail';

  //PendingRequests
  static const pendingRequests = 'pendingRequests';
  static const pendingRequestDetail = 'pendingRequestDetail';

  //Scrap Categories
  static const categories = 'categories';
  static const categoryDetail = 'categoryDetail';
  static const addCategory = 'addCategory';

  //QR Code
  static const accountQRCode = 'accountQRCode';

  //splash screen
  static const splashScreen = 'splashScreen';

  //dealer
  static const dealerSearch = 'dealerSearch';
  static const dealerMap = 'dealerMap';
  static const dealerDetail = 'dealerDetail';

  static const viewImage = 'viewImage';

  static const approvedRequests = 'approvedRequests';

  //edit password
  static const forgetPasswordPhoneNumber = 'editPasswordPhoneNumber';
  static const forgetPasswordOTP = 'forgetPasswordOTP';
  static const forgetPasswordNewPassword = 'forgetPasswordNewPassword';

  static const sellerTransactionDetail = 'sellerTransactionDetail';
  static const dealerTransactionDetail = 'dealerTransactionDetail';
  static const signupOTP = 'signupOTP';
  static const signupInformation = 'signupInformation';
}
