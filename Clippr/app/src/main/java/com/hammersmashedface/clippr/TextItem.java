package com.hammersmashedface.clippr;

import org.json.JSONException;
import org.json.JSONObject;

public class TextItem {

    private String text;
    private long timestamp;

    public TextItem(String text, long timestamp) {
        this.text = text;
        this.timestamp = timestamp;
    }

    public TextItem(JSONObject json) throws JSONException {
        this(json.getString("text"), json.getLong("timestamp"));
    }

    public String getText() {
        return text;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public JSONObject getJSONObject() throws JSONException {
        JSONObject json = new JSONObject();

        json.put("text", text);
        json.put("date", timestamp);

        return json;
    }
}
