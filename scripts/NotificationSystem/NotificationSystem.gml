/**
*	GMS 2.3+ NotificationSystem | v1.2.0
*
*
*	Struct(s):
*		> NotificationSystem()
*		> Receiver(subscribe)
*			- add(message, [callback])
*			- remove(message)
*
*
*	Function(s):
*		> subscribe([id, channel])
*		> unsubscribe([id, channel])
*		> broadcast(message, [callback, data])
*		> broadcast_channel(message, channel, [callback, data])
*
*
*	Author: Lars Andersson	| @babaganosch
*							| github.com/babaganosch/NotificationSystem
*/
global.__notifications__ = new NotificationSystem();
#macro __NOTIFICATIONS_SAFE true


/// @struct		NotificationSystem()
function NotificationSystem() constructor {
	
	_subscribers = [];
	_channels = {};
	
	/// @func		__subscribe_channel__(channel, id)
	/// @param		{string}	channel		Name of the channel
	/// @param		{real}		id			Id of the instance to subscribe
	/// @returns	N/A
	static __subscribe_channel__ = function(_channel, _id) {
		
		var _list = variable_struct_get(_channels, _channel);
		if (is_undefined(_list)) variable_struct_set(_channels, _channel, [ _id ]);
		else
		{
			var _size = array_length(_list);
			for (var _i = 0; _i < _size; _i++)
			{
				if (_list[_i] == _id) return;	
			}
			_list[_size] = _id;
			variable_struct_set(_channels, _channel, _list);
		}
	}
	
	/// @func		__subscribe__(id)
	/// @param		{real}	id				Id of the instance to subscribe
	/// @returns	N/A
	static __subscribe__ = function(_id) {
		var _size = array_length(_subscribers);
		for (var _i = 0; _i < _size; _i++)
			if (_subscribers[_i] == _id) return;
		_subscribers[_size] = _id;
	}
	
	/// @func		__unsubscribe__(id)
	/// @param		{real}	id				Id of the instance to unsubscribe
	/// @returns	N/A
	static __unsubscribe__ = function(_id) {
		var _newSubscribers = [], _j = 0;
		for (var _i = 0; _i < array_length(_subscribers); _i++)
		{
			if (_subscribers[_i] != _id)
			{
				_newSubscribers[_j++] = _subscribers[_i];
			}
		}
		_subscribers = _newSubscribers;
		
		var _nameList = variable_struct_get_names(_channels);
		for (var _i = 0; _i < array_length(_nameList); _i++)
		{
			var _list = variable_struct_get(_channels, _nameList[_i]);
			var _newList = [], _z = 0;
			for (var _j = 0; _j < array_length(_list); _j++)
			{
				if (_list[_j] != _id)
				{
					_newList[_z++] = _list[_j];
				}
			}
			variable_struct_set(_channels, _nameList[_i], _newList);
		}
	}
	
	/// @func		__unsubscribe_channel__(channel, id)
	/// @param		{string}	channel		Name of the channel
	/// @param		{real}		id			Id of the instance to unsubscribe
	/// @returns	N/A
	static __unsubscribe_channel__ = function(_channel, _id) {
		var _list = variable_struct_get(_channels, _channel);
		if (is_undefined(_list)) return;
		
		var _newList = [], _j = 0;
		for (var _i = 0; _i < array_length(_list); _i++)
		{
			if (_list[_i] != _id)
			{
				_newList[_j++] = _list[_i];
			}
		}
		variable_struct_set(_channels, _channel, _newList);
	}
	
	/// @func		__broadcast__(message, [callback, data])
	/// @param		{enum}	 message		Message to broadcast to the receivers
	/// @param		{string} channel		Name of the channel
	/// @param		{func}	 callback		Additional callback
	/// @param		{any}	 data			Data given to callback on receiver side
	/// @returns	N/A
	static __broadcast__ = function(_msg, _channel, _cb, _data) {
		var _list;
		if (is_string(_channel))
		{
			_list = variable_struct_get(_channels, _channel);
			if (is_undefined(_list))
			{
				if (__NOTIFICATIONS_SAFE) show_error("Channel '" + _channel + "' does not exist!", true);	
			}
		} else
		{
			_list = _subscribers;
		}
		
		for (var _i = 0; _i < array_length(_list); _i++)
		{
			if (instance_exists(_list[_i]) && 
				variable_instance_exists(_list[_i], "__notificationsReceiver__"))
				_list[_i].__notificationsReceiver__.__receive__(_msg, _cb, _data);
		}
	}
	
}

