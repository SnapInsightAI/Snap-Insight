import 'response_model.dart';

class ReqModel {
  List<Content>? req;

  ReqModel({
    this.req,
  });

  factory ReqModel.fromJson(Map<String, dynamic> json) => ReqModel(
        req: json["req"] == null ? [] : List<Content>.from(json["req"]!.map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "req": req == null ? [] : List<dynamic>.from(req!.map((x) => x.toJson())),
      };
}
