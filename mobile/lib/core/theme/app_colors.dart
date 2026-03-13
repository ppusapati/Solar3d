import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Solar Orange/Amber
  static const Color primary = Color(0xFFF59E0B);
  static const Color primaryDark = Color(0xFFD97706);
  static const Color primaryLight = Color(0xFFFBBF24);

  // Secondary - Blue
  static const Color secondary = Color(0xFF3B82F6);
  static const Color secondaryDark = Color(0xFF2563EB);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Project Status Colors
  static const Color statusDraft = Color(0xFF6B7280);
  static const Color statusDesign = Color(0xFF3B82F6);
  static const Color statusSimulation = Color(0xFF8B5CF6);
  static const Color statusReview = Color(0xFFF59E0B);
  static const Color statusApproved = Color(0xFF10B981);
  static const Color statusArchived = Color(0xFF9CA3AF);

  // Background
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);

  // Surface
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);

  // Map Layer Colors
  static const Color panelColor = Color(0xFF3B82F6);
  static const Color boundaryColor = Color(0xFF10B981);
  static const Color cableColor = Color(0xFFEF4444);
  static const Color roadColor = Color(0xFF6B7280);

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return statusDraft;
      case 'design':
        return statusDesign;
      case 'simulation':
        return statusSimulation;
      case 'review':
        return statusReview;
      case 'approved':
        return statusApproved;
      case 'archived':
        return statusArchived;
      default:
        return statusDraft;
    }
  }
}
