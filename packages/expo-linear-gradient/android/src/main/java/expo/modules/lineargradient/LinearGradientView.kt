package expo.modules.lineargradient

import android.annotation.SuppressLint
import android.content.Context
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.views.ExpoView

@SuppressLint("ViewConstructor")
class LinearGradientView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {
  var colors by mutableStateOf(listOf(Color.White, Color.Black))
  var locations by mutableStateOf<List<Float>?>(null)
  var startPos by mutableStateOf(Offset.Zero)
  var endPos by mutableStateOf(Offset.Infinite)

  init {
    addView(ComposeView(context).apply {
      setContent {
        LinearGradient(
          locations = locations,
          colors = colors,
          startPoint = startPos,
          endPoint = endPos
        )
      }
    })
  }
}

@Composable
fun LinearGradient(
  modifier: Modifier = Modifier,
  locations: List<Float>?,
  colors: List<Color>,
  startPoint: Offset = Offset.Zero,
  endPoint: Offset = Offset.Infinite
) {
  val colorStops = locations?.zip(colors)?.toTypedArray()

  val brush = if (colorStops != null) {
    Brush.linearGradient(
      colorStops = colorStops,
      start = startPoint,
      end = endPoint
    )
  } else {
    Brush.linearGradient(
      colors = colors,
      start = startPoint,
      end = endPoint
    )
  }

  Box(modifier = modifier
    .fillMaxSize()
    .background(brush)
  )
}

@Preview(showBackground = true)
@Composable
fun LinearGradient_Preview() {
  LinearGradient(
    modifier = Modifier
      .size(200.dp),
    locations = null,
    colors = listOf(Color.White, Color.Red)
  )
}
