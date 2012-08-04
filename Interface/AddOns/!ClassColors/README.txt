Class Colors
============

* Copyright (c) 2009–2012 Phanx <addons@phanx.net>. All rights reserved.
* See the accompanying LICENSE file for more information.
* http://www.wowinterface.com/downloads/info12513-ClassColors.html
* http://www.curse.com/addons/wow/classcolors


Description
-----------

Class Colors lets you to change class colors without breaking
parts of the Blizzard UI.

It is supported by many pouplar addons, and also applies your custom
colors to parts of the default UI that are normally class-colored.

To change colors or other options, type "/classcolors" or open the
Class Colors panel in the Interface Options window.


Localization
------------

Compatible with English, Deutsch, Español (EU), Español (AL), Français,
Italiano, Português, Русский, 한국어, 简体中文, and 繁體中文 clients.

Class Colors is translated into English, Español, and Português.

If you can provide new or updated translations for any language, please
contact me (see below).


Feedback
--------

Bugs, errors, or other problems:
	Submit a bug report ticket on either download page.

Feature requests or other suggestions:
	Submit a feature request ticket on either download page.

General questions or comments:
	Post a comment on either download page.

If you need to contact me privately for a reason other than those listed
above, you can send me a private message on either download site, or
email me at <addons@phanx.net>.


Information for addon authors
-----------------------------

Supporting the CUSTOM_CLASS_COLORS standard is simple. All you need to
do is check for the existence of a global CUSTOM_CLASS_COLORS table, and
read from it instead of RAID_CLASS_COLORS if it exists.

If your addon uses a local upvalue (variable) for RAID_CLASS_COLORS or
keeps a local cache of class colors, you should either delay creating
the upvalue or cache until the PLAYER_LOGIN event fires, or update it
when PLAYER_LOGIN fires. You should also register for a callback to be
notified when class colors are changed so you can update your cache or
apply the new colors immediately.

Finally, please do not check for the !CustomClassColors addon by name as
a means of determining whether the user has custom class colors. Not
only is it not guaranteed that !CustomClassColors will be loaded before
your addon unless you clutter up your TOC file by listing it as an
optional dependency, but the CUSTOM_CLASS_COLORS format is meant to be a
community standard and can be implemented by any addon, including an
unpublished one the user has written for personal use!

Get more details, including the callback API documentation, here:
http://wow.curseforge.com/addons/classcolors/pages/api-documentation/