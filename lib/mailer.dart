import 'package:url_launcher/url_launcher.dart';

class SendGridUtil {

  Future launchURL({String toMailId, String nom, String password}) async {
    var url = 'mailto:$toMailId?subject=Votre compte a été crée avec succées &body=Le mot de passe de votre compte est: $password';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
