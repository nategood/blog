# TextMate Won't Launch

My MacBook Pro's battery died sometime last night whilst I
was painfully watching the performance of my Pitt Panthers in the NCAA
tournament.  This morning when I booted it up again,
[TextMate](http://macromates.com/) would not launch.  A quick Google
search revealed no help.  So I dug around in the
`~/Library/Application Support` directory to see if TextMate had left
some dirty laundry there.  Sure enough, a `TextMate.pid` file existed
there.  Most of the time when a `.pid` file exists for an Application
that isn't running, that isn't a good thing.  I deleted it.  TextMate
now launches.

### tl;dr

If TextMate won't open for you after not shutting down properly:

1.  Go to the `~/Library/Applications Support/TextMate` directory
2.  Delete the TextMate.pid file