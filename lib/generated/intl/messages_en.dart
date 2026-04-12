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
    "app_offline": MessageLookupByLibrary.simpleMessage(
      "Does the app work offline?",
    ),
    "app_offline_answer": MessageLookupByLibrary.simpleMessage(
      "Some features work offline, but an internet connection is required to sync points and data.",
    ),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "availableBalance": MessageLookupByLibrary.simpleMessage(
      "Available Balance",
    ),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Back to Login"),
    "batteryChargingComplete": MessageLookupByLibrary.simpleMessage(
      "Phone charging completed",
    ),
    "batteryFull": MessageLookupByLibrary.simpleMessage(
      "Phone is fully charged",
    ),
    "can_points_be_converted": MessageLookupByLibrary.simpleMessage(
      "Can points be converted into real energy?",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cannotChargeBatteryFull": MessageLookupByLibrary.simpleMessage(
      "Cannot charge because the phone is at 100%",
    ),
    "carWashDesc": MessageLookupByLibrary.simpleMessage(
      "Voucher provided by our partners",
    ),
    "change": MessageLookupByLibrary.simpleMessage("Change"),
    "changeNameAndEmail": MessageLookupByLibrary.simpleMessage(
      "Change name and email",
    ),
    "changePassword": MessageLookupByLibrary.simpleMessage("Change Password"),
    "chargeFailedPoints": MessageLookupByLibrary.simpleMessage(
      "Charging completed but failed to deduct points. Please contact support.",
    ),
    "chargeNow": MessageLookupByLibrary.simpleMessage("Charge Now"),
    "charged": MessageLookupByLibrary.simpleMessage("Charged"),
    "charging": MessageLookupByLibrary.simpleMessage("Charging..."),
    "chargingCompleted": MessageLookupByLibrary.simpleMessage(
      "Charging Completed",
    ),
    "chargingStations": MessageLookupByLibrary.simpleMessage(
      "Charging Stations",
    ),
    "chargingStopped": MessageLookupByLibrary.simpleMessage("Charging Stopped"),
    "chargingStoppedMessage": MessageLookupByLibrary.simpleMessage(
      "Charging stopped.",
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
    "confirmRedeemEnd": MessageLookupByLibrary.simpleMessage(" points?"),
    "congratulationsGoalComplete": MessageLookupByLibrary.simpleMessage(
      "Congratulations! Goal Completed",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "contact_support": MessageLookupByLibrary.simpleMessage("Contact Support"),
    "conversionFormula": MessageLookupByLibrary.simpleMessage(
      "1 point/100 = step",
    ),
    "conversionRate": MessageLookupByLibrary.simpleMessage("Conversion Rate"),
    "convertingCoordinates": MessageLookupByLibrary.simpleMessage(
      "Converting coordinates to address...",
    ),
    "copied": MessageLookupByLibrary.simpleMessage("Copied!"),
    "copy": MessageLookupByLibrary.simpleMessage("Copy"),
    "coupon50": MessageLookupByLibrary.simpleMessage("50 SAR Coupon"),
    "coupon50Desc": MessageLookupByLibrary.simpleMessage(
      "50 SAR discount coupon",
    ),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "currentPassword": MessageLookupByLibrary.simpleMessage("Current Password"),
    "daily": MessageLookupByLibrary.simpleMessage("Daily"),
    "dailyGoal": MessageLookupByLibrary.simpleMessage("Daily Goal"),
    "dailySteps": MessageLookupByLibrary.simpleMessage("Daily Steps Goal"),
    "dailyStepsGoal": MessageLookupByLibrary.simpleMessage("Daily Steps Goal"),
    "data_security": MessageLookupByLibrary.simpleMessage("Is my data secure?"),
    "data_security_answer": MessageLookupByLibrary.simpleMessage(
      "Yes, your data is protected using high-security technologies to ensure privacy.",
    ),
    "data_security_content": MessageLookupByLibrary.simpleMessage(
      "We use advanced security measures to protect your data including encryption and two-factor authentication. We are committed to maintaining the confidentiality and security of your information.",
    ),
    "data_security_policy": MessageLookupByLibrary.simpleMessage(
      "Data Security",
    ),
    "deductPointsError": MessageLookupByLibrary.simpleMessage(
      "An error occurred while deducting points. Please try again.",
    ),
    "deductPointsFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to deduct points",
    ),
    "determiningLocation": MessageLookupByLibrary.simpleMessage(
      "Determining your location...",
    ),
    "discount10": MessageLookupByLibrary.simpleMessage(
      "10% discount on charging",
    ),
    "discount10Desc": MessageLookupByLibrary.simpleMessage(
      "10% discount on any charging process",
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
    "faq": MessageLookupByLibrary.simpleMessage("Frequently Asked Questions"),
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
    "freeShipping": MessageLookupByLibrary.simpleMessage("Free Shipping"),
    "freeShippingDesc": MessageLookupByLibrary.simpleMessage(
      "Free shipping for one time",
    ),
    "great": MessageLookupByLibrary.simpleMessage("Great! You\'ve completed"),
    "height": MessageLookupByLibrary.simpleMessage("Height (cm)"),
    "heightCm": MessageLookupByLibrary.simpleMessage("Height (cm)"),
    "helpSupport": MessageLookupByLibrary.simpleMessage("Help & Support"),
    "help_support": MessageLookupByLibrary.simpleMessage("Help & Support"),
    "help_tab": MessageLookupByLibrary.simpleMessage("Help"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "how_are_points_calculated": MessageLookupByLibrary.simpleMessage(
      "How are points calculated?",
    ),
    "how_to_use_points": MessageLookupByLibrary.simpleMessage(
      "How do I use points to charge my device?",
    ),
    "information_collection": MessageLookupByLibrary.simpleMessage(
      "Information Collection",
    ),
    "information_collection_content": MessageLookupByLibrary.simpleMessage(
      "We collect the following information: name, email, height, weight, daily step count, and energy points. This information is necessary to provide an accurate and personalized physical activity tracking service.",
    ),
    "information_sharing": MessageLookupByLibrary.simpleMessage(
      "Information Sharing",
    ),
    "information_sharing_content": MessageLookupByLibrary.simpleMessage(
      "We do not share your personal information with third parties without your explicit consent or when required by law. All your data remains secure and protected.",
    ),
    "information_usage": MessageLookupByLibrary.simpleMessage(
      "Use of Information",
    ),
    "information_usage_content": MessageLookupByLibrary.simpleMessage(
      "We use your information to personalize your experience, improve app performance, calculate energy points, and provide personalized recommendations to help you achieve your health goals.",
    ),
    "insufficientPoints": MessageLookupByLibrary.simpleMessage(
      "Insufficient Points",
    ),
    "insufficientPointsMessage": MessageLookupByLibrary.simpleMessage(
      "Your current balance: points\nWalk to earn points first",
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
    "last_update": MessageLookupByLibrary.simpleMessage("Last Updated"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
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
    "max_points_answer": MessageLookupByLibrary.simpleMessage(
      "Yes, there is a daily maximum for points to ensure fair energy distribution among users.",
    ),
    "max_points_per_day": MessageLookupByLibrary.simpleMessage(
      "Is there a daily maximum for points?",
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
    "phone": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "phoneBattery": MessageLookupByLibrary.simpleMessage("Phone Battery"),
    "phoneChargedSuccess": MessageLookupByLibrary.simpleMessage(
      "Phone charged successfully",
    ),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "pointUnit": MessageLookupByLibrary.simpleMessage("point"),
    "points": MessageLookupByLibrary.simpleMessage("points"),
    "pointsCount": MessageLookupByLibrary.simpleMessage("156 points ✓"),
    "pointsEarned": MessageLookupByLibrary.simpleMessage("Points Earned"),
    "pointsRequired": MessageLookupByLibrary.simpleMessage("Points Required"),
    "pointsSpent": MessageLookupByLibrary.simpleMessage("Points Spent"),
    "pointsUsed": MessageLookupByLibrary.simpleMessage("Points Used"),
    "pointsUsedLabel": MessageLookupByLibrary.simpleMessage("Points used:"),
    "points_calculation_answer": MessageLookupByLibrary.simpleMessage(
      "Points are calculated based on the number of steps you take daily, where every 100 steps is converted into 1 energy point within the app.",
    ),
    "points_conversion_answer": MessageLookupByLibrary.simpleMessage(
      "Yes, points are linked to the energy generated from smart tiles and can be used to charge devices or light up areas.",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage(
      "Privacy & Terms of Use",
    ),
    "privacy_policy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "privacy_tab": MessageLookupByLibrary.simpleMessage("Privacy"),
    "profileHeader": MessageLookupByLibrary.simpleMessage("Profile"),
    "readyToCharge": MessageLookupByLibrary.simpleMessage("Ready to Charge"),
    "reason": MessageLookupByLibrary.simpleMessage("Reason:"),
    "receiveAlertsAndUpdates": MessageLookupByLibrary.simpleMessage(
      "Receive alerts and updates",
    ),
    "redeem": MessageLookupByLibrary.simpleMessage("Redeem"),
    "redeemConfirmation": m5,
    "redeemError": MessageLookupByLibrary.simpleMessage(
      "An error occurred during redemption",
    ),
    "redeemFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to redeem reward. Check your balance.",
    ),
    "redeemReward": MessageLookupByLibrary.simpleMessage("Redeem Reward"),
    "redeemSuccess": m6,
    "redeemSuccessEnd": MessageLookupByLibrary.simpleMessage("!"),
    "redeemYourPoints": MessageLookupByLibrary.simpleMessage(
      "Redeem your points for exclusive rewards",
    ),
    "refreshLocation": MessageLookupByLibrary.simpleMessage("Refresh Location"),
    "remainingPoints": MessageLookupByLibrary.simpleMessage("Remaining Points"),
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
    "startCharging": MessageLookupByLibrary.simpleMessage("Start Charging"),
    "steps": MessageLookupByLibrary.simpleMessage("Steps"),
    "steps_not_counted": MessageLookupByLibrary.simpleMessage(
      "What should I do if my steps are not counted?",
    ),
    "steps_not_counted_answer": MessageLookupByLibrary.simpleMessage(
      "Make sure you have enabled motion tracking permissions on your device. If the problem persists, you can contact support.",
    ),
    "stopCharging": MessageLookupByLibrary.simpleMessage("Stop Charging"),
    "supportPolicies": MessageLookupByLibrary.simpleMessage(
      "Support & Policies",
    ),
    "support_email": MessageLookupByLibrary.simpleMessage(
      "Vion.project2026@gmail.com",
    ),
    "support_phone": MessageLookupByLibrary.simpleMessage("966xxxxxxxx+"),
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
    "use_points_answer": MessageLookupByLibrary.simpleMessage(
      "You can use points by selecting the charging option within the app and connecting your device to the smart tile area.",
    ),
    "userNotFound": MessageLookupByLibrary.simpleMessage(
      "No account registered with this email",
    ),
    "walkToEarnPoints": MessageLookupByLibrary.simpleMessage(
      "Walk to earn points first",
    ),
    "weekly": MessageLookupByLibrary.simpleMessage("Weekly"),
    "weight": MessageLookupByLibrary.simpleMessage("Weight (kg)"),
    "weightKg": MessageLookupByLibrary.simpleMessage("Weight (kg)"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back"),
    "yourBalance": MessageLookupByLibrary.simpleMessage("Your Balance"),
    "yourCurrentLocation": MessageLookupByLibrary.simpleMessage(
      "Your Current Location",
    ),
    "your_rights": MessageLookupByLibrary.simpleMessage("Your Rights"),
    "your_rights_content": MessageLookupByLibrary.simpleMessage(
      "You have the right to access, correct, or delete your personal data at any time. You can contact the support team to request this.",
    ),
  };
}
