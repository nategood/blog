# Javascript Prototypal Object Oriented Programming in Practice

I recently wrote a post about my [Javascript Prototypal Object
Oriented Enlightenment](http://blog.nategood.com/finally-grasping-prototypical-object-oriented).
 In that post I discussed how I learned to break my Classical Object
Oriented habits and stop forcing Javascript to do something it really
wasn't suited to do.  I focused more on my process of transitioning
from failed Class-based OO attempts in Javascript to Prototypal
Enlightenment and the differences between the two approaches.

I wanted to follow up that post with a post focused on the implementation and
use of Prototypal OO in Javascript.  We'll start with the short
function that inspired the last post and allows for easier Prototypal
OO in Javascript...

    function extend(o) {
        function F() {}
        F.prototype = o;
        return new F();
    }

With this function we can easily create new objects from existing
objects (this is the heart of Prototypal OO Javascript).  Let's see it in
practice.

## Instantiation: The Prototypal Way

Using this `extend` method we created, we create a new object
`nathan`, that inherits all of it's behavior from Person.

    // Define a Person as an Object Literal
    var Person = {
        name: null,
        sayName: function() {
            alert(this.name);
        }
    };
    var nathan = extend(Person);
    nathan.name = "Nathan";
    nathan.sayName();

We've just created a `nathan` object from another object, `Person`.
 In classical terms, we would be tempted call `Person` a "class" and
we would call the process of creating `nathan` instantiation.  We are
going to stay far away from those terms.  `Person` is a fully functional object itself (this will come in
handy when we discuss "static" methods in Prototypal OOP).  Secondly, we aren't so much instantiating `nathan` from a class as we are cloning it from an existing prototype object.

## Inheritance: The Prototypal Way

So we now have an example of Prototypal's version of "object
instantiation".  What about subclassing aka inheritance?  In my
[previous post](http://blog.nategood.com/finally-grasping-prototypical-object-oriented),
I mentioned that in Prototypal OOP inheritance and instantiation are
the same thing.  Let's consider this example...

    var Animal = {
        kingdom: "Animalia"
    };

    var Dog = extend(Animal);
    Dog.genus = "Canis";
    Dog.speak = function() {
        console.log("Bark bark!");
    };

    var Sparky = extend(Dog);
    Sparky.speak();

Notice that the process for creating `Dog` is the same process we used
above for creating `sparky`.  The only exception is that we added some
behavior to `Dog` after we created it from the `Animal` prototype.

## Improving `extend`

Relying on a single global function `extend` isn't a great idea.  We
can tidy it a bit by tying it into the `Object` prototype.  `Object`
is the object from which all objects are initially "extended" from.
If don't explicitly set an object's `prototype` (or implicitly through
our `extend` method), it's prototype will be `Object`.

    Object.extend = function() {
        function F() {}
        F.prototype = this;
        return new F();
    };

`var nathan = extend(Person);` from our first example,can now be
written as `var nathan = Person.extend();`.

// Define a Person by extending Object
var Person = Object.extend()
Person.name = "John Doe";
Person.sayName = function() {
    console.log();
};

var nathan = Person.extend();
nathan.name = "Nathan";
nathan.sayName();

_Another note: you may be tempted to add this to add this method to `Object.prototype` but **beware**! Extending native types can get you in trouble, in particular when using objects as dictionaries._

Now our code is a bit more OO and a bit more readable.  Also, `Object`
serves as a namespace for our method, adding additional encapsulation.

## Improving `extend` for "Inheritance"

You'll notice that in our Animal/Dog example, creating `Dog` was still
a multi-step process.  We extended `Animal` and then added behavior
with a sequence of assignments.  We can improve this process by
modifying our `extend` function to take an optional object parameter
that defines the before unique to our new class (in this case `Dog`).

    Object.extend = function (def) {
        var F = function() {};
        F.prototype = this;
        return typeof def == "object" ? $.extend(true, new F(), def); : new F();
    };

_Note: This snippet uses the jQuery [`extend`
method](http://api.jquery.com/jQuery.extend/) which merges two objects
into a new object.  You can certainly get away with writing this
functionality yourself if you don't want to include jQuery._

Our definition for `Dog` now looks something like this:

    var Animal = Object.extend({
        kingdom: "Animalia"
    });

    var Dog = Animal.extend({
        genus: "Canis",
        speak: function() {
            console.log("Bark bark!");
        }
    });

    var Sparky = Dog.extend();
    Sparky.speak();

Now we can extend and add behavior in one single step.  We are now
left with a clean, readable way to accomplish both "instantiation "
and "inheritance" in one single step.

This last version of the `extend` method is closest to the one I'm
currently using.  I have a short `boot.js` file that contains this
function as well as a few other helper methods that I commonly use.
Another one of the methods included in this `boot.js` file is one that
I use to easy support [mixins](http://en.wikipedia.org/wiki/Mixin) in
javascript.  I'll be following up with a post on Mixins in Javascript
and how to accomplish "static methods" in Javascript over the next
week or so.

