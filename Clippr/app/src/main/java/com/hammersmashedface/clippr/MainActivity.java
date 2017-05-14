package com.hammersmashedface.clippr;

import android.app.ListActivity;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends ListActivity {

    private ServerManager serverManager;
    private ClipboardManager clipboardManager;

    List<String> textList = new ArrayList<>();

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
        for (TextItem item : items) {
            textList.add(item.getText());
        }

        ListView listView = getListView();
        listView.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, textList.toArray(new String[textList.size()])));
        listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                clipboardManager.setText(textList.get(position));

                Toast.makeText(getApplicationContext(), "Copied", Toast.LENGTH_SHORT).show();

                return true;
            }
        });
    }
}
