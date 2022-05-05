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
        return const Icon(Icons.copyright, size: 20);
      case InformationLabel.developers:
        return const Icon(Icons.handyman, size: 20);
      case InformationLabel.contributors:
        return const Icon(Icons.people, size: 20);
      case InformationLabel.licenses:
        return const Icon(Icons.apps, size: 20);
      case InformationLabel.privacy:
        return const Icon(Icons.privacy_tip, size: 20);
    }
  }
}