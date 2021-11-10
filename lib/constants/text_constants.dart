class TextConstants {
  static const String accessToken = 'accessToken';
  static const String emptyString = '';
  static const String zeroString = '0';
  static const String zeroId = '00000000-0000-0000-0000-000000000000';
  static const String missingBearerToken = 'missingBearerToken';
  static const String processing = 'Đang xử lí...';
  static const String close = 'Đóng';
  static const String ok = 'Đồng ý';
  static const String cancel = 'Huỷ';
  static const String category = 'Danh mục';
  static const String addCategory = 'Thêm danh mục';
  static const String errorHappenedTryAgain =
      'Đã có lỗi xảy ra, vui lòng thử lại';
  static const String addScrapCategory = 'Thêm danh mục';
  static const String addScrapCategorySucessfull = 'Thêm danh mục thành công';
  static const String updateScrapCategorySucessfull = 'Lưu danh mục thành công';
  static const String deleteScrapCategorySucessfull = 'Xoá danh mục thành công';
  static const String delete = 'Xoá';
  static const String image = 'Hình ảnh';
  static String deleteScrapCategory({required String name}) =>
      'Xoá danh mục $name ?';
  static const String scrapCategoryName = 'Tên danh mục phế liệu';
  static const String inputScrapCategoryName = 'Nhập tên loại phế liệu';
  static const String scrapNameExisted = 'Tên phế liệu đã tồn tại';
  static const String detail = 'Chi tiết';
  static const String unit = 'Đơn vị';
  static const String unitIsExisted = 'Đơn vị đã có';
  static const String unitPrice = 'Đơn giá';
  static const String eachScrapCategoryHasAtLeastOneUnit =
      'Mỗi danh mục nên có một đơn vị';
  static const String camera = 'Máy ảnh';
  static const String gallery = 'Thư viện';
  static const String saveUpdate = 'Lưu thay đổi';
  static const String createTransactionSuccessfullyText =
      'Tạo giao dịch thành công';
  static const String createTransactionFailedText = 'Tạo giao dịch thất bại';
  static const String createTransaction = 'Tạo giao dịch';
  static const String sellerPhone = 'Số điện thoại người bán';
  static const String phoneBlank = 'Số điện thoại không được để trống';
  static const String sellerName = 'Tên người bán';
  static const String noItemsErrorText = 'Giao dịch phải có một danh mục';
  static const String subTotal = 'Tạm tính';
  static const String total = 'Khách hàng nhận';
  static const String calculatedByUnitPrice = 'Tính theo đơn giá';
  static const String calculatedByUnitPriceExplaination =
      'Tính tiền bằng đơn giá nhân số lượng';
  static const String scrapType = 'Loại phế liệu';
  static const String scrapTypeBlank = '$scrapType không được để trống';
  static const String scrapTypeNotChoosenError = 'Xin chọn $scrapType';
  static const String scrapCategoryUnitBlank = 'Xin chọn $unit';
  static const String quantity = 'Số lượng';
  static const String quantityBlank = '$quantity không được để trống';
  static const String quantityZero = '$quantity phải lớn hơn 0';
  static const String unitPriceBlank = '$unitPrice không được để trống';
  static const String unitPriceNegative = '$unitPrice không được là số âm';
  static const String totalBlank = 'Tổng cộng không được để trống';
  static const String totalSmallerThanZero = 'Tổng cộng phải lớn hơn 0 đ';
  static const String totalOverLimit = 'Tổng cộng thấp hơn 100 triệu đồng';
  static const String addScrap = 'Thêm phế liệu';
}
