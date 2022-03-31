import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum InformationLabel {
  copyright, developers, contributors, licenses, privacy
}

extension InformationLabelExt on InformationLabel {
  String get label {
    switch (this) {
      case InformationLabel.copyright:
        return "copyright".tr();
      case InformationLabel.developers:
        return "developers".tr();
      case InformationLabel.contributors:
        return "contributors".tr();
      case InformationLabel.licenses:
        return "licenses".tr();
      case InformationLabel.privacy:
        return "privacy".tr();
    }
  }

  Icon get icon {
    switch (this) {
      case InformationLabel.copyright:
        return Icon(Icons.copyright, size: 20);
      case InformationLabel.developers:
        return Icon(Icons.handyman, size: 20);
      case InformationLabel.contributors:
        return Icon(Icons.people, size: 20);
      case InformationLabel.licenses:
        return Icon(Icons.apps, size: 20);
      case InformationLabel.privacy:
        return Icon(Icons.privacy_tip, size: 20);
    }
  }
}