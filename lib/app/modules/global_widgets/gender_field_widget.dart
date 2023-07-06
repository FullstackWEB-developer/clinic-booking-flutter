/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui.dart';

class GenderFieldWidget extends StatelessWidget {
  const GenderFieldWidget({
    Key key,
    this.onChanged,
    this.onSaved,
    this.value,
    this.iconData,
    this.isFirst,
    this.isLast,
    this.style,
    this.items, this.errorText, this.textAlign, this.labelText,
  }) : super(key: key);

  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSaved;
  final String value;
  final String errorText;
  final TextAlign textAlign;
  final String labelText;
  final TextStyle style;
  final IconData iconData;
  final bool isFirst;
  final bool isLast;
  final List<DropdownMenuItem<String>> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: topMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: buildBorderRadius,
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText ?? "",
            style: Get.textTheme.bodyText1,
            textAlign: textAlign ?? TextAlign.start,
          ),
          Row(
            children: [
              Icon(iconData, color: Get.theme.focusColor).marginOnly(right: 14),
              Expanded(
                child: DropdownButtonFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: key,
                  isExpanded:true,
                  elevation: 2,
                  items: items,
                  value: value ?? '',
                  onChanged: onChanged,
                  onSaved: onSaved,
                  style: style ?? Get.textTheme.bodyText2,
                  dropdownColor: Get.theme.primaryColor,
                  isDense: false,
                  decoration: InputDecoration(
                    contentPadding:  EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent, width: 0),
                    ),
                  ),

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst) {
      return BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast != null && isLast) {
      return BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && !isFirst && isLast != null && !isLast) {
      return BorderRadius.all(Radius.circular(0));
    }
    return BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast)) {
      return 10;
    } else if (isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }
}
