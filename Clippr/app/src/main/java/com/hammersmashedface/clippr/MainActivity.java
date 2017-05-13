package com.hammersmashedface.clippr;

import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class MainActivity extends AppCompatActivity {
    private SocketController socketController;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

//        ClipboardManager clipboardManager = (ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);
//        socketController = new SocketController(clipboardManager, SERVER_URI);
//        socketController.connect();

        Intent clipboardService = new Intent(this, ClipboardService.class);
        startService(clipboardService);
    }
}
