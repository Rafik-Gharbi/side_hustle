// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../models/category.dart';
import 'assets.dart';
import 'colors.dart';

const double serviceFees = 0.06;

const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.sparkedgesolutions.dootify&hl=en-US&ah=tuR7bT-vrcA-nkaHiSuMxo8njw4';
const String appStoreUrl = 'https://play.google.com/store/apps/details?id=com.sparkedgesolutions.dootify&hl=en-US&ah=tuR7bT-vrcA-nkaHiSuMxo8njw4';
const LatLng defaultLocation = LatLng(34.7403, 10.7604);

const String defaultPrefix = '+216';
const String defaultIsoCode = 'TN';

BorderRadius circularRadius = BorderRadius.circular(50);
BorderRadius regularRadius = BorderRadius.circular(20);
BorderRadius smallRadius = BorderRadius.circular(10);

Border lightBorder = Border.all(color: kNeutralLightColor, width: 0.5);
Border regularBorder = Border.all(color: kNeutralColor, width: 0.8);
Border regularErrorBorder = Border.all(color: kErrorColor, width: 0.8);

final anyCategory = Category(id: -1, name: 'any'.tr, description: '', icon: Assets.noImage);

const String phoneRegex = r'^(?:[+0][1-9])?[0-9]{10,12}$';

const double kMinPriceRange = 0;
const double kMaxPriceRange = 2200;

// Define when screens adabt Mobile version UI
const double kMobileMaxWidth = 500;

const int kLoadMoreLimit = 9;
const minPasswordNumberOfCharacters = 3;
