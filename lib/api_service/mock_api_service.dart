import '../constant/config.dart';
import '../model/response/user_model.dart';
import 'base_api_service.dart';

class MockApiService extends BaseApiService {
  Future<UserResponse> fetchUserList({int page = 1, int count = 99999}) async {
    return onRequest(
      path: "/api/user/all_users",
      query: {
        "page": page,
        "count": count,
      },
      method: HttpMethod.GET,
      onSuccess: (response) {
        return UserResponse.fromJson(response.data);
      },
    );
  }
}
