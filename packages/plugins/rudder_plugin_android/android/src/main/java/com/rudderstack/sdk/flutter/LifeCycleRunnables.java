package com.rudderstack.sdk.flutter;

import java.util.ArrayList;
import java.util.List;

public class LifeCycleRunnables {

  public static final List<RunnableLifeCycleEventsInterface> runnableLifeCycleEvents = new ArrayList<>();

  interface RunnableLifeCycleEventsInterface {
    void run(RudderSdkFlutterPlugin plugin);
  }

  public static class ApplicationOpenedRunnable implements RunnableLifeCycleEventsInterface {
    boolean fromBackground;

    public ApplicationOpenedRunnable(boolean fromBackground) {
      this.fromBackground = fromBackground;
    }

    @Override
    public void run(RudderSdkFlutterPlugin plugin) {
      plugin.trackApplicationOpened(fromBackground);
    }
  }

  public static class ApplicationBackgroundedRunnable implements RunnableLifeCycleEventsInterface {

    @Override
    public void run(RudderSdkFlutterPlugin plugin) {
      plugin.trackApplicationBackgrounded();
    }
  }

  public static class ScreenViewRunnable implements RunnableLifeCycleEventsInterface {
    String activityName;

    public ScreenViewRunnable(String activityName) {
      this.activityName = activityName;
    }

    @Override
    public void run(RudderSdkFlutterPlugin plugin) {
      plugin.trackScreen(activityName);
    }
  }

  public static void executeRunnableLifeCycleEvent(RudderSdkFlutterPlugin plugin, RunnableLifeCycleEventsInterface lifeCycleEvent) {
    if (!RudderSdkFlutterPlugin.isInitialized.get() || plugin == null) {
      runnableLifeCycleEvents.add(lifeCycleEvent);
    } else {
      lifeCycleEvent.run(plugin);
    }
  }
}
