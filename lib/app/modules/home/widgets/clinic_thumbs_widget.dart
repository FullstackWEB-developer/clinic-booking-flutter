/*
 * File name: clinic_thumbs_widget.dart
 * Last modified: 2022.02.17 at 09:47:19
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/clinic_model.dart';

class ClinicThumbsWidget extends StatelessWidget {
  const ClinicThumbsWidget({
    Key key,
    @required Clinic clinic,
  })  : _clinic = clinic,
        super(key: key);

  final Clinic _clinic;

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 2,
        children: List.generate(
          min(_clinic.images.length, 4),
          (index) {
            return CachedNetworkImage(
              height: 60,
              width: 68.5,
              fit: BoxFit.cover,
              imageUrl: _clinic.images.reversed.elementAt(index).icon,
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            );
          },
        ));
  }
}
