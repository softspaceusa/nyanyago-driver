import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/google_map_api.dart';
import 'package:nanny_core/models/from_api/drive_and_map/address_data.dart';
import 'package:nanny_core/nanny_core.dart';

class AddressPicker extends StatefulWidget {
  final ScrollController? controller;
  final List<AddressData> addresses;
  final void Function(AddressData address) onAdded;
  final void Function(AddressData oldAddress, AddressData newAddress) onAddressChange;
  final void Function(AddressData address) onDelete;
  
  const AddressPicker({
    super.key,
    required this.controller,
    required this.addresses,

    required this.onAdded,
    required this.onAddressChange,
    required this.onDelete,
  });

  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        shrinkWrap: true,
        controller: widget.controller,
        children: widget.addresses.asMap().entries.map(
          (e) => ElevatedButton(
            onPressed: () => changeAddress(e.value), 
            style: NannyButtonStyles.transparent,
            child: Row(
              children: [
                Icon(
                  e.key == 0 ? Icons.arrow_forward_ios_rounded : Icons.pin_drop, 
                  color: NannyTheme.darkGrey
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    NannyMapUtils.simplifyAddress(e.value.address), 
                    textAlign: TextAlign.left
                  ),
                ),
                if(e.key != 0 && e.key != 1) IconButton(
                  splashRadius: 20,
                  
                  onPressed: () => widget.onDelete(e.value), 
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                ),
              ],
            ),
          ),
        ).toList()
          ..add(
            ElevatedButton(
              onPressed: addAddress, 
              style: NannyButtonStyles.transparent.copyWith(
                foregroundColor: const MaterialStatePropertyAll(NannyTheme.primary)
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Добавить адрес"),
                    Icon(Icons.add),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

  void addAddress() async {
    var address = await showSearch(
      context: context, 
      delegate: NannySearchDelegate(
        onSearch: (query) => GoogleMapApi.geocode(address: query), 
        onResponse: (response) => response.response!.geocodeResults,
        tileBuilder: (data, close) => ListTile(
          title: Text(data.formattedAddress),
          onTap: close,
        ),
      ),
    );

    if(address == null) return;
    widget.onAdded(
      AddressData(
        address: NannyMapUtils.simplifyAddress(address.formattedAddress), 
        location: address.geometry!.location!
      )
    );
  }

  void changeAddress(AddressData old) async {
    var address = await showSearch(
      context: context, 
      delegate: NannySearchDelegate(
        onSearch: (query) => GoogleMapApi.geocode(address: query), 
        onResponse: (response) => response.response!.geocodeResults,
        tileBuilder: (data, close) => ListTile(
          title: Text(data.formattedAddress),
          onTap: close,
        ),
      ),
    );

    if(address == null) return;
    widget.onAddressChange(
      old,
      AddressData(
        address: NannyMapUtils.simplifyAddress(address.formattedAddress), 
        location: address.geometry!.location!
      )
    );
  }
}