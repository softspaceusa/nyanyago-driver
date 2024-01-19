import 'package:flutter/material.dart';

class TarifsView extends StatefulWidget {
  const TarifsView({super.key});

  @override
  State<TarifsView> createState() => _TarifsViewState();
}

class _TarifsViewState extends State<TarifsView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return const Center(child: Text("На данный момент тарифов нет..."));
  }
  
  @override
  bool get wantKeepAlive => true;
}