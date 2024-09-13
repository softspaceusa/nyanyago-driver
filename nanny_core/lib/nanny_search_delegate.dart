import 'package:flutter/material.dart';
import 'package:nanny_components/nanny_components.dart';
import 'package:nanny_core/api/api_models/static_data.dart';
import 'package:nanny_core/nanny_core.dart';

class NannySearchDelegate<T, E> extends SearchDelegate<E?> {
  NannySearchDelegate({
    required this.onSearch,
    required this.onResponse,
    this.tileBuilder,
    this.searchLabel = "Поиск...",
    this.emptyLabel = "Список пуст...",
  }) {
    request = onSearch(query);
  }

  final Future< ApiResponse<T> > Function(String query) onSearch;
  final List<E>? Function(ApiResponse<T> response) onResponse;
  final Widget Function(E data, VoidCallback close)? tileBuilder;
  final String searchLabel;
  final String emptyLabel;

  late Future< ApiResponse<T> > request;
  Future<void>? timer;

  @override
  String? get searchFieldLabel => searchLabel;
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if(query.isNotEmpty) {
            query = "";
          }
          else {
            close(context, null);
          }
        },
        icon: const Icon(Icons.close),
        splashRadius: 25,
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_outlined),
      splashRadius: 25,
    );
  }

  @override
  Widget buildResults(BuildContext context) => searchForSuggestions();

  @override
  Widget buildSuggestions(BuildContext context) => searchForSuggestions();

  Widget searchForSuggestions() {
    return FutureLoader(
      future: loadRequest(), 
      completeView: (context, data) {
        if(data.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(emptyLabel, textAlign: TextAlign.center),
            ),
          );
        }
        
        return ListView(
          children: data.map(
            (e) => tileBuilder != null ? tileBuilder!(e, () => close(context, e))
              : ListTile(
                title: Text( (e as StaticData).title ),
                onTap: () => close(context, e),
              ),
          ).toList(),
        );
      },
      errorView: (context, error) => ErrorView(errorText: error.toString()),
    );
  }

  Future<List<E>> loadRequest() async {
    timer ??= Future.delayed(
      const Duration(seconds: 1),
      () async {
        timer = null;
        request = onSearch(query);
      },
    );
    await timer;

    return onResponse(await request) ?? [];
  }
}