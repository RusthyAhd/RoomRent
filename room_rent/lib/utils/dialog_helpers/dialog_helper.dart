import 'package:flutter/material.dart';
import '../../models/room.dart';
import '../../models/guest_house_manager.dart';
import '../../widgets/dialogs/dialogs.dart';

class DialogHelper {
  /// Show room details dialog
  static void showRoomDetails(BuildContext context, Room room) {
    showDialog(
      context: context,
      builder: (context) => RoomDetailsDialog(room: room),
    );
  }

  /// Show contact information dialog
  static void showContactInfo(
    BuildContext context, {
    Room? room,
    GuestHouseManager? manager,
  }) {
    showDialog(
      context: context,
      builder: (context) => ContactInfoDialog(room: room, manager: manager),
    );
  }

  /// Show manager profile dialog
  static void showManagerProfile(
    BuildContext context,
    Room room,
    String shift,
  ) {
    showDialog(
      context: context,
      builder: (context) => ManagerProfileDialog(room: room, shift: shift),
    );
  }

  /// Show contact confirmation dialog
  static void showContactConfirmation(
    BuildContext context,
    Room room,
    Map<String, String> managerInfo,
    String shift,
  ) {
    showDialog(
      context: context,
      builder: (context) => ContactConfirmationDialog(
        room: room,
        managerInfo: managerInfo,
        shift: shift,
      ),
    );
  }
}
