package me.taplika.flutter_ads_core_plugin;

import android.content.Context;
import android.os.Build;
import android.util.Log;

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

  private static final String TAG = "FlutterAdsCorePlugin";

  private FlutterEngine flutterEngine;
  public void bindAdFactories(ActivityPluginBinding binding) {
    Log.d(TAG, "bindAdFactories");

    Context context = (Context) binding.getActivity();

    LayoutPresets.factories.forEach((factoryName, factory) -> {
      factory.setContext(context);
    });
  }
  public void unbindAdFactories() {
    Log.d(TAG, "unbindAdFactories");

    LayoutPresets.factories.forEach((factoryName, factory) -> {
      factory.setContext(null);
    });
  }


  private void registerAdFactories() {
    Log.d(TAG, "registerAdFactories");

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) { // TODO: ???

      LayoutPresets.factories.forEach((factoryName, factory) -> {
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, factoryName, factory);
      });
    }
  }
  private void unregisterAdFactories() {
    Log.d(TAG, "unregisterAdFactories");

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) { // TODO: ???

      LayoutPresets.factories.forEach((factoryName, factory) -> {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, factoryName);
      });
    }
  }


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    Log.d(TAG, "onAttachedToEngine");

    flutterEngine = flutterPluginBinding.getFlutterEngine();
    flutterEngine.getPlugins().add(new GoogleMobileAdsPlugin());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    Log.d(TAG, "onDetachedFromEngine");

    unbindAdFactories();
    unregisterAdFactories();
    flutterEngine = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

  }


  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    Log.d(TAG, "onAttachedToActivity");

    bindAdFactories(binding);
    registerAdFactories();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    Log.d(TAG, "onDetachedFromActivityForConfigChanges");

    unbindAdFactories();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    Log.d(TAG, "onReattachedToActivityForConfigChanges");

    bindAdFactories(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    Log.d(TAG, "onDetachedFromActivity");

    unbindAdFactories();
  }
}
