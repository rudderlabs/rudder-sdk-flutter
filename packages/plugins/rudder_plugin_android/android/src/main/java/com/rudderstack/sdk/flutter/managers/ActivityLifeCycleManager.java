package com.rudderstack.sdk.flutter.managers;

import static com.rudderstack.sdk.flutter.LifeCycleRunnables.executeRunnableLifeCycleEvent;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import static com.rudderstack.sdk.flutter.LifeCycleRunnables.ApplicationOpenedRunnable;
import static com.rudderstack.sdk.flutter.LifeCycleRunnables.ApplicationBackgroundedRunnable;
import static com.rudderstack.sdk.flutter.LifeCycleRunnables.ScreenViewRunnable;
import com.rudderstack.sdk.flutter.RudderSdkFlutterPlugin;

import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicBoolean;

public class ActivityLifeCycleManager implements Application.ActivityLifecycleCallbacks {
  private static final AtomicInteger noOfActivities = new AtomicInteger(0);
  private static final AtomicBoolean fromBackground = new AtomicBoolean(false);

  private static volatile ActivityLifeCycleManager instance;

  private Application application;
  private RudderSdkFlutterPlugin plugin;

  private ActivityLifeCycleManager(Context context, RudderSdkFlutterPlugin plugin) {
    this.application = (Application) context.getApplicationContext();
    this.plugin = plugin;
    this.application.registerActivityLifecycleCallbacks(this);
  }

  /**
   * Registers lifecycle callbacks if not already registered.
   *
   * @param context the application context used to register lifecycle callbacks
   * @param plugin the plugin instance to receive lifecycle events
   */
  public static synchronized void registerIfNeeded(Context context, RudderSdkFlutterPlugin plugin) {
    if (instance == null) {
      instance = new ActivityLifeCycleManager(context, plugin);
    }
  }

  /**
   * Updates the plugin reference to route events to the initialized plugin.
   * Re-registers if callbacks were previously unregistered.
   *
   * @param context the application context used if re-registration is needed
   * @param plugin the plugin instance to receive lifecycle events
   */
  public static synchronized void setActivePlugin(Context context, RudderSdkFlutterPlugin plugin) {
    if (instance != null) {
      instance.plugin = plugin;
    } else {
      registerIfNeeded(context, plugin);
    }
  }

  /**
   * Called when a plugin is detaching. If the detaching plugin is the current
   * active plugin, unregisters lifecycle callbacks and clears the singleton.
   *
   * @param plugin the plugin that is detaching
   */
  public static synchronized void unregister(RudderSdkFlutterPlugin plugin) {
    if (instance != null && instance.plugin == plugin) {
      instance.application.unregisterActivityLifecycleCallbacks(instance);
      instance.application = null;
      instance = null;
    }
  }

  @Override
  public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
    // No action needed in this method
    // This method is intentionally left empty as there is no specific task to perform when the activity is created.
  }

  @Override
  public void onActivityStarted(@NonNull Activity activity) {
    if (noOfActivities.incrementAndGet() == 1) {
      executeRunnableLifeCycleEvent(this.plugin, new ApplicationOpenedRunnable(fromBackground.get()));
    }
    executeRunnableLifeCycleEvent(this.plugin, new ScreenViewRunnable(activity.getLocalClassName()));
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
    fromBackground.set(true);
    if (noOfActivities.decrementAndGet() == 0) {
      executeRunnableLifeCycleEvent(this.plugin, new ApplicationBackgroundedRunnable());
    }
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
}
