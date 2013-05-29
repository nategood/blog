# Intro to REST

_Wrote this a while back as a brief intro to REST for the ShowClix API.  Figured I'd share here as well._

## A Brief, High-Level REST Introduction

A RESTful Web Service can be thought of as just Nouns and Verbs, or in more RESTful terms, Resources and Operations.  A RESTful Service has a group of things (aka Nouns, aka Resources) that we can do stuff to (aka we can apply Operations to these things/Resources).  Pretty simple idea.  These Resources and Operations have a few general principles:

## Resources

### Uniform Resource Identifiers (URIs)

Resources must be universally identifiable through what is typically called a URI.  If the Resources/Nouns we were talking about were people, we could consider Social Security Number as the URI for our Resources (assuming the people were US Citizens and SSNs were actually unique).  Given a URI, I should be able to determine exactly what Resource is being referred to.  When talking about RESTful Web Services, URIs are almost always in the form of the familiar URL.  An example URI might be [https://www.example.com/post/123](https://www.example.com/post/123) to represent a single blog post.

### Representations

Resources in RESTful Web Services are exchanged as representations.  When requesting a Resource in a RESTful Service, the client does not get a physical copy of that Resource.  Instead, the client would receive a representation describing that Resource.  In RESTful Web Services, this representation is text describing the resource, structured in the form of XML, JSON, YAML, RSS, Atom, etc..

## Operations

### Uniform Interface

Resources don't do us any good unless we can do things with them.  In the RESTful style of things, what we can do is limited to a defined set of operations that can be performed to all Resources.  This is commonly referred to as the uniform interface.  Going back to the Noun/Verb analogy, our vocabulary only contains a certain amount of verbs that were applicable to all Nouns.  In RESTful Web Services, this uniform interface is almost always HTTP.  HTTP defines four main operations: GET (retrieving data), PUT (editing data), POST (creating data), DELETE (removing data).  These are the only operations that can be applied to a Resource._ There are several other methods as part of the HTTP spec, most notably HEAD and TRACE, but we'll stick with the main four for now._

RESTful Architectures follow the Client/Server design pattern.  This means that the client machine initiates all requests to a server machine that handles client's request.  The server then sends a response to the client once it has processed the request.  In standard HTTP, the server does not initiate any requests.

RESTful Architectures have a few other principles and perks (cachability, hyperlinking, statelessness, inherent scalability...) but this covers the main ideas.  To recap, in a RESTful Web Service, a client makes a request to a server to perform an operation on resource that is identified by a URI.

If you're really interested in learning REST the right way (REST is a very abused term), check out the following:

*   [Roy Fielding's Dissertation](http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm) that started the whole RESTful idea
*   [InfoQ](http://www.infoq.com) Excellent articles and lectures on RESTful Architectures
*   [RESTful Web Services by Sam Ruby](http://oreilly.com/catalog/9780596529260)