import 'package:flutter/material.dart';
import 'package:nanny_components/widgets/profile_image.dart';

class ClientProfileData extends StatelessWidget {
  const ClientProfileData(
      {super.key,
      required this.photoPath,
      required this.name,
      required this.childrenCount});

  final String photoPath;
  final String name;
  final int childrenCount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        height: 55,
        width: 55,
        child: ProfileImage(
          url: photoPath,
          radius: 55 / 2,
          padding: EdgeInsets.zero,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        getChildrenText(childrenCount),
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  String getChildrenText(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return "$count ребёнок";
    } else if ([2, 3, 4].contains(count % 10) &&
        !(count % 100 >= 12 && count % 100 <= 14)) {
      return "$count детей";
    } else {
      return "$count детей";
    }
  }
}
