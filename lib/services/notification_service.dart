import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _dueChannelId = 'complaint_due_channel';
  static const _digestChannelId = 'daily_digest_channel';

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    // Device's local timezone name. For offline-first simplicity we default
    // to the system's local offset via tz.local, which the plugin sets
    // automatically on Android/iOS without extra native config.
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false, // we ask explicitly later
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(initSettings);

    const dueChannel = AndroidNotificationChannel(
      _dueChannelId,
      'Complaint Due Reminders',
      description: 'Alerts when a complaint is due',
      importance: Importance.high,
    );
    const digestChannel = AndroidNotificationChannel(
      _digestChannelId,
      'Daily Overdue Digest',
      description: 'Daily summary of overdue complaints',
      importance: Importance.defaultImportance,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(dueChannel);
    await androidPlugin?.createNotificationChannel(digestChannel);

    _initialized = true;
  }


  /// Check if the app is currently allowed to schedule EXACT alarms.
  /// On Android 12+, this can be false even if notification permission
  /// is granted — they are two separate, independently-controlled permissions.
  Future<bool> canScheduleExactAlarms() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>();
    // Returns null on Android versions below 12, where this permission
    // doesn't exist at all and exact alarms are always allowed.
    return await androidPlugin?.canScheduleExactNotifications() ?? true;
  }

  /// Opens the OS settings screen where the user can manually enable
  /// "Alarms & reminders" for this app. Android does not provide an
  /// in-app permission dialog for this — a settings redirect is the
  /// only way to let the user grant it.
  Future<void> requestExactAlarmPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  /// Request runtime permission. Call this once, after first app launch
  /// (e.g. on Dashboard's first build), not buried inside a settings menu —
  /// owner needs to grant this for the app's core promise to work.
  Future<bool> requestPermission() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final androidGranted = await androidPlugin
        ?.requestNotificationsPermission();

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosGranted = await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  /// Schedule a reminder that fires exactly at [dueBy].
  /// Notification id is derived from complaintId so we can cancel/replace it later.
  Future<void> scheduleDueReminder({
    required int complaintId,
    required String complaintTitle,
    required DateTime dueBy,
  }) async {
    if (dueBy.isBefore(DateTime.now())) return; // don't schedule for the past

    final scheduledDate = tz.TZDateTime.from(dueBy, tz.local);

    await _plugin.zonedSchedule(
      _dueNotificationId(complaintId),
      'Complaint due now',
      complaintTitle,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _dueChannelId,
          'Complaint Due Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel a scheduled due reminder — call when complaint is resolved,
  /// deleted, or its dueBy date changes (then reschedule with the new date).
  Future<void> cancelDueReminder(int complaintId) async {
    await _plugin.cancel(_dueNotificationId(complaintId));
  }

  /// Schedule a recurring daily reminder at a fixed time (default 9:00 AM)
  /// prompting the owner to check overdue complaints. This is a static
  /// nudge, not a live count — computing a live count would require
  /// background execution (WorkManager), which is out of scope for MVP.
  Future<void> scheduleDailyOverdueDigest({
    int hour = 9,
    int minute = 0,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _digestNotificationId,
      'TechTrack — Daily Check',
      'Open the app to review any overdue complaints.',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _digestChannelId,
          'Daily Overdue Digest',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time, // repeats daily at this time
    );
  }

  Future<void> cancelDailyDigest() async {
    await _plugin.cancel(_digestNotificationId);
  }

  // Deterministic id from complaintId so we never collide with other
  // notification ids and can always find-and-cancel the right one.
  int _dueNotificationId(int complaintId) => 100000 + complaintId;
  static const _digestNotificationId = 999999;
}
