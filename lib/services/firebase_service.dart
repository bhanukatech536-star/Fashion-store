class FirebaseService {
  // Mock Firebase Service for UI phase
  // In the final phase, this will include FirebaseAuth and FirebaseFirestore instances

  Future<void> initialize() async {
    // mock initialization
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
