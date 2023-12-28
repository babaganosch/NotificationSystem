/**
*   GMS 2.3+ NotificationSystem | v1.2.6
*
*
*   Struct(s):
*       > NotificationSystem()
*       > Receiver([subscribe])
*           - add(message, [callback])
*           - on(message, [callback])
*           - remove(message)
*
*
*   Function(s):
*       > channel_exists(channel)
*       > log_channels()
*       > subscribe([id, channel])
*       > unsubscribe([id, channel])
*       > broadcast(message, [callback, data])
*       > broadcast_channel(message, channel, [callback, data])
*
*
*   Author: Lars Andersson  | @babaganosch
*                           | github.com/babaganosch/NotificationSystem
*/
global.__notifications__ = new NotificationSystem();
#macro __NOTIFICATIONS_SAFE       true
#macro __AUTO_SUBSCRIBE_TO_GLOBAL true

// feather ignore GM1042

/// @struct     NotificationSystem()
function NotificationSystem() constructor {
    
    _subscribers = [];
    _channels = {};
    
    /// @param      {string}           channel     Name of the channel
    /// @param      {Id.Instance}      id          Id of the instance to subscribe
    /// @returns    N/A
    static __subscribe_channel__ = function(_channel, _id) {
        
        if (is_array(_channel))
        {
            for (var _i = 0; _i < array_length(_channel); _i++)
            {
                __subscribe_channel__(_channel[_i], _id);
            }
            return;
        }
        
        if (_channel == global) {
            __subscribe__(_id);
            return;
        }
        
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
    
    /// @param      {Id.Instance}  id              Id of the instance to subscribe
    /// @returns    N/A
    static __subscribe__ = function(_id) {
        var _size = array_length(_subscribers);
        for (var _i = 0; _i < _size; _i++)
            if (_subscribers[_i] == _id) return;
        _subscribers[_size] = _id;
    }
    
    /// @param      {Id.Instance}  id              Id of the instance to unsubscribe
    /// @returns    N/A
    static __unsubscribe__ = function(_id) {
        var _new_subscribers = [], _j = 0;
        for (var _i = 0; _i < array_length(_subscribers); _i++)
        {
            if (_subscribers[_i] != _id)
            {
                _new_subscribers[_j++] = _subscribers[_i];
            }
        }
        _subscribers = _new_subscribers;
        
        var _name_list = variable_struct_get_names(_channels);
        for (var _i = 0; _i < array_length(_name_list); _i++)
        {
            var _list = variable_struct_get(_channels, _name_list[_i]);
            var _new_list = [], _z = 0;
            for (_j = 0; _j < array_length(_list); _j++)
            {
                if (_list[_j] != _id)
                {
                    _new_list[_z++] = _list[_j];
                }
            }
            variable_struct_set(_channels, _name_list[_i], _new_list);
            if (array_length(variable_struct_get(_channels, _name_list[_i])) == 0) {
                variable_struct_remove(_channels, _name_list[_i]);
            }
        }
    }
    
    /// @param      {string}    channel     Name of the channel
    /// @param      {Id.Instance}      id          Id of the instance to unsubscribe
    /// @returns    N/A
    static __unsubscribe_channel__ = function(_channel, _id) {
        if (is_array(_channel))
        {
            for (var _i = 0; _i < array_length(_channel); _i++)
            {
                __unsubscribe_channel__(_channel[_i], _id);
            }
            return;
        }
        
        if (_channel == global) {
            __unsubscribe__(_id);
            return;
        }
        
        var _list = variable_struct_get(_channels, _channel);
        if (is_undefined(_list)) return;
        
        var _new_list = [], _j = 0;
        for (var _i = 0; _i < array_length(_list); _i++)
        {
            if (_list[_i] != _id)
            {
                _new_list[_j++] = _list[_i];
            }
        }
        variable_struct_set(_channels, _channel, _new_list);
        if (array_length(variable_struct_get(_channels, _channel)) == 0) {
            variable_struct_remove(_channels, _channel);
        }
    }
    
    /// @param      {real|string}   message         Message to broadcast to the receivers
    /// @param      {string}        channel         Name of the channel
    /// @param      {function}      callback        Additional callback
    /// @param      {any}           data            Data given to callback on receiver side
    /// @returns    N/A
    static __broadcast__ = function(_msg, _channel, _cb, _data) {
        if (is_array(_channel)) {
            for (var _i = 0; _i < array_length(_channel); _i++) {
                __broadcast__(_msg, _channel[_i], _cb, _data);
            }
            return;
        }
        
        var _list;
        if (is_string(_channel))
        {
            _list = variable_struct_get(_channels, _channel);
            if (is_undefined(_list))
            {
                var _error_msg = "Channel '" + _channel + "' does not exist!";
                if (__NOTIFICATIONS_SAFE) show_error(_error_msg, true);
                else show_debug_message(_error_msg);
            }
        } else
        {
            _list = _subscribers;
        }
        
        for (var _i = 0; _i < array_length(_list); _i++)
        {
            if (instance_exists(_list[_i]) && 
                variable_instance_exists(_list[_i], "__notificationsReceiver__"))
                _list[_i].__notificationsReceiver__.__receive__(_msg, _channel, _cb, _data);
        }
    }
    
    /// @param      {array}     array       Array to iterate    
    /// @returns    {string}
    static __log_array_contents__ = function(_array) {
        var _len = array_length(_array);
        var _string = string(_len) + " intsances [ ";
        for (var _i = 0; _i < _len; _i++)
        {
            if (_i != 0) _string += ", ";
            if (instance_exists(_array[_i]))
                _string += string(object_get_name(_array[_i].object_index)) + " " + string(_array[_i].id);
            else
                _string += "UNKNOWN OBJECT " + string(_array[_i]);
        }
        _string += " ]";
        return _string;
    }
    
    /// @returns N/A
    static __log_channels__ = function() {
        show_debug_message("");
        show_debug_message("-- SUBSCRIBERS --");
        show_debug_message("global: " + __log_array_contents__(_subscribers));
        var _names = variable_struct_get_names(_channels);
        for (var _i = 0; _i < array_length(_names); _i++)
        {
            var _list = variable_struct_get(_channels, _names[_i]);
            var _string = _names[_i] + ": " + __log_array_contents__(_list);
            show_debug_message(_string);
        }
        show_debug_message("");
    }
    
    /// @param      {string}    channel     Name of the channel to check for
    /// @returns    {bool}
    static __channel_exists__ = function(_channel) {
        return !is_undefined(variable_struct_get(_channels, _channel));
    }
    
}

/// @func       channel_exists(channel)
/// @param      {string}    channel     Name of the channel to check for
/// @returns    {bool}
function channel_exists(_channel) {
    return global.__notifications__.__channel_exists__(_channel);
}

/// @func       log_channels()
/// @returns    N/A
function log_channels() {
    global.__notifications__.__log_channels__();
}

/// @func       subscribe([id, channel])
/// @param      {Id.Instance}          [id]        Id of the instance to subscribe | Default: id of the caller
/// @param      {real|string}   [channel]   Name of the channel | Default: no channel
/// @returns    N/A
function subscribe(_id, _channel) {
    if (is_undefined(argument[0])) _id = self.id;
    else if (is_string(argument[0]) || is_array(argument[0]) || argument[0] == global)
    {
        _channel = _id;
        _id = self.id;
    }
    
    if (!is_undefined(_channel) && _channel != global) {
        if (__AUTO_SUBSCRIBE_TO_GLOBAL) global.__notifications__.__subscribe__(_id);
        global.__notifications__.__subscribe_channel__(_channel, _id);
    } else {
        global.__notifications__.__subscribe__(_id);
    }
}

/// @func       unsubscribe([id, channel])
/// @param      {Id.Instance}          [id]        Id of the instance to unsubscribe | Default: id of the caller
/// @param      {real|string}   [channel]   Name of the channel | Default: no channel
/// @returns    N/A
function unsubscribe(_id, _channel) {
    if (is_undefined(argument[0])) _id = self.id;
    else if (is_string(argument[0]) || is_array(argument[0]) || argument[0] == global)
    {
        _channel = _id;
        _id = self.id;
    }
    
    if (!is_undefined(_channel) && _channel != global) {
        global.__notifications__.__unsubscribe_channel__(_channel, _id);
    } else {
        global.__notifications__.__unsubscribe__(_id);
    }
}

/// @func       broadcast(message, [callback, data])
/// @param      {real|string}       message         Message to broadcast to the receivers
/// @param      {any}               [callback]      Callback function | Default: undefined
/// @param      {any}               [data]          Data given to callback on receiver side | Default: -1
/// @returns    N/A
function broadcast(_msg, _cb, _data) {
    broadcast_channel(argument[0], global, _cb, _data);
}

// feather ignore once GM1062
/// @func       broadcast_channel(message, channel, [callback, data])
/// @param      {real|string}           message     Message to broadcast to the receivers
/// @param      {array|string|global}   channel     Name(s) of the channel
/// @param      {any}                   [callback]  Callback function | Default: undefined
/// @param      {any}                   [data]      Data given to callback on receiver side | Default: -1
/// @returns    N/A
function broadcast_channel(_msg, _channel, _cb, _data) {
    
    if (is_undefined(_data)) _data = -1;
    if (!is_undefined(_cb) && !is_method(_cb)) 
    {
        _data = _cb;
        _cb = undefined;
    }
    global.__notifications__.__broadcast__(_msg, _channel, _cb, _data);
}


/// @struct     Receiver([subscribe channels])
/// @param      {bool|string}    [subscribe]    Auto subscribe | Default: true
function Receiver(_sub) constructor {
    
    _events = [];
    _size = 0;
    _parent = other.id;
    
    if (variable_instance_exists(_parent, "__notificationsReceiver__")) { 
        var _message = "-- WARNING --\nObject " + string(object_get_name(other.object_index) + ": Notification receiver already exists.");
        show_error(_message, true);
    }
    variable_instance_set(_parent, "__notificationsReceiver__", self);
    
    if (!is_undefined(_sub))
    {
        if (is_string(_sub) || is_array(_sub) || _sub == global)
            subscribe(_parent, argument[0]);
        else if (_sub == true)
            subscribe(_parent);
    } else
    {
        subscribe(_parent);
    }
    
    /// @func       add(message, [channel, callback])
    /// @param      {real|string}       message         Message to listen for
    /// @param      {string}            [channel]       The channel to listen on
    /// @param      {function}          [callback]      Callback function to run when message received
    /// @returns    N/A
    static add = function(_event, _channel, _cb) {
        if (is_method(_channel)) {
            _cb = _channel;
            _channel = undefined;
        }
        _events[_size] = {
            event: argument[0],
            channel: _channel,
            callback: _cb
        }
        _size++;
    }
    
    /// @func       on(message, [channel, callback])
    /// @param      {real|string}       message         Message to listen for
    /// @param      {string}            [channel]       The channel to listen on
    /// @param      {function}          [callback]      Callback function to run when message received
    /// @returns    N/A
    static on = function(_event, _channel, _cb) {
        add(_event, _channel, _cb);
    }
    
    /// @func       remove(message, [trigger])
    /// @param      {real|string}       message         Message to stop listening for
    /// @param      {bool}              [trigger]       Run callback once before deletion | Default: false
    /// @returns    N/A
    static remove = function(_event, _trigger) {
        var _new_events = [];
        var _j = 0;
        for (var _i = 0; _i < _size; _i++)
        {
            if (_events[_i].event != _event)
            {
                _new_events[_j] = _events[_i];
                _j++;
            } else
            {
                if (!is_undefined(_trigger) && argument[1]) _events[_i].callback();
            }
        }
        _events = _new_events;
        _size = _j;
    }
    
    /// @param      {real|string}   message     Message to receive
    /// @param      {string}        channel     Channel the msg was sent through
    /// @param      {function}      callback    Additional callback to run
    /// @param      {any}           data        Data given to callback on receiver side
    /// @returns    N/A
    static __receive__ = function(_msg, _channel, _cb, _data) {
        for (var _i = 0; _i < _size; _i++)
        {
            if (_events[_i].event == _msg && 
               (_events[_i].channel == _channel || is_undefined(_events[_i].channel)))
            {
                var _fn = _events[_i].callback;
                if (!is_undefined(_fn)) _fn(_data);
                if (!is_undefined(_cb)) method(_parent, _cb)();
            }
        }
    }
}

// feather enable GM1042
