package com.xxh.melodify

import android.media.audiofx.BassBoost
import android.media.audiofx.Equalizer
import android.media.audiofx.Virtualizer
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class EqualizerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private var equalizer: Equalizer? = null
    private var bassBoost: BassBoost? = null
    private var virtualizer: Virtualizer? = null

    companion object {
        private const val TAG = "MelodifyEqualizer"
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(binding.binaryMessenger, "com.xxh.melodify/equalizer")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        dispose()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "init" -> result.success(initEqualizer())
                "setBandGains" -> {
                    val gains = call.argument<List<Int>>("gains") ?: return result.error("ARGS", "gains required", null)
                    setBandGains(gains)
                    result.success(true)
                }
                "setBassBoost" -> {
                    val level = call.argument<Int>("level") ?: 0
                    setBassBoostLevel(level)
                    result.success(true)
                }
                "setBalance" -> {
                    val balance = call.argument<Double>("balance") ?: 0.0
                    setBalance(balance)
                    result.success(true)
                }
                "setEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    setEnabled(enabled)
                    result.success(true)
                }
                "dispose" -> {
                    dispose()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("EQ_ERROR", e.message, null)
        }
    }

    private fun initEqualizer(): Boolean {
        return try {
            // Priority 0 = global output mix (works for all apps)
            equalizer = Equalizer(0, 0).apply {
                enabled = true
            }
            bassBoost = BassBoost(0, 0).apply {
                enabled = true
            }
            Log.i(TAG, "Equalizer initialized: ${equalizer?.numberOfBands} bands, min=${equalizer?.bandLevelRange?.get(0)}")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to init equalizer: ${e.message}")
            false
        }
    }

    private fun setBandGains(gains: List<Int>) {
        val eq = equalizer ?: return
        val numBands = eq.numberOfBands.toInt()
        val range = eq.bandLevelRange ?: return
        val minLevel = range[0].toInt() // Usually -1500 millibels
        val maxLevel = range[1].toInt() // Usually +1500 millibels

        for (i in 0 until minOf(gains.size, numBands)) {
            // gains are in centibels (e.g., 500 = +5.0dB), convert to millibels
            val targetMb = gains[i] * 10
            val clamped = targetMb.coerceIn(minLevel, maxLevel)
            eq.setBandLevel(i.toShort(), clamped.toShort())
        }
        Log.d(TAG, "Band gains set: ${gains.take(5)}")
    }

    private fun setBassBoostLevel(db: Int) {
        val bb = bassBoost ?: return
        if (db > 0) {
            bb.enabled = true
            // BassBoost strength: 0-1000 (0% to 100%)
            val strength = (db * 1000 / 12).coerceIn(0, 1000)
            bb.setStrength(strength.toShort())
        } else {
            bb.enabled = false
        }
    }

    private fun setBalance(balance: Double) {
        // Android Virtualizer doesn't do balance — we simulate by
        // adjusting left/right channel volume via equalizer if possible.
        // For now, set virtualizer strength based on balance.
        // Future: use AudioTrack per-channel volume
    }

    private fun setEnabled(enabled: Boolean) {
        equalizer?.enabled = enabled
        bassBoost?.enabled = enabled
    }

    private fun dispose() {
        try {
            equalizer?.enabled = false
            equalizer?.release()
            equalizer = null
            bassBoost?.enabled = false
            bassBoost?.release()
            bassBoost = null
            Log.i(TAG, "Equalizer disposed")
        } catch (e: Exception) {
            Log.e(TAG, "Dispose error: ${e.message}")
        }
    }
}
