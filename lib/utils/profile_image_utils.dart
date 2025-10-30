import 'package:flutter/material.dart';

class ProfileImageUtils {
  // Default profile image widget
  static Widget getDefaultProfileImage({double radius = 30}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF2E4057),
      child: Icon(
        Icons.person,
        size: radius * 1.2,
        color: Colors.white70,
      ),
    );
  }

  // Get profile image with fallback to default
  static Widget getProfileImage({
    String? imageUrl,
    double radius = 30,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback to default image on error
        },
        child: Container(), // This will be hidden when image loads successfully
      );
    }
    
    return getDefaultProfileImage(radius: radius);
  }

  // Get profile image for decoration (used in Container with DecorationImage)
  static DecorationImage? getProfileDecorationImage({String? imageUrl}) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
        onError: (exception, stackTrace) {
          // Handle error silently
        },
      );
    }
    return null; // Return null to use default background/child
  }

  // Default decoration for containers
  static BoxDecoration getDefaultProfileDecoration({double radius = 30}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: const Color(0xFF2E4057),
    );
  }
}