package com.rudderstack.sdk.flutter.managers;

import static com.rudderstack.sdk.flutter.LifeCycleRunnables.executeEarlyLifeCycleEvent;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import static com.rudderstack.sdk.flutter.LifeCycleRunnables.DeepLinkOpenedRunnable;
import com.rudderstack.sdk.flutter.RudderSdkFlutterPlugin;

public class EarlyActivityLifeCycleManager implements Application.ActivityLifecycleCallbacks {
  private static String lastProcessedDeepLink = null;
  private static EarlyActivityLifeCycleManager instance = null;

  private Application application;
  private RudderSdkFlutterPlugin plugin;

  private EarlyActivityLifeCycleManager(Application application) {
    this.application = application;
    this.application.registerActivityLifecycleCallbacks(this);
  }

  /**
   * Initialize the early activity lifecycle manager
   * Called by legacy code or direct initialization
   */
  public static synchronized void initialize(Application application) {
    if (instance == null) {
      instance = new EarlyActivityLifeCycleManager(application);
    }
  }

  /**
   * Initialize the early activity lifecycle manager from Context
   * Called by App Startup initializer to ensure early registration
   */
  public static synchronized void initialize(Context context) {
    if (instance == null) {
      Application application = (Application) context.getApplicationContext();
      instance = new EarlyActivityLifeCycleManager(application);
    }
  }

  /**
   * Set the plugin instance when Flutter plugin is ready
   */
  public static synchronized void setPlugin(RudderSdkFlutterPlugin plugin) {
    if (instance != null) {
      instance.plugin = plugin;
    }
  }

  /**
   * Get the current instance
   */
  public static EarlyActivityLifeCycleManager getInstance() {
    return instance;
  }

  /**
   * Cleanup method for testing or shutdown scenarios
   */
  public static synchronized void cleanup() {
    if (instance != null) {
      instance.unregister();
      instance = null;
    }
  }

  /**
   * Legacy method for backward compatibility
   */
  public static EarlyActivityLifeCycleManager registerEarlyActivityLifeCycleCallBacks(Context context, RudderSdkFlutterPlugin plugin) {
    Application application = (Application) context.getApplicationContext();
    initialize(application);
    setPlugin(plugin);
    return instance;
  }

  /**
   * Unregister this activity lifecycle manager from the application
   */
  public void unregister() {
    if (this.application != null) {
      this.application.unregisterActivityLifecycleCallbacks(this);
      this.plugin = null;
      this.application = null;
    }
  }

  @Override
  public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
    // Check for deeplink when activity is created - this captures app launch deeplinks
    checkForDeepLink(activity);
  }

  @Override
  public void onActivityStarted(@NonNull Activity activity) {
    // No action needed in this method
    // This method is intentionally left empty as deeplink detection is handled in onActivityCreated.
  }

  @Override
  public void onActivityResumed(@NonNull Activity activity) {
    // No action needed in this method
    // This method is intentionally left empty as there is no specific task to perform when the activity is resumed.
  }

  @Override
  public void onActivityPaused(@NonNull Activity activity) {
    // No action needed in this method
    // This method is intentionally left empty as there is no specific task to perform when the activity is paused.
  }

  @Override
  public void onActivityStopped(@NonNull Activity activity) {
    // No action needed in this method
    // This method is intentionally left empty as there is no specific task to perform when the activity is stopped.
  }

  @Override
  public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
    // No action needed in this method
    // This method is intentionally left empty as there is no specific task to perform when saving the instance state of the activity.
  }

  @Override
  public void onActivityDestroyed(@NonNull Activity activity) {
    // No action needed in this method
    // This method is intentionally left empty as there is no specific task to perform when the activity is destroyed.
  }

  /**
   * Checks if the activity was launched with a deeplink intent
   * @param activity The activity to check
   */
  private void checkForDeepLink(@NonNull Activity activity) {
    Intent intent = activity.getIntent();
    if (intent == null) {
      return;
    }

    if (intent.getData() == null) {
      return;
    }

    Uri data = intent.getData();
    String url = data.toString();

    // Prevent duplicate deeplink events for the same URL
    if (url.equals(lastProcessedDeepLink)) {
      return;
    }
    lastProcessedDeepLink = url;

    String referrer = getReferrer(activity, intent);

    // Execute the deeplink event - LifeCycleRunnables handles queueing if plugin not ready
    // If plugin is null or RudderSdkFlutterPlugin.isInitialized is false, the event will be queued
    // If initialized, it will execute immediately
    executeEarlyLifeCycleEvent(this.plugin, new DeepLinkOpenedRunnable(url, referrer));
  }

  private String getReferrer(@NonNull Activity activity, @NonNull Intent intent) {
    // For Android API 22+ (LOLLIPOP_MR1), use the native getReferrer() method
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP_MR1) {
      Uri referrerUri = activity.getReferrer();
      if (referrerUri != null) {
        return referrerUri.toString();
      }
    }

    // Fallback for older versions
    Uri referrerUri = getReferrerCompatible(intent);
    return referrerUri != null ? referrerUri.toString() : null;
  }

  private Uri getReferrerCompatible(@NonNull Intent intent) {
    Uri referrerUri = null;

    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
      referrerUri = intent.getParcelableExtra(Intent.EXTRA_REFERRER, Uri.class);
    } else {
      referrerUri = intent.getParcelableExtra(Intent.EXTRA_REFERRER);
    }

    if (referrerUri != null) {
      return referrerUri;
    }

    // Final fallback: Try to get referrer from REFERRER_NAME extra
    String referrerName = intent.getStringExtra("android.intent.extra.REFERRER_NAME");
    if (referrerName != null && !referrerName.isEmpty()) {
      try {
        return Uri.parse(referrerName);
      } catch (Exception ignored) {
        // If parsing fails, return null
      }
    }

    return null;
  }
}
