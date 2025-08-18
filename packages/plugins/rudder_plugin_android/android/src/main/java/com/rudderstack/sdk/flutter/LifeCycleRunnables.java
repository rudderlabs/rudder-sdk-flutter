package com.rudderstack.sdk.flutter;

import java.util.ArrayList;
import java.util.List;

public class LifeCycleRunnables {

  public static final List<RunnableLifeCycleEventsInterface> runnableLifeCycleEvents = new ArrayList<>();

  interface RunnableLifeCycleEventsInterface {
    void run();
  }

  public static class ApplicationOpenedRunnable implements RunnableLifeCycleEventsInterface {
    boolean fromBackground;
    RudderSdkFlutterPlugin plugin;

    public ApplicationOpenedRunnable(RudderSdkFlutterPlugin plugin, boolean fromBackground) {
      this.plugin = plugin;
      this.fromBackground = fromBackground;
    }

    @Override
    public void run() {
      if (plugin != null) {
        plugin.trackApplicationOpened(fromBackground);
      }
    }
  }

  public static class ApplicationBackgroundedRunnable implements RunnableLifeCycleEventsInterface {
    RudderSdkFlutterPlugin plugin;

    public ApplicationBackgroundedRunnable(RudderSdkFlutterPlugin plugin) {
      this.plugin = plugin;
    }

    @Override
    public void run() {
      if (plugin != null) {
        plugin.trackApplicationBackgrounded();
      }
    }
  }

  public static class ScreenViewRunnable implements RunnableLifeCycleEventsInterface {
    String activityName;
    RudderSdkFlutterPlugin plugin;

    public ScreenViewRunnable(RudderSdkFlutterPlugin plugin, String activityName) {
      this.plugin = plugin;
      this.activityName = activityName;
    }

    @Override
    public void run() {
      if (plugin != null) {
        plugin.trackScreen(activityName);
      }
    }
  }

  public static void executeRunnableLifeCycleEvent(RunnableLifeCycleEventsInterface lifeCycleEvent) {
    if (!RudderSdkFlutterPlugin.isInitialized.get()) {
      runnableLifeCycleEvents.add(lifeCycleEvent);
    } else {
      lifeCycleEvent.run();
    }
  }
}
