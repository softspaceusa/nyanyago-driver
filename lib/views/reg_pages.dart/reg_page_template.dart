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
    return Scaffold(
      appBar: isFirstPage ? null 
        : const NannyAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}