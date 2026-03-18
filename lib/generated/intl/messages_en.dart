// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(percent) =>
      "Great! You\'ve completed ${percent}% of your daily goal";

  static String m1(number) => "Week ${number}";

  static String m2(points) =>
      "You don\'t have enough points to redeem this reward. You need ${points} more points.";

  static String m3(error) => "Location error: ${error}";

  static String m4(points) => "You need ${points} points for this reward";

  static String m5(points, reward) =>
      "Are you sure you want to redeem ${points} points for ${reward}?";

  static String m6(reward) => "Reward \"${reward}\" redeemed successfully";

  static String m7(count) => "Converted ${count} steps";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("My Account"),
    "accountCreatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Account created successfully!",
    ),
    "accountDisabled": MessageLookupByLibrary.simpleMessage(
      "This account is disabled",
    ),
    "accountSecurityManagement": MessageLookupByLibrary.simpleMessage(
      "Account & Security Management",
    ),
    "achievementMessage": m0,
    "activity": MessageLookupByLibrary.simpleMessage("Activity"),
    "activityGoals": MessageLookupByLibrary.simpleMessage(
      "Activity & Goals Settings",
    ),
    "activityGoalsSettings": MessageLookupByLibrary.simpleMessage(
      "Activity & Goals Settings",
    ),
    "activityLogSubtitle": MessageLookupByLibrary.simpleMessage(
      "Track your daily progress and achievements",
    ),
    "activityLogTitle": MessageLookupByLibrary.simpleMessage(
      "Activity Log & Statistics",
    ),
    "activityProgress": MessageLookupByLibrary.simpleMessage(
      "Activity Progress",
    ),
    "addressError": MessageLookupByLibrary.simpleMessage(
      "Error getting address",
    ),
    "addressNotFound": MessageLookupByLibrary.simpleMessage(
      "No nearby address found",
    ),
    "advancedFilters": MessageLookupByLibrary.simpleMessage("Advanced Filters"),
    "advancedFiltersDesc": MessageLookupByLibrary.simpleMessage(
      "By type, distance, availability",
    ),
    "appSettings": MessageLookupByLibrary.simpleMessage("App Settings"),
    "appTitle": MessageLookupByLibrary.simpleMessage("GrandUs App"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "availableBalance": MessageLookupByLibrary.simpleMessage(
      "Available Balance",
    ),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Back to Login"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "carWashDesc": MessageLookupByLibrary.simpleMessage(
      "Voucher provided by our partners",
    ),
    "change": MessageLookupByLibrary.simpleMessage("Change"),
    "changeNameAndEmail": MessageLookupByLibrary.simpleMessage(
      "Change name and email",
    ),
    "changePassword": MessageLookupByLibrary.simpleMessage("Change Password"),
    "chargeNow": MessageLookupByLibrary.simpleMessage("Charge Now"),
    "chargingStations": MessageLookupByLibrary.simpleMessage(
      "Charging Stations",
    ),
    "chartLabelApril": MessageLookupByLibrary.simpleMessage("Apr"),
    "chartLabelFebruary": MessageLookupByLibrary.simpleMessage("Feb"),
    "chartLabelFriday": MessageLookupByLibrary.simpleMessage("Fri"),
    "chartLabelJanuary": MessageLookupByLibrary.simpleMessage("Jan"),
    "chartLabelJuly": MessageLookupByLibrary.simpleMessage("Jul"),
    "chartLabelJune": MessageLookupByLibrary.simpleMessage("Jun"),
    "chartLabelMarch": MessageLookupByLibrary.simpleMessage("Mar"),
    "chartLabelMay": MessageLookupByLibrary.simpleMessage("May"),
    "chartLabelMonday": MessageLookupByLibrary.simpleMessage("Mon"),
    "chartLabelSaturday": MessageLookupByLibrary.simpleMessage("Sat"),
    "chartLabelSunday": MessageLookupByLibrary.simpleMessage("Sun"),
    "chartLabelThursday": MessageLookupByLibrary.simpleMessage("Thu"),
    "chartLabelToday": MessageLookupByLibrary.simpleMessage("Today"),
    "chartLabelWednesday": MessageLookupByLibrary.simpleMessage("Wed"),
    "chartLabelWeek": m1,
    "chooseLanguage": MessageLookupByLibrary.simpleMessage("Choose Language"),
    "comingSoon": MessageLookupByLibrary.simpleMessage("🚧 Coming Soon"),
    "comingSoonDescription": MessageLookupByLibrary.simpleMessage(
      "Soon we will provide you with the nearest charging stations around your current location",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "confirmPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Confirm password is required",
    ),
    "confirmRedeem": MessageLookupByLibrary.simpleMessage("Confirm Redemption"),
    "congratulationsGoalComplete": MessageLookupByLibrary.simpleMessage(
      "Congratulations! Goal Completed",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "conversionFormula": MessageLookupByLibrary.simpleMessage(
      "1 point/100 = step",
    ),
    "conversionRate": MessageLookupByLibrary.simpleMessage("Conversion Rate"),
    "convertingCoordinates": MessageLookupByLibrary.simpleMessage(
      "Converting coordinates to address...",
    ),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "currentPassword": MessageLookupByLibrary.simpleMessage("Current Password"),
    "daily": MessageLookupByLibrary.simpleMessage("Daily"),
    "dailySteps": MessageLookupByLibrary.simpleMessage("Daily Steps Goal"),
    "dailyStepsGoal": MessageLookupByLibrary.simpleMessage("Daily Steps Goal"),
    "determiningLocation": MessageLookupByLibrary.simpleMessage(
      "Determining your location...",
    ),
    "discount10Percent": MessageLookupByLibrary.simpleMessage(
      "10% Trip Discount",
    ),
    "discountDesc": MessageLookupByLibrary.simpleMessage(
      "Discount coupon valid for one-time use",
    ),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailOrUsername": MessageLookupByLibrary.simpleMessage(
      "Email or Username",
    ),
    "emailRequired": MessageLookupByLibrary.simpleMessage("Email is required"),
    "energyPointsBalance": MessageLookupByLibrary.simpleMessage(
      "Energy Points Balance",
    ),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterEmailForReset": MessageLookupByLibrary.simpleMessage(
      "Enter your email to send a reset link",
    ),
    "enterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
    "enterValidEmailPlease": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "errorOccurred": MessageLookupByLibrary.simpleMessage("An error occurred"),
    "featureInDevelopment": MessageLookupByLibrary.simpleMessage(
      "Charging stations feature is under development",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "freeCarWash": MessageLookupByLibrary.simpleMessage("Free Car Wash"),
    "freeCharging30min": MessageLookupByLibrary.simpleMessage(
      "Free Charging - 30 min",
    ),
    "freeChargingDesc": MessageLookupByLibrary.simpleMessage(
      "Get 30 minutes of free charging",
    ),
    "great": MessageLookupByLibrary.simpleMessage("Great! You\'ve completed"),
    "height": MessageLookupByLibrary.simpleMessage("Height (cm)"),
    "heightCm": MessageLookupByLibrary.simpleMessage("Height (cm)"),
    "helpSupport": MessageLookupByLibrary.simpleMessage("Help & Support"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "insufficientPoints": MessageLookupByLibrary.simpleMessage(
      "Insufficient Points",
    ),
    "insufficientPointsMsg": m2,
    "interactiveMap": MessageLookupByLibrary.simpleMessage("Interactive Map"),
    "interactiveMapDesc": MessageLookupByLibrary.simpleMessage(
      "View stations on map",
    ),
    "internet1GB": MessageLookupByLibrary.simpleMessage("1GB Internet Package"),
    "internetDesc": MessageLookupByLibrary.simpleMessage("Mobile data gift"),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "Invalid email address",
    ),
    "join": MessageLookupByLibrary.simpleMessage("Join"),
    "joinVion": MessageLookupByLibrary.simpleMessage("Join VION"),
    "keepWalking": MessageLookupByLibrary.simpleMessage("Keep Walking"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "languageChangedTo": MessageLookupByLibrary.simpleMessage(
      "Language changed to",
    ),
    "locationError": m3,
    "locationPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Location permission denied",
    ),
    "locationPermissionMessage": MessageLookupByLibrary.simpleMessage(
      "Please allow the app to access your location to show nearby stations",
    ),
    "locationPermissionPermanentlyDenied": MessageLookupByLibrary.simpleMessage(
      "Location permission permanently denied",
    ),
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Location Permission Required",
    ),
    "locationSuccess": MessageLookupByLibrary.simpleMessage(
      "Location determined successfully",
    ),
    "logActivity": MessageLookupByLibrary.simpleMessage("Log Activity"),
    "login": MessageLookupByLibrary.simpleMessage("Sign In"),
    "loginToContinue": MessageLookupByLibrary.simpleMessage(
      "Sign in to continue",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to logout?",
    ),
    "monthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "myAccount": MessageLookupByLibrary.simpleMessage("My Account"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameRequired": MessageLookupByLibrary.simpleMessage("Name is required"),
    "navigationDirections": MessageLookupByLibrary.simpleMessage(
      "Navigation Directions",
    ),
    "navigationDirectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Best route to station",
    ),
    "nearbyStations": MessageLookupByLibrary.simpleMessage("Nearby Stations"),
    "nearbyStationsDesc": MessageLookupByLibrary.simpleMessage(
      "Show stations by distance",
    ),
    "needPoints": m4,
    "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
    "noAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? ",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "ofGoal": MessageLookupByLibrary.simpleMessage("of Goal"),
    "ofYourDailyGoal": MessageLookupByLibrary.simpleMessage(
      "of your daily goal",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "passwordRequired": MessageLookupByLibrary.simpleMessage(
      "Password is required",
    ),
    "passwordsNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "pointUnit": MessageLookupByLibrary.simpleMessage("point"),
    "points": MessageLookupByLibrary.simpleMessage("points"),
    "pointsCount": MessageLookupByLibrary.simpleMessage("156 points ✓"),
    "pointsEarned": MessageLookupByLibrary.simpleMessage("Points Earned"),
    "pointsSpent": MessageLookupByLibrary.simpleMessage("Points Spent"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage(
      "Privacy & Terms of Use",
    ),
    "profileHeader": MessageLookupByLibrary.simpleMessage("Profile"),
    "receiveAlertsAndUpdates": MessageLookupByLibrary.simpleMessage(
      "Receive alerts and updates",
    ),
    "redeem": MessageLookupByLibrary.simpleMessage("Redeem"),
    "redeemConfirmation": m5,
    "redeemError": MessageLookupByLibrary.simpleMessage(
      "An error occurred during redemption",
    ),
    "redeemSuccess": m6,
    "redeemYourPoints": MessageLookupByLibrary.simpleMessage(
      "Redeem your points for exclusive rewards",
    ),
    "refreshLocation": MessageLookupByLibrary.simpleMessage("Refresh Location"),
    "replaceFirst": MessageLookupByLibrary.simpleMessage("Replace First"),
    "resetError": MessageLookupByLibrary.simpleMessage(
      "An error occurred while sending the reset link",
    ),
    "resetLinkSent": MessageLookupByLibrary.simpleMessage(
      "Password reset link has been sent to your email",
    ),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "rewards": MessageLookupByLibrary.simpleMessage("Rewards"),
    "rewardsCenter": MessageLookupByLibrary.simpleMessage("Rewards Center"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "savethechanges": MessageLookupByLibrary.simpleMessage("Save the changes"),
    "sendResetLink": MessageLookupByLibrary.simpleMessage("Send Reset Link"),
    "steps": MessageLookupByLibrary.simpleMessage("Steps"),
    "supportPolicies": MessageLookupByLibrary.simpleMessage(
      "Support & Policies",
    ),
    "totalEnergy": MessageLookupByLibrary.simpleMessage("Total Energy"),
    "totalSteps": MessageLookupByLibrary.simpleMessage("Total\nSteps"),
    "transactionLog": MessageLookupByLibrary.simpleMessage(
      "Detailed Transaction Log",
    ),
    "txChargingStation": MessageLookupByLibrary.simpleMessage(
      "Charged at Al-Rawabi Park station",
    ),
    "txConvertedSteps": m7,
    "txRewardRedemption": MessageLookupByLibrary.simpleMessage(
      "Redeemed reward - Charging discount",
    ),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred",
    ),
    "upcomingFeatures": MessageLookupByLibrary.simpleMessage(
      "Upcoming Features:",
    ),
    "updateCurrentPassword": MessageLookupByLibrary.simpleMessage(
      "Update current password",
    ),
    "userNotFound": MessageLookupByLibrary.simpleMessage(
      "No account registered with this email",
    ),
    "weekly": MessageLookupByLibrary.simpleMessage("Weekly"),
    "weight": MessageLookupByLibrary.simpleMessage("Weight (kg)"),
    "weightKg": MessageLookupByLibrary.simpleMessage("Weight (kg)"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back"),
    "yourCurrentLocation": MessageLookupByLibrary.simpleMessage(
      "Your Current Location",
    ),
  };
}
