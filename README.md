![Bookbeep logo](Bookbeep/Assets.xcassets/AppIcon.appiconset/icon_152.png)
Bookbeep 
========

This is an iOS app that scans ISBNs from barcodes on books and sends
them over to the [Bookdump](https://github.com/pvtsusi/bookdump) web
service to resolve the book title and author.

I made this so that I could scan a big bunch of books we wanted to
give away into a list, while not being forced to type in every
single book title and author.

I also wanted to take a look how Swift and iOS development looks in
general these days. (I had only used Objective-C years ago and only
for a desktop application.)

Installing and running
----------------------

Bookbeep isn't in the App Store. You'll have to sideload it.

Install [Xcode](https://developer.apple.com/download/).

Install [CocoaPods](https://cocoapods.org) and install the
dependencies

    pod install

Run Xcode, build, and deploy

    xed Bookbeep.xcworkspace

Once the app starts up, configure it to point to the backend URL
of a running [Bookdump](https://github.com/pvtsusi/bookdump)
and set up the admin credentials of that Bookdump.

Built with
----------

* [BarcodeScanner](https://github.com/rjstelling/BarcodeScanner),
  which is pretty much the beef of this whole app.
* [InAppSettingsKit](https://github.com/futuretap/InAppSettingsKit)
  by Luc Vandal and Ortwin Gentz. Cheers!
* [Toucan](https://github.com/gavinbunney/Toucan)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [Alamofire-SwiftyJSON](https://github.com/SwiftyJSON/Alamofire-SwiftyJSON)

About the code
--------------

This is my first ever Swift & iOS project, so things are messy. Don't
try to learn how to do things The Right Way by looking at this code.

### TODO

I was thinking of cleaning this (and bookdump) to the point I could
try out to submit this to the App Store just to find out how high
(or low) their bar is. But I'm not sure the experience itself is
worth the effort (or $100 / year).

License
-------

This project is licensed under the MIT License - see the
[LICENSE](LICENSE) file for details.
