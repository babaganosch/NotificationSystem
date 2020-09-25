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

```gml
// Initializing the listener
subscribe();
receiver = new Receiver();
```