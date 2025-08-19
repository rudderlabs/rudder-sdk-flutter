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
  private Application application;
  private final RudderSdkFlutterPlugin plugin;

  ActivityLifeCycleManager(Context context, RudderSdkFlutterPlugin plugin) {
    this.application = (Application) context.getApplicationContext();
    this.plugin = plugin;
    this.application.registerActivityLifecycleCallbacks(this);
  }

  public static ActivityLifeCycleManager registerActivityLifeCycleCallBacks(Context context, RudderSdkFlutterPlugin plugin) {
    return new ActivityLifeCycleManager(context, plugin);
  }

  public void unregister() {
    if (this.application != null) {
      this.application.unregisterActivityLifecycleCallbacks(this);
      this.application = null;
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
