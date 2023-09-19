package expo.modules.lineargradient

import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class LinearGradientModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("ExpoLinearGradient")

    View(LinearGradientView::class) {
      Prop("colors") { view, colors: List<Int> ->
        view.colors = colors.map { Color(it) }
      }

      Prop("locations") { view, locations: List<Float>? ->
        locations?.let {
          view.locations = it
        }
      }

      Prop("startPoint") { view, startPoint: Pair<Float, Float>? ->
        startPoint?.let {
          view.startPos = Offset(it.first, it.second)
        }
      }

      Prop("endPoint") { view, endPoint: Pair<Float, Float>? ->
        endPoint?.let {
          view.endPos = Offset(it.first, it.second)
        }
      }

      Prop("borderRadii") { view, borderRadii: FloatArray? ->
      }
    }
  }
}
