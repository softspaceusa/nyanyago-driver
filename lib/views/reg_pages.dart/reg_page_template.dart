import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';

class RegPageBaseView extends StatelessWidget {
  final List<Widget> children;
  final bool isFirstPage;
  
  const RegPageBaseView({
    super.key,
    required this.children,
    this.isFirstPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptBuilder(
      builder: (context, size) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: isFirstPage ? null 
            : const NannyAppBar(),
          body: SingleChildScrollView(
            child: SizedBox(
              height: size.height * .7,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: isFirstPage ? 20 : 80, right: 10, bottom: 30),
                child: Column(
                  children: children,
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}