# Sublime Text 2 Strip Whitespace on Save

I've become fond of [Sublime Text 2](http://www.sublimetext.com/2).  _Gasp!
 Wait, what?  You don't use
[emacs/vim/butterflies](http://xkcd.com/378/)?_ Anyway, regardless of the editor, I like to keep
my whitespace under control.  This usually means I add a hook
to strip trailing whitespace when saving.  The Sublime Text 2 Python API
reference looks pretty complete, but there's little pragmatic
documentation.  I tinkered with creating my own, found others that had semi decent solutions, but ultimately gave up.  After my failed attempts and failed googling, my [coworker](http://twitter.com/tomschlick) informed me
that Sublime Text has this built right in as a user setting you can set by
adding a simple JSON snippet.  Awesome.

## Make it Happen

Go to **SublimeText 2 > Preferences > User Settings** (or just hit the Mac
Standard `cmd` + `,`).  This should open your User Settings as a JSON file.
 Add the following to your file

    &quot;trim_trailing_white_space_on_save&quot;: true

That's it.  You're good to go.

![sublime text settings](http://cl.ly/3S0o12412X0M0G2U0m2l/Screen%20shot%202012-05-04%20at%2011.33.02%20AM.png)