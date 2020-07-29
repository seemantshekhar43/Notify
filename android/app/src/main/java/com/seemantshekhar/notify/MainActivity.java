package com.seemantshekhar.notify;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;

import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    /*  Permission request code to draw over other apps  */
//    private static final int DRAW_OVER_OTHER_APP_PERMISSION_REQUEST_CODE = 1222;
//    private static final int STORAGE_WRITE_PERMISSION_REQUEST_CODE = 1223;
//    private static final int STORAGE_READ_PERMISSION_REQUEST_CODE = 1222;
//    private static final int SYSTEM_ALERT_WINDOW_PERMISSION_REQUEST_CODE = 1222;
    private static final int MULTI_REQUEST_CODE = 1224;
    private static final String CHANNEL = "com.seemantshekhar.notify/notify";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
            //If the draw over permission is not available open the settings screen
            //to grant the permission.

            if(checkMIUI()){

                AlertDialog.Builder alertadd = new AlertDialog.Builder(MainActivity.this);
                alertadd.setCancelable(false);
                LayoutInflater factory = LayoutInflater.from(MainActivity.this);
                final View view = factory.inflate(R.layout.dialog_image_layout, null);
                alertadd.setView(view);
                alertadd.setNeutralButton("OK!", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dlg, int sumthin) {
                        Intent intent = new Intent("miui.intent.action.APP_PERM_EDITOR"); intent.setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity"); intent.putExtra("extra_pkgname", getPackageName());
                        startActivity(intent);
                    }
                });

                alertadd.show();


            }else{
                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        Uri.parse("package:" + getPackageName()));
                startActivity(intent);
            }

            //startActivityForResult(intent, DRAW_OVER_OTHER_APP_PERMISSION_REQUEST_CODE);

        }
        super.onCreate(savedInstanceState);
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("getStatus")) {
                                String res = Helper.getInstance().fileName;
                                System.out.println("get status called res: "  + res);
                                result.success(res);
                                Helper.getInstance().fileName = "";
                            }else if(call.method.equals("startFloating")) {
                                //createFloatingWidget();
                                checkPermissions();
                                result.success("started");
                            }
                            else {
                                result.notImplemented();
                            }
                        }

                );
    }

//    @Override
//    public void onBackPressed() {
//        super.onBackPressed();
//        createFloatingWidget();
//
//    }



    /*  start floating widget service  */
//    public void createFloatingWidget() {
//        //Check if the application has draw over other apps permission or not?
//        //This permission is by default available for API<23. But for API > 23
//        //you have to ask for the permission in runtime.
//        boolean status  = true;
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
//            //If the draw over permission is not available open the settings screen
//            //to grant the permission.
//            status = false;
//            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                    Uri.parse("package:" + getPackageName()));
//            startActivity(intent);
//            //startActivityForResult(intent, DRAW_OVER_OTHER_APP_PERMISSION_REQUEST_CODE);
//
//        }
//        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
//            status = false;
//            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, STORAGE_READ_PERMISSION_REQUEST_CODE);
//        }
//
//        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
//            status = false;
//            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, STORAGE_READ_PERMISSION_REQUEST_CODE);
//        }
//
//
//            //If permission is granted start floating widget service
//            if(status)
//            startFloatingWidgetService();
//    }

    /*  Start Floating widget service and finish current activity */
    private void startFloatingWidgetService() {
        startService(new Intent(MainActivity.this, FloatingWidgetService.class));
        System.out.println("called");
        finish();

    }

//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        if (requestCode == DRAW_OVER_OTHER_APP_PERMISSION_REQUEST_CODE) {
//            //Check if the permission is granted or not.
//            if (resultCode == RESULT_OK)
//                //If permission granted start floating widget service
//                //
//                //startFloatingWidgetService();
//            {
//                Intent intent = new Intent("miui.intent.action.APP_PERM_EDITOR"); intent.setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity"); intent.putExtra("extra_pkgname", getPackageName()); startActivity(intent);
//            }
//            else {
////                //Permission is not available then display toast
////                Toast.makeText(this,
////                       "Draw over other app permission not available. App won\\'t work without permission. Please try again.",
////                        Toast.LENGTH_SHORT).show();
//                Intent intent = new Intent("miui.intent.action.APP_PERM_EDITOR"); intent.setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity"); intent.putExtra("extra_pkgname", getPackageName()); startActivity(intent);
//            }
//
//        } else {
//            super.onActivityResult(requestCode, resultCode, data);
//        }
//    }


    public void checkPermissions(){
        if(
            ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.READ_EXTERNAL_STORAGE)+
            ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE) !=
                PackageManager.PERMISSION_GRANTED
        ){
            ActivityCompat.requestPermissions(
                    MainActivity.this,
                    new String[]{
                            Manifest.permission.READ_EXTERNAL_STORAGE,
                            Manifest.permission.WRITE_EXTERNAL_STORAGE
                    }, MULTI_REQUEST_CODE
            );
        }else{
            startFloatingWidgetService();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if(requestCode == MULTI_REQUEST_CODE){
            if((grantResults.length> 0) && (grantResults[0] +  grantResults [1]) == PackageManager.PERMISSION_GRANTED){
                startFloatingWidgetService();
            }else{
                Toast.makeText(getApplicationContext(), "Grant permissions", Toast.LENGTH_SHORT).show();
            }
        }
    }

    private boolean checkMIUI(){
        String manufacturer = "xiaomi";
        return manufacturer.equalsIgnoreCase(Build.MANUFACTURER);
    }
}


