class OnboardingClass {
  final String title;
  final String discription;
  final String image;
  OnboardingClass({
    required this.title,
    required this.discription,
    required this.image,
  });
}

List<OnboardingClass> contents = [
  OnboardingClass(
      title: "Welcome to Al-Iman!",
      image: 'assets/images/logo.png',
      discription: ""),
  OnboardingClass(
      title: "Stay Alert, Stay Secure!",
      image: 'assets/images/alert.png',
      discription:
          "With Al-Iman, your safety is our top priority. Receive instant alerts whenever unauthorized individuals enter your premises. Our vigilant system ensures that you're always informed and empowered to take necessary actions to safeguard your space.")
];
