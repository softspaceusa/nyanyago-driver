import 'package:flutter/material.dart';

class TarifsView extends StatefulWidget {
  const TarifsView({super.key});

  @override
  State<TarifsView> createState() => _TarifsViewState();
}

class _TarifsViewState extends State<TarifsView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    if(wantKeepAlive) super.build(context);
    
    return const Placeholder();
  }
  
  @override
  bool get wantKeepAlive => true;
}