/// @func		subscribe([id, channel])
/// @param		{real}		[id]		Id of the instance to subscribe | Default: id of the caller
/// @param		{string}	[channel]	Name of the channel	| Default: no channel
/// @returns	N/A
function subscribe(_id, _channel) {
	if (is_string(argument[0])) _channel = _id;
	if (is_undefined(argument[0])) _id = self;
	global.__notifications__.__subscribe__(_id);
	if (!is_undefined(_channel))
		global.__notifications__.__subscribe_channel__(_channel, _id);
}

/// @func		unsubscribe([id, channel])
/// @param		{real}		[id]		Id of the instance to unsubscribe | Default: id of the caller
/// @param		{string}	[channel]	Name of the channel	| Default: no channel
/// @returns	N/A
function unsubscribe(_id, _channel) {
	if (is_string(argument[0])) _channel = _id;
	if (is_undefined(argument[0])) _id = self;
	global.__notifications__.__unsubscribe__(_id);
	if (!is_undefined(_channel))
		global.__notifications__.__unsubscribe_channel__(_channel, _id);
}

/// @func		broadcast(message, [callback, data])
/// @param		{enum}	message			Message to broadcast to the receivers
/// @param		{func}	[callback]		Callback function | Default: undefined
/// @param		{any}	[data]			Data given to callback on receiver side | Default: -1
/// @returns	N/A
function broadcast(_msg, _cb, _data) {
	broadcast_channel(argument[0], undefined, _cb, _data);
}

/// @func		broadcast_channel(message, channel, [callback, data])
/// @param		{enum}		message		Message to broadcast to the receivers
/// @param		{string}	channel		Name of the channel
/// @param		{func}		[callback]	Callback function | Default: undefined
/// @param		{any}		[data]		Data given to callback on receiver side | Default: -1
/// @returns	N/A
function broadcast_channel(_msg, _channel, _cb, _data) {
	
	if (is_undefined(_data)) _data = -1;
	if (!is_undefined(_cb) && !is_method(_cb)) 
	{
		_data = _cb;
		_cb = undefined;
	}
	global.__notifications__.__broadcast__(argument[0], _channel, _cb, _data);
}


/// @struct		Receiver(subscribe)
/// @param		{bool|string}	subscribe	Auto subscribe | Default: true
function Receiver(_sub) constructor {
	
	_events = [];
	_size = 0;
	_parent = other;
	
	if (variable_instance_exists(other, "__notificationsReceiver__")) { 
		var _message = "-- WARNING --\nObject " + string(object_get_name(other.object_index) + ": Notification receiver already exists.");
		show_error(_message, true);
	}
	variable_instance_set(other, "__notificationsReceiver__", self);
	
	if (!is_undefined(_sub))
	{
		if (is_string(_sub))
			subscribe(other, argument[0]);
	} else
	{
		subscribe(other);
	}
	
	/// @func		add(message, [callback])
	/// @param		{enum}	message			Message to listen for
	/// @param		{func}	[callback]		Callback function to run when message received
	/// @returns	N/A
	static add = function(_event, _cb) {
		_events[_size] = {
			event: argument[0],
			callback: _cb
		}
		_size++;
	}
	
	/// @func		remove(message, [trigger])
	/// @param		{enum}	message			Message to stop listening for
	/// @param		{bool}	[trigger]		Run callback once before deletion | Default: false
	/// @returns	N/A
	static remove = function(_event, _trigger) {
		var _newEvents = [];
		var _j = 0;
		for (var _i = 0; _i < _size; _i++)
		{
			if (_events[_i].event != _event)
			{
				_newEvents[_j] = _events[_i];
				_j++;
			} else
			{
				if (!is_undefined(_trigger) && argument[1]) _events[_i].callback();
			}
		}
		_events = _newEvents;
		_size = _j;
	}
	
	/// @func		__receive__(message, callback, data)
	/// @param		{enum}	message			Message to receive
	/// @param		{func}	callback		Additional callback to run
	/// @param		{any}	data			Data given to callback on receiver side
	/// @returns	N/A
	static __receive__ = function(_msg, _cb, _data) {
		for (var _i = 0; _i < _size; _i++)
		{
			if (_events[_i].event == _msg) 
			{
				var _fn = _events[_i].callback;
				if (!is_undefined(_fn)) _fn(_data);
				if (!is_undefined(_cb)) method(_parent, _cb)();
			}
		}
	}
}