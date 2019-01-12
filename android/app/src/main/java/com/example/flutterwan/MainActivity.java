package com.example.flutterwan;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private final static String CHANNEL_NATIVE = "channel_native";
    private final static String METHOD_SHARE = "method_share";
    private final static String METHOD_COPY = "method_copy";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(this.getFlutterView(), CHANNEL_NATIVE).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        switch (call.method) {
                            case METHOD_SHARE:
                                share((String) call.arguments);
                                break;
                            case METHOD_COPY:
                                copy((List<String>) call.arguments);
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

    private void copy(final List<String> args) {
        final ClipboardManager cmb = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
        cmb.setPrimaryClip(ClipData.newPlainText("text", args.get(0)));
        Toast.makeText(MainActivity.this, args.get(1), Toast.LENGTH_SHORT).show();
//        cmb.addPrimaryClipChangedListener(new ClipboardManager.OnPrimaryClipChangedListener() {
//            @Override
//            public void onPrimaryClipChanged() {
//                if (cmb.hasPrimaryClip()) {
//                }
//            }
//        });
    }

}
