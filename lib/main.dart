// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/app/app.dart';
import 'package:very_good_slide_puzzle/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyDCo2G3Jl8uRgC8x5X2OpyC_MQJfp4M0pY",
    appId: "1:639154038312:web:a8f31333648e0ef3bcf71d",
    messagingSenderId: "639154038312",
    projectId: "fischi-puzzle",
  ));
  runApp(App());
}
