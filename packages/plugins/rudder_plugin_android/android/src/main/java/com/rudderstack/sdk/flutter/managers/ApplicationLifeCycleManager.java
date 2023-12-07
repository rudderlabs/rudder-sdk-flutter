package com.rudderstack.sdk.flutter.managers;

import android.app.Application;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;

import com.rudderstack.android.sdk.core.RudderClient;
import com.rudderstack.android.sdk.core.RudderLogger;
import com.rudderstack.android.sdk.core.RudderProperty;

public class ApplicationLifeCycleManager {
  public static final String VERSION = "version";
  private boolean trackLifeCycleEvents;
  private UserSessionManager userSessionManager;
  private RudderAppInfo rudderAppInfo;

  public ApplicationLifeCycleManager(Application application, UserSessionManager userSessionManager, boolean trackLifeCycleEvents) {
    this.rudderAppInfo = new RudderAppInfo(application);
    this.userSessionManager = userSessionManager;
    this.trackLifeCycleEvents = trackLifeCycleEvents;
  }

  public void trackApplicationLifeCycleEvents() {
    this.rudderAppInfo.storeCurrentBuildAndVersion();
    if (!this.trackLifeCycleEvents) {
      return;
    }
    if (rudderAppInfo.isApplicationInstalled()) {
      this.userSessionManager.updateLastEventTimestamp();
      sendApplicationInstalled(rudderAppInfo.currentBuild, rudderAppInfo.currentVersion);
    } else if (rudderAppInfo.isApplicationUpdated()) {
      this.userSessionManager.updateLastEventTimestamp();
      sendApplicationUpdated(rudderAppInfo.previousBuild, rudderAppInfo.currentBuild, rudderAppInfo.previousVersion, rudderAppInfo.currentVersion);
    }
  }

  private void sendApplicationInstalled(int currentBuild, String currentVersion) {
    RudderLogger.logDebug("ApplicationLifeCycleHandler: sendApplicationInstalled: Tracking Application Installed");
    RudderProperty property = new RudderProperty()
      .putValue(VERSION, currentVersion)
      .putValue("build", currentBuild);
    RudderClient.getInstance().track("Application Installed", property);
  }

  private void sendApplicationUpdated(int previousBuild, int currentBuild, String previousVersion, String currentVersion) {
    RudderLogger.logDebug("ApplicationLifeCycleHandler: sendApplicationUpdated: Tracking Application Updated");
    RudderProperty property = new RudderProperty()
      .putValue("previous_version", previousVersion)
      .putValue(VERSION, currentVersion)
      .putValue("previous_build", previousBuild)
      .putValue("build", currentBuild);
    RudderClient.getInstance().track("Application Updated", property);
  }
}

class RudderAppInfo {
  int previousBuild;
  int currentBuild;
  String previousVersion;
  String currentVersion;
  PreferenceManager preferenceManager;


  RudderAppInfo(Application application) {
    try {
      this.preferenceManager = PreferenceManager.getInstance(application);
      previousBuild = preferenceManager.getBuildNumber();
      previousVersion = preferenceManager.getVersionName();
      RudderLogger.logDebug("Previous Installed Version: " + previousVersion);
      RudderLogger.logDebug("Previous Installed Build: " + previousBuild);
      String packageName = application.getPackageName();
      PackageManager packageManager = application.getPackageManager();
      if (packageManager == null)
        return;
      PackageInfo packageInfo = packageManager.getPackageInfo(packageName, 0);
      currentVersion = packageInfo.versionName;
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        currentBuild = (int) packageInfo.getLongVersionCode();
      } else {
        currentBuild = packageInfo.versionCode;
      }
      RudderLogger.logDebug("Current Installed Version: " + currentVersion);
      RudderLogger.logDebug("Current Installed Build: " + currentBuild);
    } catch (PackageManager.NameNotFoundException ex) {
      RudderLogger.logError(ex);
    }
  }

  /*
   * Call this method to store the Current Build and Current Version of the app.
   * In case of the LifeCycle events Application Installed or Application Updated only.
   */
  void storeCurrentBuildAndVersion() {
    preferenceManager.saveBuildNumber(currentBuild);
    preferenceManager.saveVersionName(currentVersion);
  }

  boolean isApplicationInstalled() {
    return this.previousBuild == -1;
  }

  boolean isApplicationUpdated() {
    return this.previousBuild != -1 && (this.previousBuild != this.currentBuild);
  }
}




