import 'package:dio/dio.dart';
import 'package:secure_x/data/api/dio_client.dart';
import 'package:secure_x/models/locker_cluster_model.dart';
import 'package:secure_x/utils/app_constants.dart';

class LockerRepo {
  final DioClient dioClient;
  final List<int> lockerClusterIds=[1,2,3];

  LockerRepo({
    required this.dioClient,
  });

  Future<LockerClusterModel> getLockerClusterDetails(int clusterId) async{
    try{
      final response=await dioClient.getData(AppConstants.LOCKER_AVAILABILITY_URI);
      if (response.statusCode == 200) {
        return LockerClusterModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load locker cluster details for ID $clusterId');
      }
    } catch (e) {
      print('Error in getLockerClusterDetails: $e');
      rethrow;
    }
  }

  Future<List<LockerClusterModel>> getAllLockerClusters() async {
    try {
      // Fetch all clusters sequentially
      final List<LockerClusterModel> clusters = [];
      
      for (var clusterId in lockerClusterIds) {
        try {
          final cluster = await getLockerClusterDetails(clusterId);
          clusters.add(cluster);
        } catch (e) {
          print('Error fetching cluster $clusterId: $e');
          // Continue with other clusters even if one fails
        }
      }
      
      return clusters;
    } catch (e) {
      print('Error in getAllLockerClusters: $e');
      rethrow;
    }
  }
      
}
  
