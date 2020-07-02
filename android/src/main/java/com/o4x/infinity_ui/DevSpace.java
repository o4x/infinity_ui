package com.o4x.infinity_ui;

import android.app.Activity;
import android.content.Context;
import android.graphics.Point;
import android.graphics.Rect;
import android.os.Build;
import android.util.Log;
import android.view.Display;
import android.view.Window;
import android.view.WindowManager;

import java.lang.reflect.InvocationTargetException;

class DevSpace {

    private static Point getRealScreenSize(Context context) {
        WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        Display display = windowManager.getDefaultDisplay();
        Point size = new Point();

        if (Build.VERSION.SDK_INT >= 17) {
            display.getRealSize(size);
        } else if (Build.VERSION.SDK_INT >= 14) {
            try {
                size.x = (Integer) Display.class.getMethod("getRawWidth").invoke(display);
                size.y = (Integer) Display.class.getMethod("getRawHeight").invoke(display);
            } catch (IllegalAccessException ignored) {} catch (InvocationTargetException ignored) {} catch (NoSuchMethodException ignored) {}
        }

        return size;
    }

    private static double devicePixelRatio(Activity activity) {
        return activity.getBaseContext().getResources().getDisplayMetrics().density;
    }

    public static double getNavigationBarHeight(Activity activity) {
        Rect rectangle = new Rect();
        Window window = activity.getWindow();
        window.getDecorView().getWindowVisibleDisplayFrame(rectangle);
        final int height = getRealScreenSize(activity.getApplicationContext()).y;
        final double nv = (height - rectangle.bottom) / devicePixelRatio(activity);
        return nv;
    }

    public static double getStatusBarHeight(Activity activity) {
        int result = 0;
        int resourceId = activity.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = activity.getResources().getDimensionPixelSize(resourceId);
        }
        return result / devicePixelRatio(activity);
    }

    public static double getStatusLSBarHeight(Activity activity) {
        int result = 0;
        int resourceId = activity.getResources().getIdentifier("status_bar_height_landscape", "dimen", "android");
        if (resourceId > 0) {
            result = activity.getResources().getDimensionPixelSize(resourceId);
        }
        return result / devicePixelRatio(activity);
    }
}
