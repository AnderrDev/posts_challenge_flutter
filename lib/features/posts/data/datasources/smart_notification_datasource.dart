import 'package:posts_challenge/core/native/generated/messages.g.dart';

abstract interface class SmartNotificationDatasource {
  Future<void> showNotification({
    required String title,
    required String body,
    required int postId,
  });
  Future<bool> requestPermission();
}

class SmartNotificationDatasourceImpl implements SmartNotificationDatasource {
  SmartNotificationDatasourceImpl({
    NotificationApi? api,
    NotificationPermissionApi? permissionApi,
  }) : _api = api ?? NotificationApi(),
       _permissionApi = permissionApi ?? NotificationPermissionApi();

  final NotificationApi _api;
  final NotificationPermissionApi _permissionApi;

  @override
  Future<void> showNotification({
    required String title,
    required String body,
    required int postId,
  }) async {
    try {
      await _api.showNotification(
        NotificationPayload(title: title, body: body, postId: postId),
      );
    } catch (e) {
      // If native call fails, we might just log it, but shouldn't crash the app
      // or stop the like properly.
      print('Failed to show notification: $e');
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      return await _permissionApi.requestPermission();
    } catch (e) {
      print('Failed to request permission: $e');
      return false;
    }
  }
}
