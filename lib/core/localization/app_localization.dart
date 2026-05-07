import 'package:flutter/widgets.dart';

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  static const _fallbackLocale = Locale('en');

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'appName': 'CAREVO',
      'waterlessCare': 'Waterless Care',
      'home': 'Home',
      'services': 'Services',
      'orders': 'Orders',
      'myOrders': 'My Orders',
      'specialOffers': 'Special Offers',
      'seeAll': 'See all',
      'ourServices': 'Our Services',
      'viewAll': 'View all',
      'hello': 'Hello',
      'there': 'there',
      'bookAtDoorstep': 'Book a car wash at your doorstep',
      'proCareEco': 'Professional care, eco-friendly products',
      'welcomeBack': 'Welcome back',
      'signInToContinue': 'Sign in to continue',
      'email': 'Email',
      'password': 'Password',
      'emailRequired': 'Email is required',
      'enterValidEmail': 'Enter a valid email',
      'passwordRequired': 'Password is required',
      'minimum6': 'Minimum 6 characters',
      'signIn': 'Sign In',
      'register': 'Register',
      'createAccount': 'Create Account',
      'fillDetails': 'Fill in your details to get started',
      'fullName': 'Full Name',
      'nameRequired': 'Name is required',
      'phoneNumber': 'Phone Number',
      'validPhone': 'Enter a valid phone',
      'createAccountBtn': 'Create Account',
      'noOrdersYet': 'No orders yet',
      'bookFirstWash': 'Book your first car wash!',
      'browseServices': 'Browse Services',
      'noAddressProvided': 'No address provided',
      'order': 'Order',
      'unpaid': 'Unpaid',
      'verifying': 'Verifying',
      'paid': 'Paid',
      'refunded': 'Refunded',
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'onTheWay': 'On The Way',
      'inProgress': 'In Progress',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'tryAgain': 'Try Again',
      'secureSupabase': 'Secure sign in powered by Supabase',
      'premiumMobileWash': 'Premium Mobile Car Wash',
      'dontHaveAccount': 'Don\'t have an account? ',
      'profile': 'Profile',
      'comingSoon': 'Coming Soon',
    },
    'ar': {
      'appName': 'كاريفو',
      'waterlessCare': 'عناية بدون ماء',
      'home': 'الرئيسية',
      'services': 'الخدمات',
      'orders': 'الطلبات',
      'myOrders': 'طلباتي',
      'specialOffers': 'العروض الخاصة',
      'seeAll': 'عرض الكل',
      'ourServices': 'خدماتنا',
      'viewAll': 'عرض الكل',
      'hello': 'اهلا',
      'there': 'صديقي',
      'bookAtDoorstep': 'احجز غسيل سيارتك عند باب بيتك',
      'proCareEco': 'عناية احترافية ومنتجات صديقة للبيئة',
      'welcomeBack': 'اهلا بعودتك',
      'signInToContinue': 'سجّل الدخول للمتابعة',
      'email': 'البريد الالكتروني',
      'password': 'كلمة المرور',
      'emailRequired': 'البريد الالكتروني مطلوب',
      'enterValidEmail': 'ادخل بريدا الكترونيا صحيحا',
      'passwordRequired': 'كلمة المرور مطلوبة',
      'minimum6': 'الحد الادنى 6 حروف',
      'signIn': 'تسجيل الدخول',
      'register': 'تسجيل',
      'createAccount': 'انشاء حساب',
      'fillDetails': 'املأ بياناتك للبدء',
      'fullName': 'الاسم الكامل',
      'nameRequired': 'الاسم مطلوب',
      'phoneNumber': 'رقم الهاتف',
      'validPhone': 'ادخل رقم هاتف صحيح',
      'createAccountBtn': 'انشاء الحساب',
      'noOrdersYet': 'لا توجد طلبات بعد',
      'bookFirstWash': 'احجز اول غسلة لسيارتك',
      'browseServices': 'تصفح الخدمات',
      'noAddressProvided': 'لا يوجد عنوان',
      'order': 'طلب',
      'unpaid': 'غير مدفوع',
      'verifying': 'قيد التحقق',
      'paid': 'مدفوع',
      'refunded': 'مسترد',
      'pending': 'قيد الانتظار',
      'confirmed': 'مؤكد',
      'onTheWay': 'في الطريق',
      'inProgress': 'جار التنفيذ',
      'completed': 'مكتمل',
      'cancelled': 'ملغي',
      'tryAgain': 'حاول مرة اخرى',
      'secureSupabase': 'تسجيل دخول آمن عبر Supabase',
      'premiumMobileWash': 'غسيل سيارات متنقل فاخر',
      'dontHaveAccount': 'ليس لديك حساب؟ ',
      'profile': 'الملف الشخصي',
      'comingSoon': 'قريبا',
    },
  };

  String t(String key) {
    final languageCode = _strings.containsKey(locale.languageCode)
        ? locale.languageCode
        : _fallbackLocale.languageCode;
    return _strings[languageCode]?[key] ??
        _strings[_fallbackLocale.languageCode]?[key] ??
        key;
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization) ??
        AppLocalization(_fallbackLocale);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalization.supportedLocales
      .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async => AppLocalization(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) =>
      false;
}

extension AppLocalizationX on BuildContext {
  AppLocalization get l10n => AppLocalization.of(this);
}
