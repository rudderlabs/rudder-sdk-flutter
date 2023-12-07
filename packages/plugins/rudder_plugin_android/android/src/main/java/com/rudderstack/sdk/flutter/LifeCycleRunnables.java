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

    public ApplicationOpenedRunnable(boolean fromBackground) {
      this.fromBackground = fromBackground;
    }

    @Override
    public void run() {
      RudderSdkFlutterPlugin.getInstance().trackApplicationOpened(fromBackground);
    }
  }

  public static class ApplicationBackgroundedRunnable implements RunnableLifeCycleEventsInterface {

    @Override
    public void run() {
      RudderSdkFlutterPlugin.getInstance().trackApplicationBackgrounded();
    }
  }

  public static class ScreenViewRunnable implements RunnableLifeCycleEventsInterface {
    String activityName;

    public ScreenViewRunnable(String activityName) {
      this.activityName = activityName;
    }

    @Override
    public void run() {
      RudderSdkFlutterPlugin.getInstance().trackScreen(activityName);
    }
  }

  public static void executeRunnableLifeCycleEvent(RunnableLifeCycleEventsInterface lifeCycleEvent) {
    if (RudderSdkFlutterPlugin.getInstance() == null || !RudderSdkFlutterPlugin.isInitialized.get()) {
      runnableLifeCycleEvents.add(lifeCycleEvent);
    } else {
      lifeCycleEvent.run();
    }
  }
}
