package com.hammersmashedface.clippr;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class MainActivity extends AppCompatActivity {
    private ServerManager serverManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

//        ClipboardManager clipboardManager = (ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);
//        serverManager = new ServerManager(clipboardManager, SERVER_URI);
//        serverManager.connect();

        Intent clipboardService = new Intent(this, ClipboardService.class);
        startService(clipboardService);
    }
}
