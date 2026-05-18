class AppConstants {
  static const String adminEmail = 'admin@bh.com';

  static const String productsCollection = 'products';
  static const String categoriesCollection = 'categories';
  static const String usersCollection = 'users';
  static const String ordersCollection = 'orders';

  static bool isAdminEmail(String email) {
    return email.trim().toLowerCase() == adminEmail;
  }
}
