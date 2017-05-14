package com.hammersmashedface.clippr;

import android.app.ListActivity;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class MainActivity extends ListActivity {

    private ServerManager serverManager;
    private ClipboardManager clipboardManager;

    List<String> textList = new ArrayList<>();
    ArrayAdapter<String> adapter;

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
                        Collections.sort(items, new Comparator<TextItem>() {
                            @Override
                            public int compare(TextItem firstItem, TextItem secondItem) {
                                return firstItem.getTimestamp() > secondItem.getTimestamp() ? -1 : 1;
                            }
                        });

                        for (TextItem item : items) {
                            textList.add(item.getText());
                        }

                        adapter.notifyDataSetChanged();
                    }
                });
            }
        });
        serverManager.addCopyHandler(new ServerManager.CopyHandler() {
            @Override
            public void handleItem(final TextItem item) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        textList.add(0, item.getText());
                        adapter.notifyDataSetChanged();
                    }
                });
            }
        });

        startClipboardService();
        setupListView();
    }

    private void startClipboardService() {
        Intent clipboardService = new Intent(this, ClipboardService.class);
        startService(clipboardService);
    }

    private void setupListView() {
        adapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, textList);
        setListAdapter(adapter);

        getListView().setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                clipboardManager.setText(textList.get(position));

                Toast.makeText(getApplicationContext(), "Copied", Toast.LENGTH_SHORT).show();

                return true;
            }
        });
    }
}
