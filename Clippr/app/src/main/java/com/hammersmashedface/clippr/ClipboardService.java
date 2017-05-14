package com.hammersmashedface.clippr;

import android.app.Service;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.util.Log;

import java.util.Date;

public class ClipboardService extends Service {
    private static final String TAG = "ClipboardService";

    private ServerManager serverManager;
    private ClipboardManager clipboardManager;

    @Override
    public void onCreate() {
        super.onCreate();

        clipboardManager = (ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);
        clipboardManager.addPrimaryClipChangedListener(new ClipboardManager.OnPrimaryClipChangedListener() {
            @Override
            public void onPrimaryClipChanged() {
                String text = clipboardManager.getText().toString();
                long date = new Date().getTime();

                TextItem item = new TextItem(text, date);
                serverManager.copyItem(item);
            }
        });

        serverManager = new ServerManager(SERVER_URI);
        serverManager.addCopyHandler(new ServerManager.CopyHandler() {
            @Override
            public void handleItem(TextItem item) {
                String currentText = clipboardManager.getText().toString();

                // TODO: This is a workaround
                // Fix copy-paste cycle to clipboard
                if (!currentText.equals(item.getText())) {
                    clipboardManager.setText(item.getText());
                }
            }
        });
        serverManager.connect();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i(TAG, "started");
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        Log.i(TAG, "finished");
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
