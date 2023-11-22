package com.rudderstack.sdk.flutter.managers;

import androidx.annotation.Nullable;

import com.rudderstack.android.sdk.core.RudderClient;
import com.rudderstack.android.sdk.core.RudderLogger;
import com.rudderstack.android.sdk.core.util.Utils;

/**
 * This class is used to manage the user session using the native manual session tracking API i.e., startSession and endSession.
 */
public class UserSessionManager {
  private final long sessionTimeOut;
  private final PreferenceManager preferenceManager;
  private final boolean isAutoSessionTrackingEnabled;

  public UserSessionManager(
    boolean autoSessionTrackingEnabled,
    boolean autoTrackingLifeCycleEventsEnabled,
    PreferenceManager preferenceManager,
    long sessionTimeout) {
    this.sessionTimeOut = sessionTimeout;
    this.preferenceManager = preferenceManager;
    this.isAutoSessionTrackingEnabled = autoSessionTrackingEnabled && autoTrackingLifeCycleEventsEnabled;
  }

  /**
   * This method handles the auto session:
   * <p> If auto session tracking is </p>
   * <ol>
   *   <li> enabled in the config, then start a new auto session. </li>
   *   <li> disabled in the config, then check if there is any existing auto session and end it.</li>
   * </ol>
   */
  public void handleAutoSessionTracking() {
    if (isAutoSessionTrackingEnabled) {
      startAutoSessionIfNeeded();
    } else {
      endAutoSessionIfExists();
    }
  }

  /**
   * This method starts the auto session:
   * If there was an existing auto session from the previous run of the app, check if it is expired or not. If it is expired, start a new auto session, else continue with the existing auto session.
   */
  private void startAutoSessionIfNeeded() {
    if (this.preferenceManager.doesAutoSessionExists() && !isExistingAutoSessionExpired()) {
      RudderLogger.logVerbose("UserSessionManager: startAutoSessionIfNeeded: Continuing with the existing auto session");
    } else {
      RudderLogger.logVerbose("UserSessionManager: startAutoSessionIfNeeded: Starting a new auto session");
      startSession();
    }
    // save that an auto session exists to the preference manager
    this.preferenceManager.saveAutoSessionExists(true);
  }


  /**
   * This clears an auto session if it exists
   */
  private void endAutoSessionIfExists() {
    if (this.preferenceManager.doesAutoSessionExists()) {
      RudderLogger.logVerbose("UserSessionManager: endAutoSessionIfExists: Clearing the existing automatic session");
      endSession();
      // clear that an auto session exists from the preference manager
      this.preferenceManager.saveAutoSessionExists(false);
    }
  }


  /**
   * This checks if the existing auto session is expired or not
   *
   * @return true if the auto session is expired, false otherwise
   */
  private boolean isExistingAutoSessionExpired() {
    long currentTime = Utils.getCurrentTimeInMilliSeconds();
    long timeDifference;
    synchronized (this) {
      timeDifference = Math.abs(currentTime - this.preferenceManager.getLastEventTimestamp());
    }
    return timeDifference >= sessionTimeOut;
  }

  /**
   * This saves the event time
   */
  public void updateLastEventTimestamp() {
    this.preferenceManager.updateLastEventTimestamp();
  }

  /**
   * This starts a new manual session
   */
  void startSession() {
    if (RudderClient.getInstance() != null) {
      RudderClient.getInstance().startSession();
      RudderLogger.logVerbose("UserSessionManager: starting new session");
    }
  }

  /**
   * This starts a new manual session with the given session id
   *
   * @param sessionId the session id
   */
  void startSession(long sessionId) {
    if (RudderClient.getInstance() != null) {
      RudderClient.getInstance().startSession(sessionId);
      RudderLogger.logVerbose("UserSessionManager: starting new session with sessionId: " + sessionId);
    }
  }

  /**
   * This ends the session
   */
  void endSession() {
    if (RudderClient.getInstance() != null) {
      RudderClient.getInstance().endSession();
      RudderLogger.logVerbose("UserSessionManager: endSession: ending session");
    }
  }


  @Nullable
  Long getSessionId() {
    return (RudderClient.getInstance() != null) ? RudderClient.getInstance().getSessionId() : null;
  }
}

