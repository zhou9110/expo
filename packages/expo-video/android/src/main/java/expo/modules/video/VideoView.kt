package expo.modules.video

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.ActivityInfo
import android.view.View
import androidx.core.content.ContextCompat
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.SimpleExoPlayer
import androidx.media3.ui.PlayerControlView
import androidx.media3.ui.PlayerView
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.exception.Exceptions
import expo.modules.kotlin.views.ExpoView


@SuppressLint("ViewConstructor")
class VideoView(
  context: Context,
  appContext: AppContext
) : ExpoView(context, appContext) {
  var isFullScreen = false
  private val activity
    get() = appContext.currentActivity ?: throw Exceptions.MissingActivity()

  var player: ExoPlayer? = null
    set(value) {
      field = value
      playerView.player = value?.apply {
        prepare()
      }
    }

  val playerView = PlayerView(context)

  fun releasePlayer() {
    player?.release()
    player = null
    playerView.player = null
  }

  fun enterFullScreen() {
    if (isFullScreen) {
      return
    }
    activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
    playerView.setBackgroundColor(ContextCompat.getColor(activity, R.color.black))

    val params = playerView.layoutParams
    params.width = LayoutParams.MATCH_PARENT
    params.height = LayoutParams.MATCH_PARENT
    playerView.layoutParams = params

    activity.actionBar?.hide()

    WindowCompat.setDecorFitsSystemWindows(activity.window, false)
    WindowInsetsControllerCompat(activity.window, playerView).let { controller ->
      controller.hide(WindowInsetsCompat.Type.systemBars())
      controller.systemBarsBehavior = WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
    }

    isFullScreen = true
  }

  fun exitFullScreen() {
    if (!isFullScreen) {
      return
    }
    activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR
    playerView.setBackgroundColor(ContextCompat.getColor(activity, R.color.black))

    val params = playerView.layoutParams
    params.width = LayoutParams.MATCH_PARENT
    params.height = this.height
    playerView.layoutParams = params

    activity.actionBar?.show()

    WindowCompat.setDecorFitsSystemWindows(activity.window, true)
    WindowInsetsControllerCompat(activity.window, playerView).show(WindowInsetsCompat.Type.systemBars())
    isFullScreen = false
  }

  init {
    val matchParent = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
    layoutParams = matchParent
    addView(playerView, matchParent)
  }
}