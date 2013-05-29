# Finally Grasping Prototypical Object Oriented Programming in Javascript

Javascript and I have had a long love/hate relationship that dates back to my middle school days of hacking "DHTML" websites.  One thing in particular that always bothered me was Javascript's Object Oriented programming.

Most "Intro to Object Oriented Programming for Javascript" examples go a lot like this...

    // Define a new "class"
    function Person(name)  {
        this.name = name;
    }

    // And then we add some instance methods...
    Person.prototype.sayMyName = function() {
        alert(this.name);
    };

    // And maybe another instance variable...
    Person.prototype.age = -1.0/0.0; // forever young

    // Instantiate
    var nathan = new Person('Nathan Good');

How could they get it so wrong?!  Why was the "class" a single function?  Why was the class defined by several statements scattered around?  Where was the encapsulation?  How could I define my static methods?  It just seemed wrong and ugly.

Unsatisfied with this approach, I ended up trying to find clever and cleaner solutions for OO programming in Javascript.  I loved object literals.  They were so simple and clean.  I thought those had to be the answer.  While object literals were definitely on the right track, my approach was still far from pretty...

    // Futile attempt at "cleaning up" class definitions
    var Person = function(name) {
        this.name = name;
    };
    Person.prototype = {
        age: -1.0/0.0,
        sayMyName : function() {
            alert(this.name);
        }
    };
    var nathan = new Person("Nathan Good");

And even worse...

     // Another futile, "clever" solution
    (Person = function(name) {
        this.name = name;
    }).prototype = {
        age: -1.0/0.0,
        sayMyName : function() {
            alert(this.name);
        }
    };
    var nathan = new Person("Nathan Good");

Though these solutions were a little more encapsulated, these clever hacks still felt **wrong**.  This was so not OO.  So not Java.

And that was just it.  Despite the name, Javascript **is so not** Java.  Not even close.

## Enlightenment

I knew Javascript was "prototype" based object oriented programming and I _thought_ I knew what that meant... until I came across this snippet of Javascript from [Douglas Crawford](http://javascript.crockford.com/prototypal.html), the author of an awesome book call ["Javascript: The Good Parts"](http://www.amazon.com/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742):

    function extend(o) {
        function F() {}
        F.prototype = o;
        return new F();
    }

_Note: His initial definition used the name `object`, I think `extend` is more readable._ I'm going to go Tarantino on you and jump back a little bit before explaining why this code is so eye opening.

## Ditching the Dichotomy

As victims, er, I mean students of Java school and class-based object orientation teachings, we learn the dichotomy of object orientation: there are **classes** and then there are **instances**.  A class defines the structure of how objects should look/behave.  Instances are the examples made from those classes.  Classes serve as the blueprint.  Instances are the house built from the blueprints.

In Javascript's Prototypal OOP, there is no separation.  There are just objects.  Now what could be more OO than that?  Each new object is cloned (_sort of_) from an existing Object.  We can then optionally transform that newly created object to make it suit our needs.  This pattern of building from a prototype goes **both** for (in class-based terms) creating "new instances" _AND_ creating "new subclasses".  Let's think about that one for a bit.

In class-based object oriented programming [inheritance](http://en.wikipedia.org/wiki/Inheritance_(object-oriented_programming)) and [instantiation](http://en.wikipedia.org/wiki/Instance_(computer_science)) feel like two very different things.  When defining a sub class, we are creating a new class that inherits attributes/behavior from its parent class and then tweaking it to suit that particular subclass' needs.  To continue the analogy from before, we're making a photocopy of our blueprints and tweaking them a bit.  When instantiating that class, we make a `new` instance of that subclass and define that instance by setting its attributes or via getter/setter methods (barf).

In Prototypal OO, the act of "inheritance" and "instantiation" feel like the same process.  There is no notion of a "class".  There are just objects.  `Person` is an object.  `nathan`, an example of a person, is an object that inherited its behavior from `Person`.  Unlike in classic OOP where `Person` would be considered a class and `nathan` considered a class instance, `Person` and `nathan` are both objects on the same playing field.

Okay, you may be thinking, what in the hell are you talking about?  No classes?  Let's jump to some examples.

## Back to the Code, Sort of...

Originally here is where I intended to break down that short 3 line function that makes Prototypal OO Programming so much more streamlined.  However, in the interest of staying on topic and teaching the Prototypal approach, I'm going to save that break down for another post or let you [read more about it from Crawford](http://javascript.crockford.com/prototypal.html).

Instead let's focus on how we'll use this short `extend` function to achieve Prototypal OO Bliss.

    // Define a Person as an Object Literal
    var Person = {
        name: null,
        sayMyName: function() {
            alert(this.name);
        }
    };
    var nathan = extend(Person);
    nathan.name = "Nathan";

Whoa!  Where is the `new`?  Why aren't I using `.prototype`?  Well you kind of are, but they are now behind the scenes and they are there for good reason.  Our focus here is to create a new object, `nathan`, that inherits all of its behavior from an existing prototype object, `Person`.  That's exactly what we've done here.  `Person` is still an object.  It is defined with our nice clean object [literal syntax](https://developer.mozilla.org/en/Core_JavaScript_1.5_Guide/Core_Language_Features#Object_Literals).  By extending the `Person` object, `nathan` now has all of the characteristics of a `Person`.  What's even cooler is that I can add things/attributes/methods to `nathan` now that may not be common of all `Person`s!  But thats for another post...

## This seems weird...

If you learned OO the Java way, it should seem weird.  When learning OOP, we always use real world examples.  Physical things.  Like people or animals.  From that point on, the dichotomy is born.  There are classes, typically abstract concepts like "Person", that define structure and then there are living, breathing instances of those classes, like "Nathan Good".  When we're setup with that mentality, Prototypal OO does not make sense.  "A Person should be a class not an object!?!" you might think.  That's because we've coupled "object" to mean "physically existing" and "class" to mean "blueprint".  There is no need for this separation.  If you are like me, it may take you a while to break that coupling.

## Wrap up and Future Work

In reality the Prototypal OO approach makes OO programming much simpler and flexible.  In later posts I'll discuss how it removes the need for "static" methods and attributes, how we can handle "inheritance" with it, how it allows for the extremely popular "mixin" language feature, how we can achieve namespacing and how it easily allows for "one-offs".  I'll also touch on my version of the three line function that makes all of this possible and how I'm now regularly using it.  In the mean time, I'll leave you with a [snippet to whet your appetite](https://gist.github.com/856601) that uses [my prototypal OO helper functions](https://gist.github.com/856599).

I hope that, if nothing else, this has opened your eyes a bit to what "Prototypal Object Oriented Programming" really is.  Hopefully I've even persuaded you to use this approach for your next big Javascript project.
