package com.rudderstack.sdk.flutter;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;

public class LifeCycleRunnables {

  public static final List<RunnableLifeCycleEventsInterface> runnableLifeCycleEvents = new ArrayList<>();

  interface RunnableLifeCycleEventsInterface {
    void run(@NonNull RudderSdkFlutterPlugin plugin);
  }

  public static class ApplicationOpenedRunnable implements RunnableLifeCycleEventsInterface {
    boolean fromBackground;

    public ApplicationOpenedRunnable(boolean fromBackground) {
      this.fromBackground = fromBackground;
    }

    @Override
    public void run(@NonNull RudderSdkFlutterPlugin plugin) {
      plugin.trackApplicationOpened(fromBackground);
    }
  }

  public static class ApplicationBackgroundedRunnable implements RunnableLifeCycleEventsInterface {

    @Override
    public void run(@NonNull RudderSdkFlutterPlugin plugin) {
      plugin.trackApplicationBackgrounded();
    }
  }

  public static class ScreenViewRunnable implements RunnableLifeCycleEventsInterface {
    String activityName;

    public ScreenViewRunnable(String activityName) {
      this.activityName = activityName;
    }

    @Override
    public void run(@NonNull RudderSdkFlutterPlugin plugin) {
      plugin.trackScreen(activityName);
    }
  }

  public static void executeRunnableLifeCycleEvent(@NonNull RudderSdkFlutterPlugin plugin, RunnableLifeCycleEventsInterface lifeCycleEvent) {
    if (!RudderSdkFlutterPlugin.isInitialized.get()) {
      runnableLifeCycleEvents.add(lifeCycleEvent);
    } else {
      lifeCycleEvent.run(plugin);
    }
  }
}
