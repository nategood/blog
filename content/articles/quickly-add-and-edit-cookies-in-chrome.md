# Quickly Add and Edit Cookies In Chrome

Occasionally whilst developing, I have the need to manually set a cookie.  For
example, in our production environment we have multiple app servers
and multiple load balancers.  We follow a "round robin" approach as
opposed to a "sticky session" approach when it comes to load
balancing.  From time to time it is really handy to be able to isolate
yourself to one box for the purposes of testing/debugging a particular
box.  Our stack will allow this if you have a cookie telling the load
balancer where you want it to take you (e.g. setting the
"takeMeToServer" cookie to "app3" would hypothetically send all your
requests to application box 3).  After doing this the ugly way with temporary "set cookie" scripts hosted on the server I was trying to reach, I decided to look for a simpler route.

Chrome has awesome Developer Tools.  Included in these tools is the
handy ["Resources"](http://cl.ly/0j2A2x1h2d1c182m3h1x) section which
lets you **inspect** and **delete** your existing cookies for the site you
are on.  Unfortunately, it does not let you **add** or **edit** your
cookies.  This is where the old `javascript:` protocol comes in handy.
 You can use the URL bar and javascript to set a new cookie for a
particular page.

### Steps

1.  Navigate to the site where you wish to set a new cookie
2.  In your [URL bar enter](http://cl.ly/2f0I2c0o1t3d0o0G1F1n) `javascript:document.cookie="myCookieName=myCookieValue"` where
`myCookieName` is the name of the cookie you wish to set, and
`myCookieValue` is the value.

Bam you are done.  You may be taken to a new screen that [echos out
the contents of your cookie](http://cl.ly/160m2A143A2C3V1l2736),
however if you go back to the domain where you set the cookie, you
should be able to open up the Developer Tools again and [see your
newly set cookie](http://cl.ly/0Q2C0A3F330X313Z2v3W).

Now ain't that **_sweet_**?

_If you need to set the same cookie or two repeatedly, I would
recommend adding a "bookmarklet" for your javascript above.  They work
just as nicely for the javascript protocol as they do for regular old
http links._