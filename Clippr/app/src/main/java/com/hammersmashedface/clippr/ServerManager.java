package com.hammersmashedface.clippr;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class ServerManager {
    private static final String TAG = "ServerManager";

    private static final String EVENT_COPY_TEXT = "copy_text";
    private static final String EVENT_HISTORY = "history";

    private Socket socket;

    public ServerManager(String uri) {
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
                Log.i(TAG, Socket.EVENT_CONNECT);
            }
        });
        socket.on(Socket.EVENT_CONNECT_ERROR, new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                Log.i(TAG, Socket.EVENT_CONNECT_ERROR);
            }
        });
        socket.on(Socket.EVENT_DISCONNECT, new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                Log.i(TAG, Socket.EVENT_DISCONNECT);
            }
        });
        socket.connect();
    }

    public void copyItem(TextItem item, final ServerManager.CopyHandler handler) {
        try {
            if (handler != null) {
                socket.on(EVENT_COPY_TEXT, handler);
            }

            JSONObject json = item.getJSONObject();
            socket.emit(EVENT_COPY_TEXT, json);
        } catch (JSONException exception) {
            Log.e(TAG, exception.getMessage());
        }
    }

    public void fetchHistory(final ServerManager.HistoryHandler handler) {
        if (handler != null) {
            socket.on(EVENT_HISTORY, handler);
        }

        socket.emit(EVENT_HISTORY, "");
    }

    static class CopyHandler implements Emitter.Listener {

        @Override
        public final void call(Object... args) {
            JSONObject json = (JSONObject)args[0];
            TextItem item = null;

            try {
                item = new TextItem(json);
            } catch (JSONException exception) {
                Log.e(TAG, exception.getMessage());
            }

            handleItem(item);
        }

        public void handleItem(TextItem item) {}
    }

    static class HistoryHandler implements Emitter.Listener {

        @Override
        public final void call(Object... args) {
            List<TextItem> list = new ArrayList<>();

            for (Object object : args) {
                try {
                    list.add(new TextItem((JSONObject)object));
                } catch (JSONException exception) {
                    Log.e(TAG, exception.getMessage());
                }
            }

            handleItems(list);
        }

        public void handleItems(List<TextItem> items) {}
    }
}
