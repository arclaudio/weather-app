// import 'package:flutter/material.dart';
// import 'package:weather_app/models/geo_location.dart';

// class SearchResultsList extends StatefulWidget {
//   final List<GeoLocation> searchResults;
//   final List<GeoLocation> favoriteLocations;
//   final Function(GeoLocation) onToggleFavorite;
//   final VoidCallback onUpdateUI;

//   const SearchResultsList({
//     super.key,
//     required this.searchResults,
//     required this.favoriteLocations,
//     required this.onToggleFavorite,
//     required this.onUpdateUI,
//   });

//   @override
//   SearchResultsListState createState() => SearchResultsListState();
// }

// class SearchResultsListState extends State<SearchResultsList> {
//   // SearchResultsListState

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.searchResults.length,
//       itemBuilder: (context, index) {
//         final location = widget.searchResults[index];
//         return ListTile(
//           title: Text('${location.name} - ${location.state}'),
//           subtitle: Text('${location.lat}, ${location.lon}'),
//           trailing: IconButton(
//             onPressed: () {
//               widget.onToggleFavorite(location);
//             },
//             icon: location.isFavorite
//                 ? const Icon(Icons.favorite)
//                 : const Icon(Icons.favorite_border),
//           ),
//         );
//       },
//     );
//   }
// }
