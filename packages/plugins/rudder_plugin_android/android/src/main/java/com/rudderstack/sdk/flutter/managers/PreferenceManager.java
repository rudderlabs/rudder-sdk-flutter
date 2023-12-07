package com.rudderstack.sdk.flutter.managers;

import android.content.Context;
import android.content.SharedPreferences;

import com.rudderstack.android.sdk.core.util.Utils;

public class PreferenceManager {
  private static PreferenceManager instance;
  private static final String FLUTTER_PREFS_NAME = "rl_prefs_flutter";
  private static final String NATIVE_PREFS_NAME = "rl_prefs";
  private static final String PREFS_KEY_BUILD_NUMBER = "rl_application_build_key";
  private static final String PREFS_KEY_VERSION_NAME = "rl_application_version_key";
  private final SharedPreferences preferences;

  private final Context context;

  private PreferenceManager(Context context) {
    this.context = context;
    this.preferences = this.context.getSharedPreferences(FLUTTER_PREFS_NAME, Context.MODE_PRIVATE);
  }

  public static PreferenceManager getInstance(Context context) {
    if (instance == null) {
      instance = new PreferenceManager(context);
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

  public void updateLastEventTimestamp() {
    preferences.edit().putLong("rl_last_event_timestamp", Utils.getCurrentTimeInMilliSeconds()).apply();
  }

  public long getLastEventTimestamp() {
    return preferences.getLong("rl_last_event_timestamp", -1);
  }

  public void migrateAppInfoPreferencesFromNative() {
    SharedPreferences nativePrefs = this.context.getSharedPreferences(NATIVE_PREFS_NAME, Context.MODE_PRIVATE);
    if (!this.preferences.contains(PREFS_KEY_BUILD_NUMBER) && nativePrefs.contains(PREFS_KEY_BUILD_NUMBER)) {
      saveBuildNumber(nativePrefs.getInt(PREFS_KEY_BUILD_NUMBER, -1));
    }
    if (!this.preferences.contains(PREFS_KEY_VERSION_NAME) && nativePrefs.contains(PREFS_KEY_VERSION_NAME)) {
      saveVersionName(nativePrefs.getString(PREFS_KEY_VERSION_NAME, null));
    }
  }
}
