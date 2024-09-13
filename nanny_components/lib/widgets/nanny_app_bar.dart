import 'package:flutter/material.dart';

class NannyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isTransparent;
  final bool hasBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final String? title;
  final Function()? onBackPressed;

  const NannyAppBar(
      {super.key,
      this.isTransparent = true,
      this.hasBackButton = true,
      this.actions,
      this.leading,
      this.onBackPressed,
      this.bottom,
      this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: isTransparent ? 0 : 10,
        backgroundColor: isTransparent
            ? Colors.transparent
            : Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        forceMaterialTransparency: isTransparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        toolbarHeight: preferredSize.height,
        bottom: bottom,
        leading: leading != null
            ? Padding(padding: const EdgeInsets.only(left: 10), child: leading)
            : (hasBackButton
                ? IconButton(
                    onPressed: onBackPressed != null
                        ? () => onBackPressed?.call()
                        : () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_outlined),
                    splashRadius: 25)
                : null),
        actions: actions?..add(const SizedBox(width: 10)),
        title: title != null
            ? FittedBox(
                child: Text(title!,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center))
            : null,
        centerTitle: true);
  }

  @override
  Size get preferredSize => Size(double.maxFinite, bottom == null ? 80 : 120);
}
