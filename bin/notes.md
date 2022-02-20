# dbus for KDE suspend / resume composition to achieve double buffering

> qdbus org.kde.KWin /Compositor
property read bool org.kde.kwin.Compositing.active
signal void org.kde.kwin.Compositing.compositingToggled(bool active)
method void org.kde.kwin.Compositing.resume()
method void org.kde.kwin.Compositing.suspend()
