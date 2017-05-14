package com.hammersmashedface.clippr;

import android.content.ClipboardManager;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.Arrays;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class ServerManager {
    private Socket socket;
    private ClipboardManager clipboardManager;

    public ServerManager(ClipboardManager clipboardManager, String uri) {
        this.clipboardManager = clipboardManager;

        try {
            socket = IO.socket(uri);
        } catch (URISyntaxException exception) {
            Log.e(getClass().getName(), exception.getMessage());
        }
    }

    public void connect() {
        socket.on(Socket.EVENT_CONNECT, new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                 Log.d(getClass().getName(), "Connected");
            }
        }).on("copy_text", new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                JSONObject json = (JSONObject)args[0];
                TextItem item = null;

                try {
                    item = new TextItem(json);
                } catch (JSONException exception) {
                    Log.e(getClass().getName(), exception.getMessage());
                }

                if (item != null)
                {
                    String currentText = clipboardManager.getText().toString();

                    // TODO: This is a workaround
                    // Fix copy-paste cycle to clipboard
                    if (!currentText.equals(item.getText())) {
                        clipboardManager.setText(item.getText());
                    }
                }
            }
        }).on("history", new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                Log.d(getClass().getName(), Arrays.toString(args));
            }
        });
        socket.connect();

        Log.v("ServerManager", Boolean.toString(socket.connected()));
    }

    public void fetchHistory() {
        socket.emit("history", "");
    }

    public void copyItem(TextItem item) {
        try {
            JSONObject json = item.getJSONObject();
            socket.emit("copy_text", json);
        } catch (JSONException exception) {
            Log.e(getClass().getName(), exception.getMessage());
        }
    }
}
