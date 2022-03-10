package com.rudderstack.sdk.flutter;


import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

public class ActivityLifeCycleHandler implements Application.ActivityLifecycleCallbacks {

    static List<Runnable> runnableTasks = new ArrayList<>();
    private static int noOfActivities;

    ActivityLifeCycleHandler(Context context) {
        Application application = (Application) context.getApplicationContext();
        application.registerActivityLifecycleCallbacks(this);
    }

    static void registerActivityLifeCycleCallBacks(Context context) {
        new ActivityLifeCycleHandler(context);
    }

    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

    }

    @Override
    public void onActivityStarted(@NonNull Activity activity) {
        Runnable runnableTask = () -> {
            if (RudderSdkFlutterPlugin.trackLifeCycleEvents) {
                noOfActivities += 1;
                if (noOfActivities == 1) {
                    // no previous activity present. Application Opened
                    RudderSdkFlutterPlugin.rudderClient.track("Application Opened");
                }
            }
        };
        if (RudderSdkFlutterPlugin.rudderClient == null && !RudderSdkFlutterPlugin.initialized) {
            runnableTasks.add(runnableTask);
            return;
        }
        runnableTask.run();
    }

    @Override
    public void onActivityResumed(@NonNull Activity activity) {

    }

    @Override
    public void onActivityPaused(@NonNull Activity activity) {
    }

    @Override
    public void onActivityStopped(@NonNull Activity activity) {
        Runnable runnableTask = () -> {
            if (RudderSdkFlutterPlugin.trackLifeCycleEvents) {
                noOfActivities -= 1;
                if (noOfActivities == 0) {
                    RudderSdkFlutterPlugin.rudderClient.track("Application Backgrounded");
                }
            }
        };
        if (RudderSdkFlutterPlugin.rudderClient == null && !RudderSdkFlutterPlugin.initialized) {
            runnableTasks.add(runnableTask);
            return;
        }
        runnableTask.run();
    }

    @Override
    public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(@NonNull Activity activity) {

    }
}