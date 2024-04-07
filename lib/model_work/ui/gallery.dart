/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:sdgp_95/model_work/ui/scan_screen.dart';
import 'package:sdgp_95/shop/shop_page.dart';
import '../../app_main_button.dart';
import '../helper/image_classification_helper.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  ImageClassificationHelper? imageClassificationHelper;
  final imagePicker = ImagePicker();
  String? imagePath;
  img.Image? image;
  Map<String, double>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    super.initState();
  }

  // Clean old results when press some take picture button
  void cleanResult() {
    imagePath = null;
    image = null;
    classification = null;
    setState(() {});
  }

  // Process picked image
  Future<void> processImage() async {
    if (imagePath != null) {
      // Read image bytes from file
      final imageData = File(imagePath!).readAsBytesSync();
      // Decode image using package:image/image.dart (https://pub.dev/image)
      image = img.decodeImage(imageData);
      setState(() {});
      classification = await imageClassificationHelper?.inferenceImage(image!);
      setState(() {});
    }
  }

  @override
  void dispose() {
    imageClassificationHelper?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (imagePath != null)
                Image.file(
                  File(imagePath!),
                  width: MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.height * 0.6,
                  fit: BoxFit.fitHeight,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Column(
                  children: [
                    // Show classification result
                    if (classification != null)
                      ...(classification!.entries.toList()
                            ..sort(
                              (a, b) => a.value.compareTo(b.value),
                            ))
                          .reversed
                          .take(1)
                          .map(
                            (e) => Container(
                              padding: const EdgeInsets.all(3),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(e.key),
                                      const Spacer(),
                                      Text(e.value.toStringAsFixed(2))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                AppMainButton(
                                          text: "Shop Now",
                                          onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) => ShopPage()));

                                            // if (e.key == "boot") {
                                            //   Navigator.of(context).push(
                                            //       MaterialPageRoute(
                                            //           builder: (_) => ShopPage()));
                                            // } else if (e.key == "mirror") {
                                            //
                                            //   Navigator.of(context).push(
                                            //       MaterialPageRoute(
                                            //           builder: (_) =>
                                            //               DetailScreen(
                                            //                   title:
                                            //                       "Mirror")));
                                            // } else if (e.key == "bumper") {
                                            //   Navigator.of(context).push(
                                            //       MaterialPageRoute(
                                            //           builder: (_) =>
                                            //               DetailScreen(
                                            //                   title:
                                            //                       "Bumper")));
                                            //
                                            // } else {}
                                          }),
                                      // : Container(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AppMainButton(
                                      text: "Start Again",
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ScanScreen()));
                                      }),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              if (image == null)
                const SizedBox(
                  height: 25,
                ),
              if (image == null)
                AppMainButton(
                  icon: Iconsax.gallery,
                  text: 'Select from Gallery',
                  onPressed: () async {
                    cleanResult();
                    final result = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    imagePath = result?.path;
                    setState(() {});
                    processImage();
                  },
                ),
              if (cameraIsAvailable)
                image == null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: AppMainButton(
                          icon: Iconsax.camera,
                          text: 'Select from camera',
                          onPressed: () async {
                            cleanResult();
                            final result = await imagePicker.pickImage(
                              source: ImageSource.camera,
                            );

                            imagePath = result?.path;
                            setState(() {});
                            processImage();
                          },
                        ),
                      )
                    : Container()
            ],
          ),
        ),
      ),
    );
  }
}
