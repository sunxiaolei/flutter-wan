package com.example.flutterwan;

import android.content.Intent;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private final static String CHANNEL_SHARE = "channel_share";
    private final static String METHOD_SHARE = "method_share";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(this.getFlutterView(), CHANNEL_SHARE).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        switch (call.method) {
                            case METHOD_SHARE:
                                share((String) call.arguments);
                                break;
                        }
                    }
                }
        );
    }

    private void share(String args) {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("text/plain");
        intent.putExtra(Intent.EXTRA_SUBJECT, "WanFlutter");
        intent.putExtra(Intent.EXTRA_TEXT, args);
        startActivity(Intent.createChooser(intent, "分享"));

    }

}
