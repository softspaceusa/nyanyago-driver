import 'package:flutter/material.dart';
import 'package:nanny_components/widgets/adapt_builder.dart';
import 'package:nanny_core/nanny_core.dart';

class NetImage extends StatelessWidget {
  final String url;
  final String placeholderPath;
  final bool fitToShortest;
  final double radius;
  final BoxFit? fit;

  const NetImage(
      {super.key,
      required this.url,
      this.fit,
      this.placeholderPath =
          "packages/nanny_components/assets/images/nanny_placeholder.png",
      this.fitToShortest = true,
      this.radius = 50});

  @override
  Widget build(BuildContext context) {
    return fitToShortest
        ? AdaptBuilder(builder: (context, size) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: FadeInImage(
                    width: size.shortestSide,
                    height: size.shortestSide,
                    fit: fit ?? BoxFit.cover,
                    placeholder: AssetImage(placeholderPath),

                    image: NetworkImage(url, headers: {
                      "Authorization": "Bearer ${DioRequest.authToken}"
                    }), ));
          })
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: FadeInImage(
                fit: fit,
                placeholder: AssetImage(placeholderPath),
                image: NetworkImage(url, headers: {
                  "Authorization": "Bearer ${DioRequest.authToken}"
                })));
  }
}
