# The Intricacies of Read-Write Splitting

_Not long ago, we set out to reconsider how we leveraged our master-slave infrastructure. This article describes a lot of the things to consider when thinking about read write splitting. Much of what is discussed paved the way for our revamped Policy Driven Read-Write Splitting Framework._

The task of read-write splitting in relational database backed applications is a common first major step in scaling out horizontally. On its surface, read-write splitting seems like a somewhat trivial task. The immediate instinct for someone that has yet to embark into the land of splitting is typically just send reads to "slaves" and writes to "master". Right?

As we'll uncover, there are all sorts of things to consider when determining when its okay to read from slaves vs. master.

## Consistency

In the dream world, one might think writes to a master would be immediately propagated to slaves and that there would be guranteed consistency across master and all slaves. In reality, this doesn't happen.

With many databases (relational or not), eventual consistency is a reality. When a write hits the master, there is enevitably a delay between the time data is written to the master and the time it is written to and accessible from the slave. To further compliacte things, databases that support transactions mean that data will "written" during the transaction is only accessible to the current connection to master, leaving slaves in the dark until a commit happens.

We call this delay **Lag**.

As a result of lag, we cannot simply just assume blindly reading from the slave is okay because we may read stale data when reading stale data is unacceptable. We have to be strategic about when we read from slaves.

> ### Side Note: Eventual is okay!
>  In many cases, eventual consistency is actually a good thing. Waiting for a write to be propagated to all slaves before continuing could become an incredible bottleneck. This is especially true for slaves that may not be "close" to the master (e.g. a data center across the country set up for geographic redundancy). It is also not unusual for slaves to have slaves themselves, futher complicating the chain of writes. Eventual consistency is actually an acceptable tradeoff. As the now infamous "CAP Theorom" explores, when scaling out, we often have to make at least one major tradeoff like eventual consistency.

## Measuring Lag

In order to "do better" we have to have a way of determining when its acceptable to read from a slave. In order to do that, we need to define some metrics for measuring Lag.

There are two common ways to measure lag. The simplest, and most widely applicable is **Time-Based Lag**. Time-Based Lag, as you might guess, measures the delay between a master and a slave in terms of time. This is commonly measured as how much time has elapsed from the time a piece of data was written to the master to the time that same piece of data was written to a slave.

The second, and in many cases, more useful, is **Event-Based Lag**. Event-Based Lag is measure in terms of how many "events" or "writes" have happened on master that have yet to happen on the slave. It is often even more useful to know the answer to "Has event E happened on the slave S?" as opposed to "How many events is slave S behind the master?". More on this later.

_Determining what an event is will likely be vendor and even configuration specific. An event would simply be the log item (a row, a statement, etc.)._


## Defining Tolerance

Now that we have some ways to measure lag, we can use those measurements to define acceptable thresholds for lag.

### No Lag Tolerance

For some reads, any lag whatsoever may be unacceptable. For example if we have a field that is a critical incremental counter (and assuming our DB had no atomic operation for incrementation), we would never want to read a stale value to determine what the newly incremented value should be. In this case all reads should come from the master.

### Time-Based Tolerance

There may be some cases where reading stale data is acceptable within reason. For example, it may be perfectly acceptable to show a list of comments on a blog post that is seconds or even minutes out of date. We may however care if the comments are far out of date so we can define a simple time based threshold of what we would consider an acceptable time based tolerance. If our slave is outside that tolerance level, it's worth us to make a read to the master or even try another slave.

### Event-Based Tolerance

Event-Based tolerance is even more useful than their Time-Based counterpart, however they can be a little bit more work to be used most effectively.

Event-Based tolerance can be used very similarly as the aforementioned Time-Based scenario, that is I'm okay to make a read if the data is within X events, but it becomes far more useful when we keep track of individual events.

Let's continue with our blog comment example. While it may be fine if we miss out on someone else's recent comment because we read from a slightly stale slave, it would be very confusing for a user that just posted a comment to not see that comment appear on the next page load. This is where Event-Based tolerance comes in handy.

When a user wrote their latest comment, we can record that event. Let's call this particular event, E. On the next payload, we can say, if there is a slave S that has at least caught up to E, then its okay to read from S. If not, we'll need to read from master.

## Flexibility

As we saw in our discussion of tolerance, different read scenarios have different tolerance levels. Using a single approach for your entire app like "send all reads to the slave if the slave is within 2 seconds of the master" is far too general and even dangerous.

Instead of these blanket generalizations, we should give the developer the tools they need to make decisions about acceptable read tolerance levels based on what they're apps requirements are at any given time in the app.

The developer should be able to define acceptable tolerane levels quickly and make decisions on when to use those tolerance levels, without introducing unecessary complexity or tight coupling between the application and the database layer.

## Onward!

Now that we have established a nice way to measure lag and define acceptable lag tolerance levels, we can start to discuss what an interface for communicating with a master-slave infrastructure might look like. In a [future article](#), we'll explore how to encorporate these ideas of lag tolerance and informed read/write splitting into a database access layer that promotes low coupling, cuts down on boiler plate code, and gets out of the developer's way. We call this approach Policy Driven Read-Write Splitting.

_If you enjoyed this article, I highly recommend checking out the [presentation](http://www.slideshare.net/billkarwin/read-write-split) by Bill Karwin from [Percona](http://www.percona.com/) on defining lag and the basics of read write splitting. Much of our exploration was driven by his webinar. I highly recommend checking it out as it served as the basis for much of this article and lead to our Policy-Driven approach. Many kudos to Bill and the Percona team._
