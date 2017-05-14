package com.hammersmashedface.clippr;

import android.app.ListActivity;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.util.List;

public class MainActivity extends ListActivity {

    private ServerManager serverManager;
    private ClipboardManager clipboardManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        clipboardManager = (ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);

        serverManager = new ServerManager(SERVER_URI);
        serverManager.connect();
        serverManager.fetchHistory(new ServerManager.HistoryHandler() {
            @Override
            public void handleItems(final List<TextItem> items) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        updateListView(items);
                    }
                });
            }
        });

        startClipboardService();
    }

    private void startClipboardService() {
        Intent clipboardService = new Intent(this, ClipboardService.class);
        startService(clipboardService);
    }

    private void updateListView(List<TextItem> items) {
        String[] textArray = new String[items.size()];
        for (int i = 0; i < items.size(); i++) {
            textArray[i] = items.get(i).getText();
        }

        ListView listView = getListView();
        listView.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, textArray));
    }
}
