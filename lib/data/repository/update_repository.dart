class UpdateModel {
  final String version;
  final String description;
  final String downloadUrl;
  final bool canUpdate;

  UpdateModel({
    required this.version,
    required this.description,
    required this.downloadUrl,
    required this.canUpdate,
  });
}

abstract class UpdateRepository {
  Future<UpdateModel> checkForUpdate();
}

