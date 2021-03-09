package com.example.my_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val algoliaAPIAdapter = AlgoliaAPIFlutterAdapter("latency", "1f6fd3a6fb973cb08419fe7d288fa4db")

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            algoliaAPIAdapter.perform(call, result)
        }
    }

    companion object {
        private const val CHANNEL = "com.algolia/api"
    }
}
