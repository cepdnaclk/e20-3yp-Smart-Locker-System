// controllers/locker_controller.dart
import 'package:get/get.dart';
import 'package:secure_x/data/repository/locker_repo.dart';
import 'package:secure_x/models/locker_cluster_model.dart';


class LockerController extends GetxController {
  final LockerRepo lockerRepo;
  var isLoading = false.obs;
  var lockerClusters = <LockerClusterModel>[].obs;
  var errorMessage = ''.obs;
  var fetchProgress = 0.0.obs; // To track progress of fetching all clusters

  LockerController({required this.lockerRepo});

  Future<void> fetchAllLockerClusters() async {
    try {
      isLoading(true);
      errorMessage('');
      fetchProgress(0.0);
      
      final clusters = await lockerRepo.getAllLockerClusters();
      lockerClusters.assignAll(clusters);
      
      // Update progress as each cluster is fetched
      for (int i = 0; i < lockerRepo.lockerClusterIds.length; i++) {
        await Future.delayed(Duration(milliseconds: 100)); // Small delay for smooth progress
        fetchProgress((i + 1) / lockerRepo.lockerClusterIds.length);
      }
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', 'Failed to fetch some locker clusters');
    } finally {
      isLoading(false);
      fetchProgress(1.0);
    }
  }

  Future<LockerClusterModel?> fetchLockerClusterDetails(int clusterId) async {
    try {
      isLoading(true);
      errorMessage('');
      return await lockerRepo.getLockerClusterDetails(clusterId);
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', 'Failed to fetch locker details: $e');
      return null;
    } finally {
      isLoading(false);
    }
  }
}