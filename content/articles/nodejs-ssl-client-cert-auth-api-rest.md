# SSL Client Authentication in Node.js

A couple of years ago, I wrote a [blog post](http://blog.nategood.com/client-side-certificate-authentication-in-ngi) about configuring nginx to use SSL client certificate
authentication.  It is to this day one of my most popular posts in terms of traffic.
Since then, I've continued to advocate the use of client
certificates as a form of authentication when your security
requirements are a bit more stringent.

Recently, Node.js has piqued my interest.  Most other languages/frameworks targetted for web development sit on top of
a separate HTTP server (like Apache or Nginx).  Node.js is unique in
that it provides an HTTP server as one of the core libraries (to the
shagrin of some).  This means there isn't (immediately) a need for a separate HTTP server.  For fun, I decided to recreate the whole client SSL
certificate authentication thing in Node.js.

If you need a refresher on how to create and sign the certs, check out
the [nginx post](http://blog.nategood.com/client-side-certificate-authentication-in-ngi).

Turns out the more recent releases of Node.js have decent [TLS/SSL
support](http://nodejs.org/docs/v0.4.8/api/tls.html) making things relatively straight forward.  Here is a quick example of an HTTPS server that will allow us to perform client certificate authentication and determine authorization.

    var https = require('https'),      // module for https
        fs =    require('fs');         // required to read certs and keys

    var options = {
        key:    fs.readFileSync('ssl/server.key'),
        cert:   fs.readFileSync('ssl/server.crt'),
        ca:     fs.readFileSync('ssl/ca.crt'),
        requestCert:        true,
        rejectUnauthorized: false
    };

    https.createServer(options, function (req, res) {
        if (req.client.authorized) {
            res.writeHead(200, {&quot;Content-Type&quot;: &quot;application/json&quot;});
            res.end('{&quot;status&quot;:&quot;approved&quot;}');
        } else {
            res.writeHead(401, {&quot;Content-Type&quot;: &quot;application/json&quot;});
            res.end('{&quot;status&quot;:&quot;denied&quot;}');
        }
    }).listen(443);

The first three options (`key`, `cert`, and `ca`) are pretty self
explanitory (if they aren't, read the [previous post](http://blog.nategood.com/client-side-certificate-authentication-in-ngi) for a
refresher). The
 `requestCert` option tells Node that it should request the client cert from
a client attempting to connect.  Lastly, `rejectUnauthorized` tells
Node if it should flat out reject the connection if the certificate
provided is not valid (valid meaning it must be signed by our `ca`, not
revoked, and not expired).  We'll keep this set to `false` so we can
make the decision in the app itself.

The [`https.ServerRequest`](http://nodejs.org/docs/v0.4.8/api/http.html#http.ServerRequest)
object is passed to our `https.createServer` callback function as the
first argument (named `req` above).  Along with other information
about the request (like the uri, http method, etc.),  it includes some
information about the client's authorization state in the
`req.client.authorized` attribute.  This is pretty self explanitory,
but this boolean attribute states whether or not the client presented
a "valid" client certificate as part of its request.

We can test this out with a simple `curl` call.

    # Denied (no cert)
    curl -v -s -k https://localhost:5678

    # Approved (using CA signed cert)
    curl -v -s -k --key ssl/client.key --cert ssl/client.crt https://localhost:5678

There you have it.  It's a pretty trivial example, but you get the
basic idea of how to get started with making client side cert
authentication your authentication tier for you next Node API.  All of
the source code (including the example certs) is available on
[GitHub](https://github.com/nategood/node-auth).