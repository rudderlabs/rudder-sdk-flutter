package com.rudderstack.sdk.flutter.managers;

import com.rudderstack.android.sdk.core.util.Utils;

public class PreferenceManager {
  private static PreferenceManager instance;
  private static final String PREFS_NAME = "rl_prefs";
  private static final String PREFS_KEY_BUILD_NUMBER = "rl_application_build_key";
  private static final String PREFS_KEY_VERSION_NAME = "rl_application_version_key";
  private final android.content.SharedPreferences preferences;

  private PreferenceManager(android.content.SharedPreferences preferences) {
    this.preferences = preferences;
  }

  public static PreferenceManager getInstance(android.content.Context context) {
    if (instance == null) {
      instance = new PreferenceManager(context.getSharedPreferences(PREFS_NAME, android.content.Context.MODE_PRIVATE));
    }
    return instance;
  }

  public void saveBuildNumber(int buildNumber) {
    preferences.edit().putInt(PREFS_KEY_BUILD_NUMBER, buildNumber).apply();
  }

  public int getBuildNumber() {
    return preferences.getInt(PREFS_KEY_BUILD_NUMBER, -1);
  }

  public void saveVersionName(String versionName) {
    preferences.edit().putString(PREFS_KEY_VERSION_NAME, versionName).apply();
  }

  public String getVersionName() {
    return preferences.getString(PREFS_KEY_VERSION_NAME, null);
  }

  public void saveAutoSessionExists(boolean autoSessionExists) {
    preferences.edit().putBoolean("rl_auto_session_exists", autoSessionExists).apply();
  }

  public boolean doesAutoSessionExists() {
    return preferences.getBoolean("rl_auto_session_exists", false);
  }

  public void saveManualSessionExists(boolean manualSessionExists) {
    preferences.edit().putBoolean("rl_manual_session_exists", manualSessionExists).apply();
  }

  public boolean doesManualSessionExists() {
    return preferences.getBoolean("rl_manual_session_active", false);
  }

  public void updateLastEventTimestamp() {
    preferences.edit().putLong("rl_last_event_timestamp", Utils.getCurrentTimeInMilliSeconds()).apply();
  }

  public long getLastEventTimestamp() {
    return preferences.getLong("rl_last_event_timestamp", -1);
  }
}
