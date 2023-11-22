package com.rudderstack.sdk.flutter.managers;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.rudderstack.sdk.flutter.RudderSdkFlutterPlugin;


import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

public class ActivityLifeCycleManager implements Application.ActivityLifecycleCallbacks {
  public static final List<Runnable> runnableTasks = new ArrayList<>();
  private AtomicInteger noOfActivities;
  private boolean fromBackground = false;

  ActivityLifeCycleManager(Context context) {
    this.noOfActivities = new AtomicInteger(0);
    Application application = (Application) context.getApplicationContext();
    application.registerActivityLifecycleCallbacks(this);
  }

  public static void registerActivityLifeCycleCallBacks(Context context) {
    new ActivityLifeCycleManager(context);
  }

  @Override
  public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
    // No action needed in this method
    // This method is intentionally left empty as there is no specific task to perform when the activity is created.
  }

  @Override
  public void onActivityStarted(@NonNull Activity activity) {
    if (noOfActivities.incrementAndGet() == 1) {
      Runnable runnableTask = () -> RudderSdkFlutterPlugin.getInstance().trackApplicationOpened(fromBackground);
      executeRunnable(runnableTask);
    }
    Runnable runnableTask = () -> RudderSdkFlutterPlugin.getInstance().trackScreen(activity);
    executeRunnable(runnableTask);
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
    fromBackground = true;
    if (noOfActivities.decrementAndGet() == 0) {
      Runnable runnableTask = () -> RudderSdkFlutterPlugin.getInstance().trackApplicationBackgrounded();
      executeRunnable(runnableTask);
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

  private static void executeRunnable(Runnable runnableTask) {
    if (RudderSdkFlutterPlugin.getInstance() == null) {
      runnableTasks.add(runnableTask);
    } else {
      runnableTask.run();
    }
  }
}
