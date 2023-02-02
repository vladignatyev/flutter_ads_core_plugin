package me.taplika.flutter_ads_core_plugin;

import android.os.Build;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Handler;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

/** FlutterAdsCorePlugin */
public class FlutterAdsCorePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private FlutterEngine flutterEngine;

  private Map<String, GoogleMobileAdsPlugin.NativeAdFactory> factories = new HashMap<>();

  private void setFactories(ActivityPluginBinding binding) {
    // здесь добавлять фабрики

    factories.put("listTile", new ListTileNativeAdFactory(binding.getActivity()));
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    Log.d("Plugin", "onAttachedToEngine");

    flutterEngine = flutterPluginBinding.getFlutterEngine();

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

  }

  public void setTimeout(Runnable runnable, int delay){
    new Thread(() -> {
      try {
        Thread.sleep(delay);
        runnable.run();
      }
      catch (Exception e){
        System.err.println(e);
      }
    }).start();
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {

    try {
      setFactories(binding);
      flutterEngine.getPlugins().add(new GoogleMobileAdsPlugin());

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
        factories.forEach((factoryName, factory) -> {
          GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, factoryName, factory);
        });
      }

    } catch (Exception e) {
      Log.e("AdsPlugin", e.getMessage());
    }

  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
