package com.hammersmashedface.clippr;

import android.util.Log;

import org.json.JSONArray;
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

    private List<CopyHandler> copyHandlers;

    public ServerManager(String uri) {
        try {
            socket = IO.socket(uri);
        } catch (URISyntaxException exception) {
            Log.e(TAG, exception.getMessage());
        }

        copyHandlers = new ArrayList<>();
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
        socket.on(EVENT_COPY_TEXT, new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                try {
                    JSONObject json = (JSONObject) args[0];
                    TextItem item = new TextItem(json);

                    for (CopyHandler handler : copyHandlers) {
                        handler.handleItem(item);
                    }
                } catch (JSONException exception) {
                    Log.e(TAG, exception.getMessage());
                }
            }
        });
        socket.connect();
    }

    public void copyItem(TextItem item) {
        try {
            JSONObject json = item.getJSONObject();
            socket.emit(EVENT_COPY_TEXT, json);
        } catch (JSONException exception) {
            Log.e(TAG, exception.getMessage());
        }
    }

    public void addCopyHandler(CopyHandler copyHandler) {
        copyHandlers.add(copyHandler);
    }

    public void removeCopyHandler(CopyHandler copyHandler) {
        copyHandlers.remove(copyHandler);
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

            JSONArray jsonArray = (JSONArray)args[0];
            for (int i = 0; i < jsonArray.length(); i++) {
                try {
                    list.add(new TextItem((JSONObject) jsonArray.get(i)));
                } catch (JSONException exception) {
                    Log.e(TAG, exception.getMessage());
                }
            }

            handleItems(list);
        }

        public void handleItems(List<TextItem> items) {}
    }
}
