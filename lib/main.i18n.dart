import 'package:i18n_extension/i18n_extension.dart';

const appbarTitle = "appbarTitle";
const localFrenchText = "localFrenchText";
const localEnglishText = "localEnglishText";

extension Localization on String {

  static final _t = Translations.from("fr_FR", {
    appbarTitle: {
      "en_US": "Metronomy US",
      "fr_FR": "Metronomy FR",
    },
    localFrenchText: {
      "en_US": "French",
      "fr_FR": "Français",
    },
    localEnglishText: {
      "en_US": "English",
      "fr_FR": "Anglais",
    }
  });

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}