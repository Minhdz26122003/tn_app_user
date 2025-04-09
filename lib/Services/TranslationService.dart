import 'dart:math';
import 'dart:ui';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  static const locale = Locale('vi', 'VN');
  static const fallbackLocale = Locale('vi', 'VN');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'welcome': 'Welcome',
          'login': 'Login',
          'account': 'Account',
          'next': 'Next',
          'service_car': 'Service car',
          'password': 'Password',
          'forgot_password': 'Forgot password?',
          'notification': 'Notification',
          'overview': 'Overview',
          'transmitter': 'Transmitter',
          'gateway': 'Gateway',
          'team': 'Team',
          'home': 'Home',
          'appointment': 'Appointment',
          'or': 'Or',
          'personnel': 'Personnel',
          'personal': 'Personal',
          'personal_information': 'Personal information',
          'change_password': 'Change password',
          'create_password': 'Create password',
          'setting': 'Settings',
          'setting_app': 'Settings app',
          'language': 'Language',
          'log_out': 'Logout',
          'log_out_success': 'Logout successful',
          'other': 'Other',
          'search_keyword': 'Enter search keyword...',
          'total_gateways': 'Total number of Gateways',
          'gateway_empty': 'Gateway list is empty',
          'gateway_name': 'Gateway name',
          'number_connected_transmitters': 'Number of connected transmitters',
          'filter': 'Filter',
          'select_filter': 'Select the filter criteria you need',
          'activity': 'Activity',
          'username': 'User name',
          'area': 'Area',
          'fullname': 'Full Name',
          'enter_region': 'Enter region',
          'clear_filter': 'Clear filter',
          'apply': 'Apply',
          'gateway_details': 'Gateway details',
          'gateway_information': 'Gateway information',
          'List_connected_transmitters': 'List of connected transmitters',
          'device_id': 'Device ID',
          'connecting_ip': 'Connecting IP',
          'last_online': 'Last online',
          'status': 'Status',
          'notes': 'Notes',
          'emitter_list_empty': 'Empty emitter list',
          'transmitter_name': 'Transmitter name',
          'team_use': 'Team use',
          'team_code': 'Team code',
          'leader_team': 'Leader team',
          'collapse': 'Collapse',
          'details': 'Details ',
          'enter_code_team_name': 'Enter team code or team name',
          'total_number_transmitters': 'Total number of transmitters',
          'total_active_transmitter': 'Transmitter works',
          'ng_generator': 'Total NG generator',
          'longest_ng_time': 'Longest NG time',
          'transmitter_number': 'NG transmitter number',
          'no_ng_transmitter': 'No NG transmitter',
          'transmitter_id': 'Transmitter ID',
          'static_value': 'Static value',
          'belong_to_team': 'Belong to team',
          'detection_time': 'Detection time',
          'ng_time': 'NG time',
          'processing': 'Processing',
          'confirm_processing': 'Confirm processing',
          'are_confirm_processing':
              'Are you sure you want to confirm processing?',
          'unprocessed': 'Unprocessed',
          'list_of_personnel': 'List of personnel',
          'empty_personnel': 'Empty personnel list',
          'personnel_code': 'Personnel code',
          'personnel_name': 'Personnel name',
          'position': 'Position',
          'enter_position_name': 'Enter position name',
          'personnel_details': 'Personnel details',
          'full_name': 'Full name',
          'email': 'Email',
          'phone_number': 'Phone number',
          'created_at': 'Created at',
          'total_teams': 'Total teams',
          'total_personnel': 'Total personnel',
          'team_list_empty': 'Team list is empty',
          'team_name': 'Team name',
          'administrator': 'Administrator',
          'total_devices': 'Total number of devices',
          'leader': 'leader',
          'enter_leader_name': 'Enter leader name',
          'team_details': 'Team details',
          'team_information': 'Team information',
          'dependent_team': 'Dependent Team',
          'ng_transmitter_history': 'NG transmitter history',
          'member_number': 'Member number',
          'device_number': 'Device number',
          'administrator_name': 'Administrator name',
          'manager_id': 'Manager ID',
          'device_name': 'Device name',
          'welcome_to_GaraTech': 'Welcome to GaraTech! 🚗💨',
          'battery_percentage': 'Battery percentage',
          'electrostatic_value': 'Electrostatic value',
          'ng_detection_time': 'NG detection time',
          'depending_team_list': 'depending team list',
          'dependent_team_empty': 'The dependent team list is empty',
          'ng_transmitter_history_empty':
              'NG transmitter history list is empty',
          'ng_status': 'NG status',
          'not_good': 'Not good',
          'normal': 'Normal',
          'not_use': 'Not in use',
          'in_use': 'In use',
          'transmitter_details': 'Transmitter details',
          'transmitter_information': 'Transmitter information',
          'device_mac_number': 'Device MAC number',
          'gateway_connecting': 'Gateway is connecting',
          'wave_status': 'Wave status',
          'use_device': 'Use device',
          'stop_using': 'Stop using',
          'are_transmitter':
              'Are you sure you want to stop user use of this transmitter',
          'ng_Interval': 'NG Interval',
          'cancel': 'Cancel',
          'login_now': 'Login ',
          'confirm': 'Confirm',
          'confirm_processing_successful': 'Confirm processing successful',
          'minute': 'minute',
          'seconds': 'seconds',
          'send_link': 'Send link',
          'already_have_account': 'Already have account ?',
          'create_new_password': 'Create new password',
          'old_password': 'Old password',
          'enter_current_password': 'Enter current password',
          'new_password': 'New password',
          'enter_new_password': 'Enter new password',
          'enter_old_password': 'Enter old password',
          'confirm_password': 'Confirm password',
          're_enter_new_password': 'Re-enter new password',
          'old_password_incorrect': 'Old password is incorrect',
          '6_characters': 'New password must have at least 6 characters',
          'password_contain':
              'Password must contain at least one set of uppercase letters, lowercase letters and numbers',
          'password_not_match': 'Confirm new password does not match',
          'password_changed_successfully': 'Password changed successfully',
          'date_of_birth': 'Date of birth',
          'select_gender': 'Select gender',
          'male': 'Male',
          'sign_up': 'Sign up',
          'expand': 'Expand',
          'female': 'Female',
          'address': 'Address',
          'You_do_not_have_an_account': 'You do not have an account ? ',
          'specific_address': 'Specific address: SN, Street, Village...',
          'account_information': 'Account information',
          'update': 'Update',
          'take_photo': 'Take photo',
          'gallery': 'Gallery',
          'enter_full_name': 'Enter full name',
          'enter_username': 'Enter user name',
          'phone_number_format': 'Phone number is not in the correct format',
          'account_updated_successfully':
              'Account information updated successfully',
          'new_password_cannot_old_password':
              'New password cannot be the same as old password',
          'back': 'Back',
          'we_send_password':
              'We will send you a password change link to the email:',
          'email_address': 'Email Address',
          'otp_code': 'OTP code',
          'send_otp': 'Send OTP',
          'send_again': 'Send again',
          'enter_otp': 'Enter OTP code',
          'validate_password':
              'Make sure your password includes both upper and lower case letters as well as numbers to protect your account.',
          'continue': 'Continue',
          'enter_email_address': 'Enter email address',
          'email_formatted': 'Email is not formatted',
          'full_name_50_characters': 'Full name exceeds 50 characters',
          'address_255_characters': 'Address exceeds 255 characters',
          'login_session_expired': 'Login session expired',
          'search_transmitter_id': 'Search by transmitter ID',
          'search_mac_name': 'Search by MAC number, device name',
          'search_gateway_id_name': 'Search by gateway ID, name',
          'search_employee_id_name': 'Search by code, employee name',
          '50_characters': 'New password exceeds 50 characters',
          'seconds_ago': 'seconds ago',
          'minutes_ago': 'minutes ago',
          'hours_ago': 'hours ago',
          'mark_all_read': 'Mark all read',
          'all_notifications':
              'Are you sure you want to mark all notifications as read',
          'no_announcements': 'No announcements'
        },
        'vi_VN': {
          'welcome': 'Chào mừng',
          'login': 'Đăng nhập',
          'account': 'Tài khoản',
          'next': 'Tiếp theo',
          'other': 'Khác',
          'or': 'Hoặc',
          'password': 'Mật khẩu',
          'forgot_password': 'Quên mật khẩu?',
          'already_have_account': 'Bạn đã có tài khoản ?',
          'notification': 'Thông báo',
          'overview': 'Tổng quan',
          'transmitter': 'Bộ phát',
          'gateway': 'Gateway',
          'home': 'Trang chủ',
          'username': 'Tên đăng nhập',
          'team': 'Team',
          'service_car': 'Dịch vụ xe',
          'personnel': 'Nhân viên',
          'appointment': 'Lịch hẹn',
          'personal': 'Cá nhân',
          'personal_information': 'Thông tin cá nhân',
          'change_password': 'Đổi mật khẩu',
          'create_password': 'Tạo mới mật khẩu',
          'setting': 'Cài đặt',
          'setting_app': 'Cài đặt ứng dụng',
          'language': 'Ngôn ngữ',
          'log_out': 'Đăng xuất',
          'log_out_success': 'Đăng xuất thành công',
          'welcome_to_GaraTech': 'Chào mừng đến với GaraTech! 🚗💨',
          'search_keyword': 'Nhập từ khóa tìm kiếm...',
          'total_gateways': 'Tổng số Gateway',
          'gateway_empty': 'Danh sách gateway trống',
          'gateway_name': 'Tên gateway',
          'number_connected_transmitters': 'Số lượng bộ phát kết nối',
          'filter': 'Bộ lọc',
          'select_filter': 'Lựa chọn tiêu chí lọc bạn cần',
          'activity': 'Hoạt động',
          'area': 'Khu vực',
          'enter_username': 'Nhập tên đăng nhập',
          'enter_region': 'Nhập khu vực',
          'clear_filter': 'Xóa bộ lọc',
          'apply': 'Áp dụng',
          'gateway_details': 'Chi tiết gateway',
          'gateway_information': 'Thông tin gateway',
          'List_connected_transmitters': 'Danh sách bộ phát đang kết nối',
          'device_id': 'ID thiết bị',
          'connecting_ip': 'IP đang kết nối',
          'last_online': 'Online lần cuối',
          'status': 'Trạng thái',
          'login_now': 'Đăng nhập',
          'notes': 'Ghi chú',
          'emitter_list_empty': 'Danh sách bộ phát trống',
          'transmitter_name': 'Tên bộ phát',
          'team_use': 'Team sử dụng',
          'team_code': 'Mã team',
          'leader_team': 'Leader team',
          'collapse': 'Thu gọn',
          'expand': 'Xem thêm',
          'details': 'Thông tin chi tiết',
          'enter_code_team_name': 'Nhập mã team hoặc tên team',
          'total_number_transmitters': 'Tổng số bộ phát',
          'total_active_transmitter': 'Bộ phát hoạt động',
          'ng_generator': 'Tổng bộ phát NG',
          'longest_ng_time': 'Thời gian NG lâu nhất',
          'transmitter_number': 'Số bộ phát ng',
          'no_ng_transmitter': 'Không có bộ phát NG',
          'transmitter_id': 'ID bộ phát',
          'static_value': 'Giá trị tĩnh điện',
          'belong_to_team': 'Thuộc team',
          'detection_time': 'Thời gian phát hiện',
          'ng_time': 'Thời gian NG',
          'processing': 'Đang xử lý',
          'You_do_not_have_an_account': 'Bạn chưa có tài khoản ? ',
          'confirm_processing': 'Xác nhận xử lý',
          'are_confirm_processing': 'Bạn có chắc chắn muốn xác nhận xử lý?',
          'unprocessed': 'Chưa xử lý',
          'list_of_personnel': 'Danh sách nhân viên',
          'empty_personnel': 'Danh sách nhân viên trống',
          'personnel_code': 'Mã nhân viên',
          'personnel_name': 'Tên nhân viên',
          'position': 'Chức vụ',
          'enter_position_name': 'Nhập tên chức vụ',
          'personnel_details': 'Chi tiết nhân viên',
          'full_name': 'Họ và tên',
          'otp_code': 'Mã OTP',
          'email': 'Email',
          'phone_number': 'Số điện thoại',
          'created_at': 'Tạo lúc',
          'total_teams': 'Tổng số team',
          'total_personnel': 'Tổng nhân viên',
          'team_list_empty': 'Danh sách team trống',
          'team_name': 'Tên team',
          'administrator': 'Người quản lý',
          'total_devices': 'Tổng số thiết bị',
          'leader': 'leader',
          'enter_leader_name': 'Nhập tên leader',
          'team_details': 'Chi tiết team',
          'team_information': 'Thông tin team',
          'dependent_team': 'Team phụ thuộc',
          'member_number': 'Số thành viên',
          'device_number': 'Số thiết bị',
          'administrator_name': 'Tên người quản lý',
          'manager_id': 'ID người quản lý',
          'device_name': 'Tên thiết bị',
          'battery_percentage': 'Phần trăm pin',
          'ng_transmitter_history': 'Lịch sử bộ phát NG',
          'electrostatic_value': 'Giá trị tĩnh điện',
          'ng_detection_time': 'Thời gian phát hiện NG',
          'depending_team_list': 'danh sách team phụ thuộc',
          'dependent_team_empty': 'Danh sách team phụ thuộc trống',
          'ng_transmitter_history_empty': 'Danh sách lịch sử bộ phát NG trống',
          'ng_status': 'Tình trạng NG',
          'not_good': 'Not good',
          'normal': 'Bình thường',
          'fullname': 'Tên đầy đủ',
          'not_use': 'Không sử dụng',
          'in_use': 'Đang sử dụng',
          'transmitter_details': 'Chi tiết bộ phát',
          'transmitter_information': 'Thông tin bộ phát',
          'device_mac_number': 'Số MAC thiết bị',
          'gateway_connecting': 'Gateway đang kết nối',
          'wave_status': 'Trạng thái sóng',
          'use_device': 'Sử dụng thiết bị',
          'stop_using': 'Ngừng sử dụng',
          'are_transmitter':
              'Bạn có chắc muốn ngừng sử dụng của người dùng với thiết bị phát này',
          'ng_Interval': 'Khoảng thời gian NG',
          'cancel': 'Hủy bỏ',
          'confirm': 'Xác nhận',
          'confirm_processing_successful': 'Xác nhận xử lý thành công',
          'minute': 'phút',
          'sign_up': 'Đăng ký',
          'seconds': 'giây',
          'send_link': 'Gửi liên kết',
          'old_password': 'Mật khẩu cũ',
          'enter_current_password': 'Nhập mật khẩu hiện tại',
          'create_new_password': 'Tạo mật khẩu mới',
          'new_password': 'Mật khẩu mới',
          'enter_new_password': 'Nhập mật khẩu mới',
          'enter_old_password': 'Nhập mật khẩu cũ',
          'confirm_password': 'Xác nhận mật khẩu',
          're_enter_new_password': 'Nhập lại mật khẩu mới',
          'old_password_incorrect': 'Mật khẩu cũ không đúng',
          '6_characters': 'Mật khẩu mới phải có ít nhất 6 ký tự',
          'password_contain':
              'Mật khẩu phải có ít nhất một nhóm chữ hoa, chữ thường và số',
          'password_not_match': 'Xác nhận mật khẩu mới không khớp',
          'password_changed_successfully': 'Đổi mật khẩu thành công',
          'date_of_birth': 'Ngày sinh',
          'select_gender': 'Chọn giới tính',
          'male': 'Nam',
          'female': 'Nữ',
          'address': 'Địa chỉ',
          'specific_address': 'Địa chỉ cụ thể: SN, Đường, Thôn...',
          'account_information': 'Thông tin tài khoản',
          'update': 'Cập nhật',
          'take_photo': 'Chụp ảnh',
          'gallery': 'Thư viện',
          'enter_full_name': 'Nhập họ và tên',
          'phone_number_format': 'Số điện thoại không đúng định dạng',
          'account_updated_successfully':
              'Cập nhật thông tin tài khoản thành công',
          'new_password_cannot_old_password':
              'Mật khẩu mới không được trùng với mật khẩu cũ',
          'back': 'Quay lại',
          'we_send_password':
              'Chúng tôi sẽ gửi cho bạn một liên kết đổi mật khẩu đến địa chỉ email:',
          'email_address': 'Địa chỉ Email',
          'send_otp': 'Gửi OTP',
          'send_again': 'Gửi lại',
          'enter_otp': 'Nhập mã OTP',
          'validate_password':
              'Đảm bảo mật khẩu của bạn bao gồm cả chữ hoa và chữ thường cũng như số để bảo vệ tài khoản của bạn.',
          'continue': 'Tiếp tục',
          'enter_email_address': 'Nhập địa chỉ email',
          'email_formatted': 'Email không đúng định dạng',
          'full_name_50_characters': 'Họ và tên vượt quá 50 ký tự',
          'address_255_characters': 'Địa chỉ vượt quá 255 ký tự',
          'login_session_expired': 'Đã hết phiên đăng nhập',
          'search_transmitter_id': 'Tìm kiếm theo ID bộ phát',
          'search_mac_name': 'Tìm kiếm theo số MAC, tên thiết bị',
          'search_gateway_id_name': 'Tìm kiếm theo ID gateway, tên',
          'search_employee_id_name': 'Tìm kiếm theo mã, tên nhân viên',
          '50_characters': 'Mật khẩu mới vượt quá 50 ký tự',
          'seconds_ago': 'giây trước',
          'minutes_ago': 'phút trước',
          'hours_ago': 'tiếng trước',
          'mark_all_read': 'Đánh dấu đọc tất cả',
          'all_notifications':
              'Bạn chắc chắn muốn đánh dấu đọc tất cả thông báo',
          'no_announcements': 'Không có thông báo nào'
        },
      };

  static Future<void> changeLocale(String langCode) async {
    final locale = _getLocaleFromLanguage(langCode);
    debugPrint("locate : $locale", wrapWidth: 1024);
    Get.updateLocale(locale);

    Utils.saveStringWithKey(Constant.LANGUAGE_CODE, langCode);
  }

  static Locale _getLocaleFromLanguage(String langCode) {
    switch (langCode) {
      case 'vi':
        return const Locale('vi', 'VN');
      case 'en':
      default:
        return const Locale('en', 'US');
    }
  }

  static Future<Locale> getSavedLocale() async {
    String langCode = await Utils.getStringValueWithKey(Constant.LANGUAGE_CODE);
    if (langCode.isEmpty) {
      return locale;
    }
    return _getLocaleFromLanguage(langCode);
  }
}
