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
    private ServerManager serverManager;
    private ClipboardManager clipboardManager;

    @Override
    public void onCreate() {
        super.onCreate();

        clipboardManager = (ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);
        serverManager = new ServerManager(clipboardManager, SERVER_URI);
        serverManager.connect();

        clipboardManager.addPrimaryClipChangedListener(new ClipboardManager.OnPrimaryClipChangedListener() {
            @Override
            public void onPrimaryClipChanged() {
                String text = clipboardManager.getText().toString();
                long date = new Date().getTime();

                TextItem item = new TextItem(text, date);
                serverManager.copyItem(item);

                Log.d("ClipboardService", text);
            }
        });
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d("ClipboardService", "started");
        return START_STICKY;
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        Log.d("ClipboardService", "finished");
    }
}
