package se.rf.idrottonline.group;

import java.util.HashMap;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;
import org.json.JSONArray;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;



public class InterfaceBridgePlugin extends CordovaPlugin {
	final static String TAG = InterfaceBridgePlugin.class.getSimpleName();

	public static final String ACTION_SHOW = "Show";
	public static final String ACTION_DISABLE = "Disable";
	public static final String ACTION_HIDE = "Hide";
		
	private CallbackContext _callback;
	
	
	private HashMap<String, String> _callbackMap = new HashMap<String, String>();
	private BroadCastListener _bridgeListener;
	
	private class BroadCastListener extends BroadcastReceiver 
    {
				
		public BroadCastListener() {
			
		}
    
		@Override
		public void onReceive(Context context, Intent intent) {
			Bundle extras = intent.getExtras();
			String callback = _callbackMap.get(intent.getAction());
			if (callback != null && extras != null) {
				String message = "{\"type\":\"" + extras.getString("Action") + "\", \"element\":\"" + extras.getString("Element") + "\", \"text\":\"" + (extras.getString("Text") == null ? "" : extras.getString("Text")) + "\"}";
	            PluginResult pr = new PluginResult(PluginResult.Status.OK, message);
	            boolean keepOpen = extras.getBoolean("KeepOpen");
				pr.setKeepCallback(keepOpen);
				if (!keepOpen) {
					_callbackMap.remove(intent.getAction());
				}
				
				webView.sendPluginResult(pr, callback);
				
			}
			
		}
	}
	
	public InterfaceBridgePlugin() {
		
	}
	
	
	
	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		// TODO Auto-generated method stub
		super.initialize(cordova, webView);
		
		IntentFilter bridgeFilter = new IntentFilter("SuperPowers");
		bridgeFilter.addAction("LeftMenuButton");
		bridgeFilter.addAction("CenterMenuButton");
		bridgeFilter.addAction("RightMenuButton");
		bridgeFilter.addAction("BottomLeftMenuButton");
		bridgeFilter.addAction("BottomCenterMenuButton");
		bridgeFilter.addAction("BottomCenter2MenuButton");
		bridgeFilter.addAction("BottomRightMenuButton");
		bridgeFilter.addAction("OFFLINE");
		bridgeFilter.addAction("ONLINE");
		bridgeFilter.addAction("AppVersion");
		bridgeFilter.addAction("PushService");
		
		
		_bridgeListener = new BroadCastListener();
		
	    this.cordova.getActivity().registerReceiver(_bridgeListener, bridgeFilter);
		
	}
	
	
	@Override
	public void onDestroy() {
		
		try {
			if (_bridgeListener != null) {
				this.cordova.getActivity().unregisterReceiver(_bridgeListener);
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		super.onDestroy();
	}

	@Override
	public boolean execute(String action, JSONArray data, CallbackContext callbackContext) {

		_callback = callbackContext;
		/*
		 * public string Action { get; private set; } public string Element {
		 * get; private set; } public string Text { get; private set; } public
		 * bool KeepOpen { get; private set; }
		 */

		//Log.i(TAG, "InterfaceBridgePlugin: " + action);
		
		PluginResult result = null;
		try {

			if (ACTION_DISABLE.equals(action)) {
				Intent intent = new Intent(
						InterfaceBridgePlugin.class.getSimpleName());
				intent.putExtra("Action", "Disable");
				intent.putExtra("Element", data.getString(0));
				this.cordova.getActivity().sendBroadcast(intent);

				result = new PluginResult(Status.OK, "[]");
				result.setKeepCallback(false);
			} else if (ACTION_HIDE.equals(action)) {

				Intent intent = new Intent(
						InterfaceBridgePlugin.class.getSimpleName());
				intent.putExtra("Action", "Hide");
				intent.putExtra("Element", data.getString(0));
				this.cordova.getActivity().sendBroadcast(intent);

				result = new PluginResult(Status.OK, "[]");
				result.setKeepCallback(false);
			} else if (ACTION_SHOW.equals(action)) {
				String element = data.getString(0);
				_callbackMap.put(element, callbackContext.getCallbackId());
				String text = data.getString(1);
				boolean keepOpen = data.getBoolean(2);
				Intent intent = new Intent(
						InterfaceBridgePlugin.class.getSimpleName());
				intent.putExtra("Action", "Show");
				intent.putExtra("Element", element);
				intent.putExtra("Text", text);
				this.cordova.getActivity().sendBroadcast(intent);
				
				result = new PluginResult(Status.OK, "[]");
				result.setKeepCallback(keepOpen);

			} else {
				Log.e(TAG, "InterfaceBridgePlugin - invalid action");
				result = new PluginResult(Status.INVALID_ACTION, "[]");
			}
		} catch (Exception e) {
			Log.e(TAG, "InterfaceBridgePlugin - Error: " + e.getMessage());
			result = new PluginResult(Status.ERROR, "[]");
		}
		//callbackContext.sendPluginResult(result);
		return true;
		
	}

}