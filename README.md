<h1 align="center">GMS 2.3+ NotificationSystem | v1.0.0</h1>
<p align="center"><a href="https://twitter.com/Babaganosch">@babaganosch</a></p>
<p align="center"><a href="https://larsandersson.info">larsandersson.info</a></p>
<p align="center">Download: <a href="/">itch</a></p>

---

**NotificationSystem** is an observer pattern framework for GameMaker Studio 2.3+. It's extremly simple to setup and easy to use.

You only need the 'NotificationSystem' script, but this whole repository contains a demo project showcasing a simple implementation.

<p align="center">
  <img src="https://raw.githubusercontent.com/babaganosch/open_storage/master/notifications.gif">
</p>

## Installation

* Copy the `NotificationSystem` script into your project.

## Usage

* In the Create event of an object, create a variable holding a new instance of `Receiver`. In this same event, call the function subscribe(). This object is now ready to receive messages over the notification bus.

* In order to react to messages sent over the bus, you can bind callbacks to messages with the function `add()`. The messages can be of any type, such as enums, numbers, strings etc.

```gml
// Initializing the listener
subscribe();
receiver = new Receiver();

receiver.add("Monster killed", function() {
    increase_score();
});

receiver.add(MESSAGES.death, function() {
    game_restart();
});

receiver.add(3, function() {
    show_debug_message("Message 3 received!");
});
```

* You can also bind an empty callback to a message, in order to only react to messages which includes a callback.

```gml
receiver.add("hello");
```

* Any object can broadcast a message on the notification bus, this is performed with the function `broadcast()`. Messages broadcasted can contain a callback, which will trigger after the callback bound on the receiver end.

```gml
broadcast(MESSAGES.death);

broadcast("hello", function() {
    show_debug_message("hello, world!");
});
```

* Don't forget to unsubscribe to the notification bus when deleting an object that is subscribed. This is performed by simply calling the function `unsubscribe()`, preferably in the cleanup event of the object.

```gml
///@desc Don't waste time trying to send me any new messages. I'm not home!
unsubscribe();
```