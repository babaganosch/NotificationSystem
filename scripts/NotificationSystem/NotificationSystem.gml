/**
*	GM 2.3 NotificationSystem | v1.0.0
*
*
*	Struct(s):
*		> NotificationSystem()
*		> Receiver()
*			- add(message, callback)
*			- remove(message)
*
*
*	Function(s):
*		> subscribe([id])
*		> unsubscribe([id])
*		> broadcast(message, [callback])
*
*
*	Author: Lars Andersson | @babaganosch
*						   | github.com/babaganosch/NotificationSystem
*/
global.__notifications__ = new NotificationSystem();
function NotificationSystem() constructor {
	
	_subscribers = [];
	_size = 0;
	
	static __subscribe__ = function(_id) {
		if (is_undefined(_id)) _id = other;
		for (var _i = 0; _i < _size; _i++)
			if (_subscribers[_i] == _i) return;
		_subscribers[_i] = _id;
		_size++;
	}
	
	static __unsubscribe__ = function(_id) {
		if (is_undefined(_id)) _id = other;
		var _newSubscribers = [];
		var _j = 0;
		for (var _i = 0; _i < _size; _i++)
		{
			if (_subscribers[_i] != _id)
			{
				_newSubscribers[_j] = _subscribers[_i];
				_j++;
			}
		}
		_subscribers = _newSubscribers;
		_size = _j;
	}
	
	static __broadcast__ = function(_msg, _cb) {
		for (var _i = 0; _i < _size; _i++)
		{
			if (instance_exists(_subscribers[_i]) && 
				variable_instance_exists(_subscribers[_i], "__notificationsReceiver__"))
				_subscribers[_i].__notificationsReceiver__.__receive__(_msg, _cb);
		}
	}
	
}

function subscribe(_id) {
	global.__notifications__.__subscribe__(argument[0]);
}

function unsubscribe(_id) {
	global.__notifications__.__unsubscribe__(argument[0]);
}

function broadcast(_msg, _cb) {
	global.__notifications__.__broadcast__(_msg, _cb);
}




function Receiver() constructor {
	
	_events = [];
	_size = 0;
	_parent = other;
	
	if (variable_instance_exists(other, "__notificationsReceiver__")) { 
		var _message = "-- WARNING --\nObject " + string(object_get_name(other.object_index) + ": Notification receiver already exists.");
		show_error(_message, true);
	}
	variable_instance_set(other, "__notificationsReceiver__", self);
	
	static add = function(_event, _cb) {
		_events[_size] = {
			event: _event,
			callback: _cb
		}
		_size++;
	}
	
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
				if (!is_undefined(_trigger) && _trigger) _events[_i].callback();
			}
		}
		_events = _newEvents;
		_size = _j;
	}
	
	static __receive__ = function(_msg, _cb) {
		for (var _i = 0; _i < _size; _i++)
		{
			if (_events[_i].event == _msg) 
			{
				_events[_i].callback();
				if (!is_undefined(_cb)) method(_parent, _cb)();
			}
		}
	}
}