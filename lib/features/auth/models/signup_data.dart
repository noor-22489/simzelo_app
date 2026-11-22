/// Registration payload passed from Step 1 to Step 2
class SignUpData {
  final String fullName;
  final String mobileNumber;
  final String currentNetwork;
  final String email;
  final String password;

  const SignUpData({
    this.fullName = '',
    this.mobileNumber = '',
    this.currentNetwork = '',
    this.email = '',
    this.password = '',
  });

  SignUpData copyWith({
    String? fullName,
    String? mobileNumber,
    String? currentNetwork,
    String? email,
    String? password,
  }) {
    return SignUpData(
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      currentNetwork: currentNetwork ?? this.currentNetwork,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
