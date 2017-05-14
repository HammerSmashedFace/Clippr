package com.hammersmashedface.clippr;

import android.app.Service;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.util.Log;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class ClipboardService extends Service {
    private static final String TAG = "ClipboardService";

    private ServerManager serverManager;
    private ClipboardManager clipboardManager;

    private TextItem lastLoadedItem;

    @Override
    public void onCreate() {
        super.onCreate();

        clipboardManager = (ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);
        clipboardManager.addPrimaryClipChangedListener(new ClipboardManager.OnPrimaryClipChangedListener() {
            @Override
            public void onPrimaryClipChanged() {
                String text = clipboardManager.getText().toString();

                if (lastLoadedItem == null || !lastLoadedItem.getText().equals(text)) {
                    long date = new Date().getTime();

                    TextItem item = new TextItem(text, date);

                    serverManager.copyItem(item);
                }
            }
        });

        serverManager = new ServerManager(SERVER_URI);
        serverManager.addCopyHandler(new ServerManager.CopyHandler() {
            @Override
            public void handleItem(TextItem item) {
                lastLoadedItem = item;
                clipboardManager.setText(lastLoadedItem.getText());
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
