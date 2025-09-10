import 'package:email_validator/email_validator.dart';
import 'package:password_strength/password_strength.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class Validators {
  Validators._();

  static String? cardNumber({
    String? value,
    String? errorMsg,
    String? emptyMsg,
  }) {
    // Validate less that 13 digits +3 white spaces

    if (value == null || value.trim().isEmpty) {
      return emptyMsg ?? 'Please enter your card number';
    }

    if (value.length < 16) {
      return errorMsg ?? 'Enter a valid card number';
    }
    return null;
  }

  static String? expiryDate({
    String? value,
    String? errorMsg,
    String? emptyMsg,
  }) {
    if (value == null || value.trim().isEmpty) {
      return emptyMsg ?? 'Please enter your expiry date';
    }

    final DateTime now = DateTime.now();
    final List<String> date = value.split(RegExp(r'/'));

    // Must have exactly 2 parts: MM and YY or YYYY
    if (date.length != 2) return errorMsg ?? 'Enter a valid expiry date';

    final int month = int.tryParse(date.first) ?? 0;
    String yearPart = date.last;

    // Convert YY → YYYY (assuming 2000s)
    if (yearPart.length == 2) {
      yearPart = '20$yearPart';
    }

    final int year = int.tryParse(yearPart) ?? 0;

    // Invalid month/year
    if (month < 1 || month > 12 || year < 1000) {
      return errorMsg ?? 'Enter a valid expiry date';
    }

    // Get last day of the month
    final int lastDayOfMonth = month < 12
        ? DateTime(year, month + 1, 0).day
        : DateTime(year + 1, 1, 0).day;

    final DateTime cardDate = DateTime(
      year,
      month,
      lastDayOfMonth,
      23,
      59,
      59,
      999,
    );

    // If expired
    if (cardDate.isBefore(now)) {
      return errorMsg ?? 'Your card is expired';
    }

    return null;
  }

  static String? cvv({String? value, String? errorMsg, String? emptyMsg}) {
    if (value == null || value.trim().isEmpty) {
      return emptyMsg ?? 'Please enter your CVV';
    }

    if (value.length < 3) {
      return errorMsg ?? 'Enter a valid CVV';
    }

    return null;
  }

  static String? email({String? value, String? errorMsg, String? emptyMsg}) {
    if (value == null || value.trim().isEmpty) {
      return emptyMsg ?? 'Please enter your email';
    }
    if (!EmailValidator.validate(value)) {
      return errorMsg ?? 'Enter a valid email';
    }
    return null;
  }

  static String? phone({
    String? value,
    String? errorMsg,
    String? emptyMsg,
    String country = 'EG',
  }) {
    if (value == null || value.trim().isEmpty) {
      return emptyMsg ?? 'Please enter your phone number';
    }

    try {
      PhoneNumber phoneNumber;

      if (value.trim().startsWith('+')) {
        phoneNumber = PhoneNumber.parse(value.trim());
      } else {
        final isoCode = IsoCode.values.firstWhere(
          (e) => e.name.toUpperCase() == country.toUpperCase(),
          orElse: () => IsoCode.EG, // fallback
        );
        phoneNumber = PhoneNumber.parse(value.trim(), callerCountry: isoCode);
      }

      if (!phoneNumber.isValid(type: PhoneNumberType.mobile)) {
        return errorMsg ?? 'Invalid mobile phone number';
      }

      return null; // valid
    } catch (e) {
      return errorMsg ?? 'Invalid phone number format';
    }
  }

  static String? password({
    String? value,
    String? warningPassLengthMsg,
    String? emptyMsg,
    String? warningPassStrengthMsg,
    int? passwordLength,
  }) {
    int length = passwordLength ?? 6;

    if (value == null || value.trim().isEmpty) {
      return emptyMsg ?? 'Please enter your password';
    }
    if (value.length < length) {
      return warningPassLengthMsg ??
          'Password must be at least $length characters';
    }

    double strength = estimatePasswordStrength(value);
    if (strength < 0.3) return warningPassStrengthMsg ?? 'Password is too weak';

    return null;
  }

  static String? name({String? value, String? emptyMsg}) {
    if (value == null || value.trim().isEmpty) {
      return emptyMsg ?? 'Please enter your name';
    }
    return null;
  }
}
