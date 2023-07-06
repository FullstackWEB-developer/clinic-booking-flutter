import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/speciality_model.dart';
import '../../../routes/app_routes.dart';

class SpecialityGridItemWidget extends StatelessWidget {
  final Speciality speciality;
  final String heroTag;

  SpecialityGridItemWidget({Key key, this.speciality, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Get.theme.colorScheme.secondary.withOpacity(0.08),
      onTap: () {
        Get.toNamed(Routes.SPECIALITY, arguments: speciality);
      },
      child: Container(
        decoration: Ui.getBoxDecoration(),
        child: Wrap(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [speciality.color.withOpacity(1), speciality.color.withOpacity(0.1)],
                    begin: AlignmentDirectional.topStart,
                    //const FractionalOffset(1, 0),
                    end: AlignmentDirectional.bottomEnd,
                    stops: [0.1, 0.9],
                    tileMode: TileMode.clamp),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              child: (speciality.image.url.toLowerCase().endsWith('.svg')
                  ? SvgPicture.network(
                      speciality.image.url,
                      color: speciality.color,
                      height: 100,
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: speciality.image.url,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    speciality.name ?? '',
                    style: Theme.of(context).textTheme.bodyText2,
                    softWrap: false,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  if ((speciality.subSpecialities?.length ?? 0) > 0) Divider(height: 25, thickness: 0.5),
                  Wrap(
                    spacing: 5,
                    children: List.generate(speciality.subSpecialities?.length ?? 0, (index) {
                      var _speciality = speciality.subSpecialities.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.SPECIALITY, arguments: _speciality);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Text(_speciality.name, style: Get.textTheme.caption.merge(TextStyle(fontSize: 10))),
                          decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                        ),
                      );
                    }),
                    runSpacing: 5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
