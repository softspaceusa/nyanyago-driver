import 'package:flutter/material.dart';
import 'package:nanny_core/models/from_api/drive_and_map/geocoding_data.dart';

class AddressViewData {
  final TextEditingController controller = TextEditingController();
  GeocodeResult? address;
}