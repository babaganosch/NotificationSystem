<h1 align="center">GMS 2.3+ NotificationSystem | v1.2.1</h1>
<p align="center"><a href="https://twitter.com/Babaganosch">@babaganosch</a></p>
<p align="center">Download: <a href="https://babaganosch.itch.io/notificationsystem">itch</a></p>

---

**NotificationSystem** is an observer pattern framework for GameMaker Studio 2.3+. It's extremly simple to setup and easy to use.

You only need the 'NotificationSystem' script, but this whole repository contains a demo project showcasing a simple implementation.

<p align="center">
  <img src="https://raw.githubusercontent.com/babaganosch/open_storage/master/notifications.gif">
</p>

## Changelog v1.2.1

* Added support for subscribing to multiple channels at once, example below
* Fixed bug when calling `subscribe("channel")` could crash
```gml
receiver = new Receiver(["controllers", "effects", "channel5"]);
// or
subscribe(["controllers", "effects", "channel5"]);
```

## Installation

* Copy the `NotificationSystem` script into your project.

## Usage

* In the Create event of an object, create a variable holding a new instance of `Receiver`. This object is now ready to receive messages over the notification bus.

* In order to react to messages sent over the bus you bind callbacks to messages with the function `add()`. The messages can be of any type, such as enums, numbers, strings etc.

```gml
// Initializing the listener
receiver = new Receiver();

receiver.add("Monster killed", function(amount) {
    increase_score(amount);
});

receiver.add(MESSAGES.death, function() {
    game_restart();
});

receiver.add(3, function() {
    show_debug_message("Message 3 received!");
});
```

* It is also possible to subscribe to specific channels
```gml
// Subscribe to channel enemies
subscribe("enemies");

// Subscribe instance 100010 to channel enemies
subscribe(100010, "enemies");
```

* You can also bind an empty callback to a message, in order to only react to messages which includes a callback.

```gml
receiver.add("hello");
```

* Any object can broadcast a message on the notification bus, this is performed with the function `broadcast()`. Messages broadcasted can contain a callback, which will trigger **after** the callback bound on the receiver end. It is also possible to send an argument with the message, which the callback bound on the receiver end will receive.

```gml
broadcast(MESSAGES.death);

broadcast("Monster killed", 10);

broadcast("hello", function() {
    show_debug_message("hello, world!");
});

broadcast_channel("hello", "enemies");
```

* Don't forget to unsubscribe to the notification bus when deleting an object that is subscribed. This is performed by simply calling the function `unsubscribe()`, preferably in the cleanup event of the object.

```gml
// Don't waste time trying to send me any new messages. I'm not home!
unsubscribe();
```

## Documentation

Check out the [wiki](https://github.com/babaganosch/NotificationSystem/wiki) for further documentation.
