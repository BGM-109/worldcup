import 'package:freezed_annotation/freezed_annotation.dart';

part 'protein_model.freezed.dart';
part 'protein_model.g.dart';

@freezed
class ProteinModel with _$ProteinModel {
  factory ProteinModel({
    @JsonKey(name:"img_url") required String igmUrl,
    required String title,
    required int price,
  }) = _ProteinModel;

  factory ProteinModel.fromJson(Map<String, dynamic> json) => _$ProteinModelFromJson(json);
}