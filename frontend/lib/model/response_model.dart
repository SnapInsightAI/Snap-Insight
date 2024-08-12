import 'dart:convert';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  Response? response;

  ResponseModel({
    this.response,
  });

  factory ResponseModel.fromJson(String json) => ResponseModel(
        response: json.trim().isEmpty ? null : Response.fromJson(jsonDecode(json)["response"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response?.toJson(),
      };
}

class Response {
  List<Candidate>? candidates;
  UsageMetadata? usageMetadata;

  Response({
    this.candidates,
    this.usageMetadata,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        candidates: json["candidates"] == null
            ? []
            : List<Candidate>.from(json["candidates"]!.map((x) => Candidate.fromJson(x))),
        usageMetadata: json["usageMetadata"] == null ? null : UsageMetadata.fromJson(json["usageMetadata"]),
      );

  Map<String, dynamic> toJson() => {
        "candidates": candidates == null ? [] : List<dynamic>.from(candidates!.map((x) => x.toJson())),
        "usageMetadata": usageMetadata?.toJson(),
      };
}

class Candidate {
  Content? content;
  String? finishReason;
  int? index;
  List<SafetyRating>? safetyRatings;

  Candidate({
    this.content,
    this.finishReason,
    this.index,
    this.safetyRatings,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
        content: json["content"] == null ? null : Content.fromJson(json["content"]),
        finishReason: json["finishReason"],
        index: json["index"],
        safetyRatings: json["safetyRatings"] == null
            ? []
            : List<SafetyRating>.from(json["safetyRatings"]!.map((x) => SafetyRating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content": content?.toJson(),
        "finishReason": finishReason,
        "index": index,
        "safetyRatings": safetyRatings == null ? [] : List<dynamic>.from(safetyRatings!.map((x) => x.toJson())),
      };
}

class Content {
  List<Part>? parts;
  String? role;

  Content({
    this.parts,
    this.role,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        parts: json["parts"] == null ? [] : List<Part>.from(json["parts"]!.map((x) => Part.fromJson(x))),
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "parts": parts == null ? [] : List<dynamic>.from(parts!.map((x) => x.toJson())),
        "role": role,
      };
}

class Part {
  String? text;

  Part({
    this.text,
  });

  factory Part.fromJson(Map<String, dynamic> json) => Part(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}

class SafetyRating {
  String? category;
  String? probability;

  SafetyRating({
    this.category,
    this.probability,
  });

  factory SafetyRating.fromJson(Map<String, dynamic> json) => SafetyRating(
        category: json["category"],
        probability: json["probability"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "probability": probability,
      };
}

class UsageMetadata {
  int? promptTokenCount;
  int? candidatesTokenCount;
  int? totalTokenCount;

  UsageMetadata({
    this.promptTokenCount,
    this.candidatesTokenCount,
    this.totalTokenCount,
  });

  factory UsageMetadata.fromJson(Map<String, dynamic> json) => UsageMetadata(
        promptTokenCount: json["promptTokenCount"],
        candidatesTokenCount: json["candidatesTokenCount"],
        totalTokenCount: json["totalTokenCount"],
      );

  Map<String, dynamic> toJson() => {
        "promptTokenCount": promptTokenCount,
        "candidatesTokenCount": candidatesTokenCount,
        "totalTokenCount": totalTokenCount,
      };
}
