import 'package:freezed_annotation/freezed_annotation.dart';

part 'protein_model.freezed.dart';

part 'protein_model.g.dart';

@freezed
class ProteinModel with _$ProteinModel {
  factory ProteinModel({
    @JsonKey(name: "img_url") required String igmUrl,
    @JsonKey(name: "count") required int count,
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "price") required int price,
    @JsonKey(name: "proteins") required double proteins,
    @JsonKey(name: "serving") required int serving,
    @JsonKey(name:"title") required String title,
  }) = _ProteinModel;

  factory ProteinModel.fromJson(Map<String, dynamic> json) =>
      _$ProteinModelFromJson(json);
}
