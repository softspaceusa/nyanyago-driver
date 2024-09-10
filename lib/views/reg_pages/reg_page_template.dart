import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';

class RegPageBaseView extends StatelessWidget {
  final List<Widget> children;
  final bool isFirstPage;
  final double? height;

  const RegPageBaseView({
    super.key,
    required this.children,
    this.isFirstPage = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptBuilder(builder: (context, size) {
      return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: isFirstPage ? null : const NannyAppBar(),
          body: SingleChildScrollView(
              child: SizedBox(
                  height: size.height * (height ?? .75),
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 10,
                          top: isFirstPage ? 20 : 80,
                          right: 10,
                          bottom: 30),
                      child: Column(children: children)))));
    });
  }
}
