class IncidentsModel {
  String name = "";
  String color = "";
  String catagory = "";
  double lng = 0;
  double lat = 0;
  String memberId="";

  IncidentsModel(
      {required this.memberId,
        required this.name,
        required this.color,
        required this.catagory,
        required this.lng,
        required this.lat});

}