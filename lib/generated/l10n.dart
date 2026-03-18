// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My Account`
  String get account {
    return Intl.message('My Account', name: 'account', desc: '', args: []);
  }

  /// `Profile`
  String get profileHeader {
    return Intl.message('Profile', name: 'profileHeader', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Activity & Goals Settings`
  String get activityGoals {
    return Intl.message(
      'Activity & Goals Settings',
      name: 'activityGoals',
      desc: '',
      args: [],
    );
  }

  /// `Height (cm)`
  String get height {
    return Intl.message('Height (cm)', name: 'height', desc: '', args: []);
  }

  /// `Weight (kg)`
  String get weight {
    return Intl.message('Weight (kg)', name: 'weight', desc: '', args: []);
  }

  /// `Daily Steps Goal`
  String get dailySteps {
    return Intl.message(
      'Daily Steps Goal',
      name: 'dailySteps',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get appSettings {
    return Intl.message(
      'App Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Support & Policies`
  String get supportPolicies {
    return Intl.message(
      'Support & Policies',
      name: 'supportPolicies',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get helpSupport {
    return Intl.message(
      'Help & Support',
      name: 'helpSupport',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & Terms of Use`
  String get privacyPolicy {
    return Intl.message(
      'Privacy & Terms of Use',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Total Energy`
  String get totalEnergy {
    return Intl.message(
      'Total Energy',
      name: 'totalEnergy',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirm {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Choose Language`
  String get chooseLanguage {
    return Intl.message(
      'Choose Language',
      name: 'chooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `العربية`
  String get arabic {
    return Intl.message('العربية', name: 'arabic', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to continue`
  String get loginToContinue {
    return Intl.message(
      'Sign in to continue',
      name: 'loginToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Email or Username`
  String get emailOrUsername {
    return Intl.message(
      'Email or Username',
      name: 'emailOrUsername',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Sign In`
  String get login {
    return Intl.message('Sign In', name: 'login', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get noAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get join {
    return Intl.message('Join', name: 'join', desc: '', args: []);
  }

  /// `Email is required`
  String get emailRequired {
    return Intl.message(
      'Email is required',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get enterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordMinLength {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Join VION`
  String get joinVion {
    return Intl.message('Join VION', name: 'joinVion', desc: '', args: []);
  }

  /// `Name is required`
  String get nameRequired {
    return Intl.message(
      'Name is required',
      name: 'nameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password is required`
  String get confirmPasswordRequired {
    return Intl.message(
      'Confirm password is required',
      name: 'confirmPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully!`
  String get accountCreatedSuccess {
    return Intl.message(
      'Account created successfully!',
      name: 'accountCreatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get errorOccurred {
    return Intl.message(
      'An error occurred',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to send a reset link`
  String get enterEmailForReset {
    return Intl.message(
      'Enter your email to send a reset link',
      name: 'enterEmailForReset',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Back to Login`
  String get backToLogin {
    return Intl.message(
      'Back to Login',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Password reset link has been sent to your email`
  String get resetLinkSent {
    return Intl.message(
      'Password reset link has been sent to your email',
      name: 'resetLinkSent',
      desc: '',
      args: [],
    );
  }

  /// `No account registered with this email`
  String get userNotFound {
    return Intl.message(
      'No account registered with this email',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address`
  String get invalidEmail {
    return Intl.message(
      'Invalid email address',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `This account is disabled`
  String get accountDisabled {
    return Intl.message(
      'This account is disabled',
      name: 'accountDisabled',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while sending the reset link`
  String get resetError {
    return Intl.message(
      'An error occurred while sending the reset link',
      name: 'resetError',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred`
  String get unexpectedError {
    return Intl.message(
      'An unexpected error occurred',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter your email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get enterValidEmailPlease {
    return Intl.message(
      'Please enter a valid email address',
      name: 'enterValidEmailPlease',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connected {
    return Intl.message('Connected', name: 'connected', desc: '', args: []);
  }

  /// `Steps`
  String get steps {
    return Intl.message('Steps', name: 'steps', desc: '', args: []);
  }

  /// `Congratulations! Goal Completed`
  String get congratulationsGoalComplete {
    return Intl.message(
      'Congratulations! Goal Completed',
      name: 'congratulationsGoalComplete',
      desc: '',
      args: [],
    );
  }

  /// `Keep Walking`
  String get keepWalking {
    return Intl.message(
      'Keep Walking',
      name: 'keepWalking',
      desc: '',
      args: [],
    );
  }

  /// `of Goal`
  String get ofGoal {
    return Intl.message('of Goal', name: 'ofGoal', desc: '', args: []);
  }

  /// `Conversion Rate`
  String get conversionRate {
    return Intl.message(
      'Conversion Rate',
      name: 'conversionRate',
      desc: '',
      args: [],
    );
  }

  /// `1 point/100 = step`
  String get conversionFormula {
    return Intl.message(
      '1 point/100 = step',
      name: 'conversionFormula',
      desc: '',
      args: [],
    );
  }

  /// `Energy Points Balance`
  String get energyPointsBalance {
    return Intl.message(
      'Energy Points Balance',
      name: 'energyPointsBalance',
      desc: '',
      args: [],
    );
  }

  /// `156 points ✓`
  String get pointsCount {
    return Intl.message(
      '156 points ✓',
      name: 'pointsCount',
      desc: '',
      args: [],
    );
  }

  /// `Charge Now`
  String get chargeNow {
    return Intl.message('Charge Now', name: 'chargeNow', desc: '', args: []);
  }

  /// `Log Activity`
  String get logActivity {
    return Intl.message(
      'Log Activity',
      name: 'logActivity',
      desc: '',
      args: [],
    );
  }

  /// `Great! You've completed {percent}% of your daily goal`
  String achievementMessage(Object percent) {
    return Intl.message(
      'Great! You\'ve completed $percent% of your daily goal',
      name: 'achievementMessage',
      desc: '',
      args: [percent],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Activity`
  String get activity {
    return Intl.message('Activity', name: 'activity', desc: '', args: []);
  }

  /// `Rewards`
  String get rewards {
    return Intl.message('Rewards', name: 'rewards', desc: '', args: []);
  }

  /// `My Account`
  String get myAccount {
    return Intl.message('My Account', name: 'myAccount', desc: '', args: []);
  }

  /// `Great! You've completed`
  String get great {
    return Intl.message(
      'Great! You\'ve completed',
      name: 'great',
      desc: '',
      args: [],
    );
  }

  /// `of your daily goal`
  String get ofYourDailyGoal {
    return Intl.message(
      'of your daily goal',
      name: 'ofYourDailyGoal',
      desc: '',
      args: [],
    );
  }

  /// `Account & Security Management`
  String get accountSecurityManagement {
    return Intl.message(
      'Account & Security Management',
      name: 'accountSecurityManagement',
      desc: '',
      args: [],
    );
  }

  /// `Change name and email`
  String get changeNameAndEmail {
    return Intl.message(
      'Change name and email',
      name: 'changeNameAndEmail',
      desc: '',
      args: [],
    );
  }

  /// `Update current password`
  String get updateCurrentPassword {
    return Intl.message(
      'Update current password',
      name: 'updateCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Activity & Goals Settings`
  String get activityGoalsSettings {
    return Intl.message(
      'Activity & Goals Settings',
      name: 'activityGoalsSettings',
      desc: '',
      args: [],
    );
  }

  /// `Height (cm)`
  String get heightCm {
    return Intl.message('Height (cm)', name: 'heightCm', desc: '', args: []);
  }

  /// `Weight (kg)`
  String get weightKg {
    return Intl.message('Weight (kg)', name: 'weightKg', desc: '', args: []);
  }

  /// `Daily Steps Goal`
  String get dailyStepsGoal {
    return Intl.message(
      'Daily Steps Goal',
      name: 'dailyStepsGoal',
      desc: '',
      args: [],
    );
  }

  /// `Receive alerts and updates`
  String get receiveAlertsAndUpdates {
    return Intl.message(
      'Receive alerts and updates',
      name: 'receiveAlertsAndUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message('Change', name: 'change', desc: '', args: []);
  }

  /// `Language changed to`
  String get languageChangedTo {
    return Intl.message(
      'Language changed to',
      name: 'languageChangedTo',
      desc: '',
      args: [],
    );
  }

  /// `Charging Stations`
  String get chargingStations {
    return Intl.message(
      'Charging Stations',
      name: 'chargingStations',
      desc: '',
      args: [],
    );
  }

  /// `Your Current Location`
  String get yourCurrentLocation {
    return Intl.message(
      'Your Current Location',
      name: 'yourCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Determining your location...`
  String get determiningLocation {
    return Intl.message(
      'Determining your location...',
      name: 'determiningLocation',
      desc: '',
      args: [],
    );
  }

  /// `Location permission denied`
  String get locationPermissionDenied {
    return Intl.message(
      'Location permission denied',
      name: 'locationPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Location permission permanently denied`
  String get locationPermissionPermanentlyDenied {
    return Intl.message(
      'Location permission permanently denied',
      name: 'locationPermissionPermanentlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Location error: {error}`
  String locationError(Object error) {
    return Intl.message(
      'Location error: $error',
      name: 'locationError',
      desc: '',
      args: [error],
    );
  }

  /// `Converting coordinates to address...`
  String get convertingCoordinates {
    return Intl.message(
      'Converting coordinates to address...',
      name: 'convertingCoordinates',
      desc: '',
      args: [],
    );
  }

  /// `No nearby address found`
  String get addressNotFound {
    return Intl.message(
      'No nearby address found',
      name: 'addressNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Error getting address`
  String get addressError {
    return Intl.message(
      'Error getting address',
      name: 'addressError',
      desc: '',
      args: [],
    );
  }

  /// `Location determined successfully`
  String get locationSuccess {
    return Intl.message(
      'Location determined successfully',
      name: 'locationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Refresh Location`
  String get refreshLocation {
    return Intl.message(
      'Refresh Location',
      name: 'refreshLocation',
      desc: '',
      args: [],
    );
  }

  /// `Location Permission Required`
  String get locationPermissionRequired {
    return Intl.message(
      'Location Permission Required',
      name: 'locationPermissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please allow the app to access your location to show nearby stations`
  String get locationPermissionMessage {
    return Intl.message(
      'Please allow the app to access your location to show nearby stations',
      name: 'locationPermissionMessage',
      desc: '',
      args: [],
    );
  }

  /// `🚧 Coming Soon`
  String get comingSoon {
    return Intl.message(
      '🚧 Coming Soon',
      name: 'comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Charging stations feature is under development`
  String get featureInDevelopment {
    return Intl.message(
      'Charging stations feature is under development',
      name: 'featureInDevelopment',
      desc: '',
      args: [],
    );
  }

  /// `Soon we will provide you with the nearest charging stations around your current location`
  String get comingSoonDescription {
    return Intl.message(
      'Soon we will provide you with the nearest charging stations around your current location',
      name: 'comingSoonDescription',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming Features:`
  String get upcomingFeatures {
    return Intl.message(
      'Upcoming Features:',
      name: 'upcomingFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Nearby Stations`
  String get nearbyStations {
    return Intl.message(
      'Nearby Stations',
      name: 'nearbyStations',
      desc: '',
      args: [],
    );
  }

  /// `Show stations by distance`
  String get nearbyStationsDesc {
    return Intl.message(
      'Show stations by distance',
      name: 'nearbyStationsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Filters`
  String get advancedFilters {
    return Intl.message(
      'Advanced Filters',
      name: 'advancedFilters',
      desc: '',
      args: [],
    );
  }

  /// `By type, distance, availability`
  String get advancedFiltersDesc {
    return Intl.message(
      'By type, distance, availability',
      name: 'advancedFiltersDesc',
      desc: '',
      args: [],
    );
  }

  /// `Interactive Map`
  String get interactiveMap {
    return Intl.message(
      'Interactive Map',
      name: 'interactiveMap',
      desc: '',
      args: [],
    );
  }

  /// `View stations on map`
  String get interactiveMapDesc {
    return Intl.message(
      'View stations on map',
      name: 'interactiveMapDesc',
      desc: '',
      args: [],
    );
  }

  /// `Navigation Directions`
  String get navigationDirections {
    return Intl.message(
      'Navigation Directions',
      name: 'navigationDirections',
      desc: '',
      args: [],
    );
  }

  /// `Best route to station`
  String get navigationDirectionsDesc {
    return Intl.message(
      'Best route to station',
      name: 'navigationDirectionsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Save the changes`
  String get savethechanges {
    return Intl.message(
      'Save the changes',
      name: 'savethechanges',
      desc: '',
      args: [],
    );
  }

  /// `GrandUs App`
  String get appTitle {
    return Intl.message('GrandUs App', name: 'appTitle', desc: '', args: []);
  }

  /// `Rewards Center`
  String get rewardsCenter {
    return Intl.message(
      'Rewards Center',
      name: 'rewardsCenter',
      desc: '',
      args: [],
    );
  }

  /// `Redeem your points for exclusive rewards`
  String get redeemYourPoints {
    return Intl.message(
      'Redeem your points for exclusive rewards',
      name: 'redeemYourPoints',
      desc: '',
      args: [],
    );
  }

  /// `Available Balance`
  String get availableBalance {
    return Intl.message(
      'Available Balance',
      name: 'availableBalance',
      desc: '',
      args: [],
    );
  }

  /// `points`
  String get points {
    return Intl.message('points', name: 'points', desc: '', args: []);
  }

  /// `Free Charging - 30 min`
  String get freeCharging30min {
    return Intl.message(
      'Free Charging - 30 min',
      name: 'freeCharging30min',
      desc: '',
      args: [],
    );
  }

  /// `Get 30 minutes of free charging`
  String get freeChargingDesc {
    return Intl.message(
      'Get 30 minutes of free charging',
      name: 'freeChargingDesc',
      desc: '',
      args: [],
    );
  }

  /// `10% Trip Discount`
  String get discount10Percent {
    return Intl.message(
      '10% Trip Discount',
      name: 'discount10Percent',
      desc: '',
      args: [],
    );
  }

  /// `Discount coupon valid for one-time use`
  String get discountDesc {
    return Intl.message(
      'Discount coupon valid for one-time use',
      name: 'discountDesc',
      desc: '',
      args: [],
    );
  }

  /// `1GB Internet Package`
  String get internet1GB {
    return Intl.message(
      '1GB Internet Package',
      name: 'internet1GB',
      desc: '',
      args: [],
    );
  }

  /// `Mobile data gift`
  String get internetDesc {
    return Intl.message(
      'Mobile data gift',
      name: 'internetDesc',
      desc: '',
      args: [],
    );
  }

  /// `Free Car Wash`
  String get freeCarWash {
    return Intl.message(
      'Free Car Wash',
      name: 'freeCarWash',
      desc: '',
      args: [],
    );
  }

  /// `Voucher provided by our partners`
  String get carWashDesc {
    return Intl.message(
      'Voucher provided by our partners',
      name: 'carWashDesc',
      desc: '',
      args: [],
    );
  }

  /// `Redeem`
  String get redeem {
    return Intl.message('Redeem', name: 'redeem', desc: '', args: []);
  }

  /// `Confirm Redemption`
  String get confirmRedeem {
    return Intl.message(
      'Confirm Redemption',
      name: 'confirmRedeem',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to redeem {points} points for {reward}?`
  String redeemConfirmation(Object points, Object reward) {
    return Intl.message(
      'Are you sure you want to redeem $points points for $reward?',
      name: 'redeemConfirmation',
      desc: '',
      args: [points, reward],
    );
  }

  /// `Reward "{reward}" redeemed successfully`
  String redeemSuccess(Object reward) {
    return Intl.message(
      'Reward "$reward" redeemed successfully',
      name: 'redeemSuccess',
      desc: '',
      args: [reward],
    );
  }

  /// `Insufficient Points`
  String get insufficientPoints {
    return Intl.message(
      'Insufficient Points',
      name: 'insufficientPoints',
      desc: '',
      args: [],
    );
  }

  /// `You don't have enough points to redeem this reward. You need {points} more points.`
  String insufficientPointsMsg(Object points) {
    return Intl.message(
      'You don\'t have enough points to redeem this reward. You need $points more points.',
      name: 'insufficientPointsMsg',
      desc: '',
      args: [points],
    );
  }

  /// `Activity Log & Statistics`
  String get activityLogTitle {
    return Intl.message(
      'Activity Log & Statistics',
      name: 'activityLogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Track your daily progress and achievements`
  String get activityLogSubtitle {
    return Intl.message(
      'Track your daily progress and achievements',
      name: 'activityLogSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Total\nSteps`
  String get totalSteps {
    return Intl.message('Total\nSteps', name: 'totalSteps', desc: '', args: []);
  }

  /// `Points Earned`
  String get pointsEarned {
    return Intl.message(
      'Points Earned',
      name: 'pointsEarned',
      desc: '',
      args: [],
    );
  }

  /// `Points Spent`
  String get pointsSpent {
    return Intl.message(
      'Points Spent',
      name: 'pointsSpent',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get daily {
    return Intl.message('Daily', name: 'daily', desc: '', args: []);
  }

  /// `Weekly`
  String get weekly {
    return Intl.message('Weekly', name: 'weekly', desc: '', args: []);
  }

  /// `Monthly`
  String get monthly {
    return Intl.message('Monthly', name: 'monthly', desc: '', args: []);
  }

  /// `Activity Progress`
  String get activityProgress {
    return Intl.message(
      'Activity Progress',
      name: 'activityProgress',
      desc: '',
      args: [],
    );
  }

  /// `Detailed Transaction Log`
  String get transactionLog {
    return Intl.message(
      'Detailed Transaction Log',
      name: 'transactionLog',
      desc: '',
      args: [],
    );
  }

  /// `point`
  String get pointUnit {
    return Intl.message('point', name: 'pointUnit', desc: '', args: []);
  }

  /// `Converted {count} steps`
  String txConvertedSteps(Object count) {
    return Intl.message(
      'Converted $count steps',
      name: 'txConvertedSteps',
      desc: '',
      args: [count],
    );
  }

  /// `Charged at Al-Rawabi Park station`
  String get txChargingStation {
    return Intl.message(
      'Charged at Al-Rawabi Park station',
      name: 'txChargingStation',
      desc: '',
      args: [],
    );
  }

  /// `Redeemed reward - Charging discount`
  String get txRewardRedemption {
    return Intl.message(
      'Redeemed reward - Charging discount',
      name: 'txRewardRedemption',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get chartLabelToday {
    return Intl.message('Today', name: 'chartLabelToday', desc: '', args: []);
  }

  /// `Wed`
  String get chartLabelWednesday {
    return Intl.message('Wed', name: 'chartLabelWednesday', desc: '', args: []);
  }

  /// `Mon`
  String get chartLabelMonday {
    return Intl.message('Mon', name: 'chartLabelMonday', desc: '', args: []);
  }

  /// `Sun`
  String get chartLabelSunday {
    return Intl.message('Sun', name: 'chartLabelSunday', desc: '', args: []);
  }

  /// `Sat`
  String get chartLabelSaturday {
    return Intl.message('Sat', name: 'chartLabelSaturday', desc: '', args: []);
  }

  /// `Fri`
  String get chartLabelFriday {
    return Intl.message('Fri', name: 'chartLabelFriday', desc: '', args: []);
  }

  /// `Thu`
  String get chartLabelThursday {
    return Intl.message('Thu', name: 'chartLabelThursday', desc: '', args: []);
  }

  /// `Week {number}`
  String chartLabelWeek(Object number) {
    return Intl.message(
      'Week $number',
      name: 'chartLabelWeek',
      desc: '',
      args: [number],
    );
  }

  /// `Jan`
  String get chartLabelJanuary {
    return Intl.message('Jan', name: 'chartLabelJanuary', desc: '', args: []);
  }

  /// `Feb`
  String get chartLabelFebruary {
    return Intl.message('Feb', name: 'chartLabelFebruary', desc: '', args: []);
  }

  /// `Mar`
  String get chartLabelMarch {
    return Intl.message('Mar', name: 'chartLabelMarch', desc: '', args: []);
  }

  /// `Apr`
  String get chartLabelApril {
    return Intl.message('Apr', name: 'chartLabelApril', desc: '', args: []);
  }

  /// `May`
  String get chartLabelMay {
    return Intl.message('May', name: 'chartLabelMay', desc: '', args: []);
  }

  /// `Jun`
  String get chartLabelJune {
    return Intl.message('Jun', name: 'chartLabelJune', desc: '', args: []);
  }

  /// `Jul`
  String get chartLabelJuly {
    return Intl.message('Jul', name: 'chartLabelJuly', desc: '', args: []);
  }

  /// `An error occurred during redemption`
  String get redeemError {
    return Intl.message(
      'An error occurred during redemption',
      name: 'redeemError',
      desc: '',
      args: [],
    );
  }

  /// `You need {points} points for this reward`
  String needPoints(Object points) {
    return Intl.message(
      'You need $points points for this reward',
      name: 'needPoints',
      desc: '',
      args: [points],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Replace First`
  String get replaceFirst {
    return Intl.message(
      'Replace First',
      name: 'replaceFirst',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
