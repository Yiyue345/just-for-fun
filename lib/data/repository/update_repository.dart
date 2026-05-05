import 'dart:io';

import 'package:go_deeper/core/network/update.dart';

class UpdateModel {
  final String? version;
  final String? details;
  final String? link;
  final String? sha256;
  final bool canUpdate;

  UpdateModel({
    this.version,
    this.details,
    this.link,
    this.sha256,
    required this.canUpdate,
  });
}

// todo: 测试与完善功能
abstract class UpdateRepository {
  Future<UpdateModel> checkForUpdate();
  Future<File> downloadUpdate(
      String url,
      String sha256,
      Function(double progress) onProgress,
      );
}

class UpdateRepositoryImpl implements UpdateRepository {

  final UpdateRemoteDataSource updateRemoteDataSource;

  UpdateRepositoryImpl({
    required this.updateRemoteDataSource,
  });

  @override
  Future<UpdateModel> checkForUpdate() async {
    final futures = <Future>[
      updateRemoteDataSource.checkForUpdate(),
      updateRemoteDataSource.getUpdateURLAndDetails()
    ];

    final results = await Future.wait(futures);
    if (!results[0]) {
      return UpdateModel(canUpdate: false);
    } else {
      final Map<String, dynamic> infos = results[1];
      return UpdateModel(
        canUpdate: true,
        version: infos['version'],
        details: infos['details'],
        link: infos['link'],
        sha256: infos['sha256'],
      );
    }
  }

  @override
  Future<File> downloadUpdate(String url, String sha256, Function(double progress) onProgress) {
    // TODO: implement downloadUpdate
    throw UnimplementedError();
  }
}
