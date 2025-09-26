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

  public static class DeepLinkOpenedRunnable implements RunnableLifeCycleEventsInterface {
    String url;
    String referrer;

    public DeepLinkOpenedRunnable(String url, String referrer) {
      this.url = url;
      this.referrer = referrer;
    }

    @Override
    public void run(@NonNull RudderSdkFlutterPlugin plugin) {
      plugin.trackDeepLinkOpened(url, referrer);
    }
  }

  public static void executeRunnableLifeCycleEvent(@NonNull RudderSdkFlutterPlugin plugin, RunnableLifeCycleEventsInterface lifeCycleEvent) {
    if (!RudderSdkFlutterPlugin.isInitialized.get()) {
      runnableLifeCycleEvents.add(lifeCycleEvent);
    } else {
      lifeCycleEvent.run(plugin);
    }
  }

  /**
   * Execute lifecycle event for early initialization scenarios where plugin might be null
   * If plugin is null or SDK not initialized, the event will be queued for later execution
   */
  public static void executeEarlyLifeCycleEvent(RudderSdkFlutterPlugin plugin, RunnableLifeCycleEventsInterface lifeCycleEvent) {
    if (plugin == null || !RudderSdkFlutterPlugin.isInitialized.get()) {
      runnableLifeCycleEvents.add(lifeCycleEvent);
    } else {
      lifeCycleEvent.run(plugin);
    }
  }
}
