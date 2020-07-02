package com.o4x.infinity_ui;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.res.Resources;
import android.os.Build;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.util.Arrays;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** InfinityUiPlugin */
public class InfinityUiPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "infinity_ui");
    channel.setMethodCallHandler(new InfinityUiPlugin());
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    activity = activityPluginBinding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  @SuppressLint("StaticFieldLeak")
  private static Activity activity;

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "enableInfinity":
        result.success(enableInfinity());
        break;
      case "disableInfinity":
        result.success(disableInfinity());
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private List<Double> enableInfinity() {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            Window w = activity.getWindow();
            w.setFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
      } else {
          return Arrays.asList(0.0, 0.0, 0.0);
      }
      return Arrays.asList( DevSpace.getStatusBarHeight(activity), DevSpace.getStatusLSBarHeight(activity), DevSpace.getNavigationBarHeight(activity));
  }

  private int disableInfinity() {
    Window w = activity.getWindow();
    w.clearFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
    return 0;
  }
}