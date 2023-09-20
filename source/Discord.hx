package;

import Sys.sleep;
import discord_rpc.DiscordRpc;

#if LUA_ALLOWED
import llua.Lua;
import llua.State;
#end

using StringTools;

class DiscordClient
{
	public static var isInitialized:Bool = false;

	public function new(client_ID:String = "863222024192262205")
	{
		trace("Discord: Starting...");
		DiscordRpc.start({
            clientID: client_ID,
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord: Started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
		}

		DiscordRpc.shutdown();
	}
	
	public static function shutdown()
	{
		DiscordRpc.shutdown();
		trace('Discord: Has shutdown.');
	}
	
	static function onReady()
	{
		DiscordRpc.presence({
			details: "In the Menus",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "Vs. Foxa 3.0"
		});
	}

	static function onError(_code:Int, _message:String)
	{
		trace('Discord: Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Discord: Disconnected! $_code : $_message');
	}

    public static function initialize(clientID:String = "863222024192262205"){
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient(clientID);
		});
		trace("Discord: Initialized!");
		isInitialized = true;
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0) endTimestamp = startTimestamp + endTimestamp;

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: "Vs. Foxa 3.0",
			smallImageKey : smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000)
		});
	}

	#if LUA_ALLOWED
	public static function addLuaCallbacks(lua:State) {
		Lua_helper.add_callback(lua, "changePresence", function(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float) {
			changePresence(details, state, smallImageKey, hasStartTimestamp, endTimestamp);
		});

		Lua_helper.add_callback(lua, "changeClientID", function(newID:String) {
			shutdown();
			initialize(newID);
		});
	}
	#end
}
