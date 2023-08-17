import 'package:typeahead_group/typeahead_group.dart';

class MapData {
  final String value;
  final String label;

  const MapData({
    required this.value,
    required this.label,
  });
}

List<TypeAheadDataGroup<MapData>> dataGroup = [
  TypeAheadDataGroup(
    title: 'Header 1',
    items: [
      MapData(value: 'abc', label: 'abc'),
      MapData(value: 'tuyen', label: 'tuyen'),
      MapData(value: '12313', label: '12313'),
    ],
  ),
  TypeAheadDataGroup(
    title: 'Header 2',
    items: [
      MapData(value: 'hoang', label: 'hoang'),
      MapData(value: 'phuong', label: 'phuong'),
      MapData(value: 'duy', label: 'duy'),
      MapData(value: 'thien', label: 'thien'),
      MapData(value: 'tuyen', label: 'tuyen'),
    ],
  ),
  TypeAheadDataGroup(
    title: 'Header 3',
    items: [
      MapData(value: 'abc', label: 'abc'),
      MapData(value: 'duy', label: 'duy'),
      MapData(value: 'thien', label: 'thien'),
      MapData(value: 'tuyen', label: 'tuyen'),
      MapData(value: '12313', label: '12313'),
    ],
  ),
  TypeAheadDataGroup(
    title: 'Header 4',
    items: [
      MapData(value: '4abc', label: 'abc4'),
      MapData(value: '4duy', label: 'duy4'),
      MapData(value: '4thien', label: 'thien4'),
      MapData(value: '4tuyen', label: 'tuyen4'),
      MapData(value: '412313', label: '123134'),
    ],
  )
];
