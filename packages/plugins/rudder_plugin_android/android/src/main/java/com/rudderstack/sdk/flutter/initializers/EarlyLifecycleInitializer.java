package com.rudderstack.sdk.flutter.initializers;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.startup.Initializer;

import com.rudderstack.sdk.flutter.managers.EarlyActivityLifeCycleManager;

import java.util.Collections;
import java.util.List;

/**
 * App Startup initializer for early activity lifecycle management.
 * This initializer uses AndroidX App Startup library to automatically initialize
 * the EarlyActivityLifeCycleManager at app startup, ensuring we can capture
 * initial activity events including deeplinks from the very first activity creation.
 *
 * This approach is more efficient than direct ContentProvider usage and provides
 * better dependency management and initialization order control.
 *
 * @author RudderStack
 */
public class EarlyLifecycleInitializer implements Initializer<EarlyActivityLifeCycleManager> {

    /**
     * Initializes the EarlyActivityLifeCycleManager.
     * This method is called automatically by the App Startup library at application startup,
     * before any activities are created, ensuring we don't miss the initial activity events.
     *
     * @param context The application context
     * @return The initialized EarlyActivityLifeCycleManager instance
     */
    @NonNull
    @Override
    public EarlyActivityLifeCycleManager create(@NonNull Context context) {
        // Initialize the early activity lifecycle manager
        // This will register the lifecycle callbacks with the application
        EarlyActivityLifeCycleManager.initialize(context);
        // Return the singleton instance
        return EarlyActivityLifeCycleManager.getInstance();
    }

    /**
     * Returns the list of dependencies for this initializer.
     * Since EarlyActivityLifeCycleManager doesn't depend on other libraries,
     * we return an empty list.
     *
     * @return An empty list as there are no dependencies
     */
    @NonNull
    @Override
    public List<Class<? extends Initializer<?>>> dependencies() {
        // No dependencies on other initializers
        return Collections.emptyList();
    }
}
