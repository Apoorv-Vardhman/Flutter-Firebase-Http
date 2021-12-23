class OTPArguments {
  final String mobile;
  final String? verificationId;
  final String? sessionDetails;
  final int? patientId;
  final String? verifiedType;
  final String? email;

  OTPArguments(this.mobile, this.verificationId,
      {this.sessionDetails, this.patientId, this.verifiedType, this.email});
}