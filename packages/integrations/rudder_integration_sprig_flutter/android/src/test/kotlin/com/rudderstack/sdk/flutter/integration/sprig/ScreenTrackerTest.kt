package com.rudderstack.sdk.flutter.integration.sprig

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertSame

class ScreenTrackerTest {
    private class Screen(val name: String)

    private class Integration {
        var screen: Screen? = null
        var calls = 0
    }

    private val tracker = ScreenTracker<Screen, Integration> { integration, screen ->
        integration.screen = screen
        integration.calls++
    }

    @Test
    fun `an integration made before any screen resumes gets the next resumed screen, and loses it on pause`() {
        val integration = Integration()
        val screen = Screen("main")

        tracker.track(integration)
        assertNull(integration.screen)

        tracker.onResumed(screen)
        assertSame(screen, integration.screen)

        tracker.onPaused(screen)
        assertNull(integration.screen)
    }

    @Test
    fun `an integration made while a screen is resumed gets that screen at once`() {
        val screen = Screen("main")
        tracker.onResumed(screen)

        val integration = Integration()
        tracker.track(integration)

        assertSame(screen, integration.screen)
    }

    @Test
    fun `an integration that outlives its screen gets the screen of the next engine`() {
        val integration = Integration()
        val first = Screen("first engine")
        val second = Screen("second engine")
        tracker.onResumed(first)
        tracker.track(integration)

        tracker.onPaused(first)
        tracker.onResumed(second)

        assertSame(second, integration.screen)
    }

    @Test
    fun `a screen that is not the resumed one does not clear the integrations when it pauses`() {
        val integration = Integration()
        val older = Screen("older")
        val newer = Screen("newer")
        tracker.track(integration)
        tracker.onResumed(older)
        tracker.onResumed(newer)
        val callsBefore = integration.calls

        tracker.onPaused(older)

        assertSame(newer, integration.screen)
        assertEquals(callsBefore, integration.calls)
    }

    @Test
    fun `when the newest of two resumed screens pauses, the integrations get the other screen`() {
        val integration = Integration()
        val left = Screen("left of split screen")
        val right = Screen("right of split screen")
        tracker.track(integration)
        tracker.onResumed(left)
        tracker.onResumed(right)

        tracker.onPaused(right)

        assertSame(left, integration.screen)
    }

    @Test
    fun `a screen that resumes twice is cleared by one pause`() {
        val integration = Integration()
        val screen = Screen("activity with two Flutter engines")
        tracker.track(integration)
        tracker.onResumed(screen)
        tracker.onResumed(screen)

        tracker.onPaused(screen)

        assertNull(integration.screen)
    }

    @Test
    fun `when the last engine detaches from a resumed screen, the integrations get the screen that resumed before it`() {
        val integration = Integration()
        val older = Screen("other resumed screen")
        val host = Screen("native activity that removes its Flutter fragment")
        tracker.track(integration)
        tracker.onAttached(older)
        tracker.onResumed(older)
        tracker.onAttached(host)
        tracker.onResumed(host)

        tracker.onDetached(host)

        assertSame(older, integration.screen)
    }

    @Test
    fun `a screen stays while another engine still shows on it`() {
        val integration = Integration()
        val screen = Screen("activity with two Flutter engines")
        tracker.track(integration)
        tracker.onAttached(screen)
        tracker.onAttached(screen)
        tracker.onResumed(screen)

        tracker.onDetached(screen)
        assertSame(screen, integration.screen)

        tracker.onDetached(screen)
        assertNull(integration.screen)
    }
}
