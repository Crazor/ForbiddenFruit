ForbiddenFruit
==============
ForbiddenFruit wants to be the swiss army knive of Eve API tools on OS X.

This is pretty much early work in progress. Help is appreciated!

Screenshot
==========
![](http://i.imgur.com/Bu3Uwpw.png)

Goals
=====
In a first phase, I'd like to implement as much of the EveAPI as possibly useful, writing simple features along the way to demonstrate what is implemented right now.

Later on (or as soon as someone writes them), I'd like to concentrate on more complex features, like market statistics, messaging and notifications, asset management etc. If this tool proves useful and popular enough, stuff like cache scraping might be interesting, as there doesn't seem to be a decent program to do that on OS X, and the additional data could be very useful.

Current status
==============
I'm implementing the basic API, refactoring stuff around as needed. The GUI is just a demonstrator and needs to be improved. I'm going with the single window per feature concept right now, because that allows to easily test one feature while another one is broken.

What's working
==============
 * managing multiple API keys
 * browsing account and character infos
 * fetching wallet journal data
 * fetching market order data
 * download and extract the CCP SDE database converted to SQLite

What's missing
==============
 * Handling of more than one character per account
 * useful features ;)
