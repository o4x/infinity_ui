package com.o4x.infinity_ui;

import android.app.Activity;
import android.content.res.Resources;
import android.os.Build;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;

import java.util.Arrays;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** InfinityUiPlugin */
public class InfinityUiPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "infinity_ui");
    channel.setMethodCallHandler(new InfinityUiPlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "infinity_ui");
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
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  static Activity activity;

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getNavigationBarHeight")) {
      result.success(getNavigationBarHeight());
    } else if (call.method.equals("enableInfinity")) {
      result.success(enableInfinity());
    } else if (call.method.equals("disableInfinity")) {
      result.success(disableInfinity());
    } else {
      result.notImplemented();
    }
  }

  public double getNavigationBarHeight() {
      Resources resources = activity.getBaseContext().getResources();
        int resourceId = resources.getIdentifier("navigation_bar_height", "dimen", "android");
        if (resourceId > 0) {
            return resources.getDimensionPixelSize(resourceId);
        }
        return 0;
  }

  public double getStatusBarHeight() {
    Resources resources = activity.getBaseContext().getResources();
    int resourceId = resources.getIdentifier("status_bar_height", "dimen", "android");
    if (resourceId > 0) {
        return resources.getDimensionPixelSize(resourceId);
    }
    return 0;
  }

  public List<Double> enableInfinity() {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            Window w = activity.getWindow(); // in Activity's onCreate() for instance
            w.setFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
      } else {
          return Arrays.asList(0.0, 0.0);
      }
      return Arrays.asList( getStatusBarHeight(), getNavigationBarHeight());
  }

  public int disableInfinity() {
    Window w = activity.getWindow(); // in Activity's onCreate() for instance
    w.clearFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
    return 0;
  }
}
