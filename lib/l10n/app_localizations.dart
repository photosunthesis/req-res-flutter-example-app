import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @emailOrMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number or Email'**
  String get emailOrMobileLabel;

  /// No description provided for @emailOrMobileHint.
  ///
  /// In en, this message translates to:
  /// **'karsonpark@email.com'**
  String get emailOrMobileHint;

  /// No description provided for @emailOrMobileError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email or mobile number'**
  String get emailOrMobileError;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'• • • • • •'**
  String get passwordHint;

  /// No description provided for @passwordError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordError;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @termsAgreementStart.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the '**
  String get termsAgreementStart;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @communityGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Community Guidelines'**
  String get communityGuidelines;

  /// No description provided for @cookiePolicy.
  ///
  /// In en, this message translates to:
  /// **'Cookie Policy'**
  String get cookiePolicy;

  /// No description provided for @andText.
  ///
  /// In en, this message translates to:
  /// **', and '**
  String get andText;

  /// No description provided for @noAccountText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet? '**
  String get noAccountText;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @ensureCorrectEmailError.
  ///
  /// In en, this message translates to:
  /// **'Ensure that you\'re entering the correct email'**
  String get ensureCorrectEmailError;

  /// No description provided for @requiredFieldError.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredFieldError;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otpTitle;

  /// No description provided for @otpDescription.
  ///
  /// In en, this message translates to:
  /// **'Please check your email or message inbox for the OTP. If you don\'t see it, check your spam or junk folder.'**
  String get otpDescription;

  /// No description provided for @enterOtpLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtpLabel;

  /// No description provided for @codeExpiringIn.
  ///
  /// In en, this message translates to:
  /// **'Code is expiring in '**
  String get codeExpiringIn;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createPassword;

  /// No description provided for @requirementLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum length: 8 characters'**
  String get requirementLength;

  /// No description provided for @requirementUppercase.
  ///
  /// In en, this message translates to:
  /// **'1 uppercase letter'**
  String get requirementUppercase;

  /// No description provided for @requirementAlphanumeric.
  ///
  /// In en, this message translates to:
  /// **'Alphanumeric'**
  String get requirementAlphanumeric;

  /// No description provided for @requirementSpecialChars.
  ///
  /// In en, this message translates to:
  /// **'Accepted special characters: ! @ # \$ & -'**
  String get requirementSpecialChars;

  /// No description provided for @termsError.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the terms and conditions'**
  String get termsError;

  /// No description provided for @createYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Create your Profile'**
  String get createYourProfile;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter your First Name'**
  String get enterFirstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your Last Name'**
  String get enterLastName;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Create your username'**
  String get enterUsername;

  /// No description provided for @minLength8.
  ///
  /// In en, this message translates to:
  /// **'Minimum length: 8 characters'**
  String get minLength8;

  /// No description provided for @oneUppercase.
  ///
  /// In en, this message translates to:
  /// **'1 uppercase letter'**
  String get oneUppercase;

  /// No description provided for @alphanumeric.
  ///
  /// In en, this message translates to:
  /// **'Alphanumeric'**
  String get alphanumeric;

  /// No description provided for @acceptedSpecialChars.
  ///
  /// In en, this message translates to:
  /// **'Accepted special characters: - _ .'**
  String get acceptedSpecialChars;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takeAPhoto;

  /// No description provided for @uploadAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo'**
  String get uploadAPhoto;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabForYou.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get tabForYou;

  /// No description provided for @tabNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get tabNews;

  /// No description provided for @tabPublicService.
  ///
  /// In en, this message translates to:
  /// **'Public Service'**
  String get tabPublicService;

  /// No description provided for @tabCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get tabCommunity;

  /// No description provided for @tabVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get tabVideos;

  /// No description provided for @tabMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get tabMessage;

  /// No description provided for @tabAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get tabAccount;

  /// No description provided for @featuredNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured News'**
  String get featuredNewsTitle;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @breakingNewsBadge.
  ///
  /// In en, this message translates to:
  /// **'Breaking News'**
  String get breakingNewsBadge;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @accountLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Locked'**
  String get accountLockedTitle;

  /// No description provided for @accountLockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Please try logging in again after 10 minutes, or reset your password.'**
  String get accountLockedMessage;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordButton;

  /// No description provided for @termsConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions Consent'**
  String get termsConsentTitle;

  /// No description provided for @termsConsentMessage.
  ///
  /// In en, this message translates to:
  /// **'To protect your rights, please read and accept the Terms of Use, Privacy Policy, Community Guidelines, and Cookie Policy.'**
  String get termsConsentMessage;

  /// No description provided for @disagreeButton.
  ///
  /// In en, this message translates to:
  /// **'Disagree'**
  String get disagreeButton;

  /// No description provided for @agreeButton.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agreeButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
