# Httpful: The Sane PHP HTTP Client Library

[cUrl](http://curl.haxx.se/) is awesome.  Sadly cUrl in PHP is not.  More often than not, using the PHP cUrl library means digging through the [`curl_setopt` page](http://php.net/manual/en/function.curl-setopt.php) to figure out which poorly named constant is needed to tune our HTTP requests.  Alternatives like HTTP_Request and Zend_Http aren't much more usable or are too bloated for the common case.  One evening while plugging away at some code to migrate us from BaseCamp to FogBugz, I decided I had enough.  That evening Httpful came to be.

## A Readable Curl HTTP Client Alternative

The goal of [Httpful](https://github.com/nategood/httpful) was simple: create a sane HTTP library focused on readability, simplicity, and flexibility – basically provide enough features to get the job done and make those features really easy to use.  Before we dive into how Httpful accomplishes this, let's start with a quick snippet:

    // Fire off a GET request to FreeBase API to find albums by The Dead Weather.

    $uri = "https://www.googleapis.com/freebase/v1/mqlread?query=%7B%22type%22:%22/music/artist%22%2C%22name%22:%22The%20Dead%20Weather%22%2C%22album%22:%5B%5D%7D";

    $response = \Httpful\Request::get($uri)->expectsJson()->sendIt();

    echo 'The Dead Weather has ' . count($response->body->result->album) . ' albums.';

Okay, that looks a bit more sane than that `curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);` stuff.  Let's look at some of the things that Httpful has to offer.

## Chaining

Anyone that has used jQuery can attest to the awesomeness and conciseness of "chaining".  Httpful allows similar chaining to neatly build up your requests.  Need to specify a content-type?  Tack on an HTTP body?  Custom header?  Just keep tacking them on to your initial request object.

## Make the Important Stuff Easy

Choosing HTTP methods beyond GET and POST, quickly setting `Content-Type`s, setting request payloads... these are the things we should be able to do quickly.  This library makes those things easy using the aforementioned chaining.  Let's show a quick example doing a few of our favorite things.

    $response = \Httpful\Request::put($uri)        // Build a PUT request...
        ->sendsJson()                      // let's tell it we're sending (Content-Type) JSON...
        ->body('{"json":"is awesome", "httpful": "is too"}') // lets attach a body/payload...
        ->sendIt();                        // and finally, fire that thing off!

## Custom Headers

The library allows for custom headers without sacrificing readability.  Simply chain another method on to your request with the "key" of the header as the method name (in camel case) and the value of the header as that method's argument.  Let's add in two custom additional headers, X-Example-Header and X-Another-Header:

    $response = \Httpful\Request::get($uri)
        ->expectsJson()
        ->xExampleHeader("My Value")            // Add in a custom header X-Example-Header
        ->withXAnotherHeader("Another Value")   // Sugar: You can also prefix the method with "with"
        ->sendIt();

## Smart Parsing

If you expect (and get) a response in a supported format (JSON, Form Url Encoded, XML and YAML Soon), the Httpful will automatically parse that body of the response into a useful response object.  For instance, our "Dead Weather" example above was a JSON response, however the library parsed that request and converted into a useful object.  If the text is not supported by the internal parsing, it simply gets returned as a string.

    // JSON
    $response = \Httpful\Request::get($uri)
        ->expectsJson()
        ->sendIt();

    // If the JSON response is {"scalar":1,"object":{"scalar":2}}
    echo $response->body->scalar;           // prints 1
    echo $response->body->object->scalar;   // prints 5

## Custom Parsing

Best of all, if the library doesn't automatically parse your mime type, or if you aren't happy with how the library parses it, you can add in a custom response parser with the `parseWith` method.  Here's a trvial example:

    // Attach our own really handler that could naively parse comma
    // separated values into an array
    $response = \Httpful\Request::get($uri)
        ->parseWith(function($body) {
            return explode(",", $body);
        })
        ->sendIt();

    echo "This response had " . count($response) . " values separated via commas";


## Request Templates

Often, if we are working with an API, a lot of the headers we send to that API remain the same (e.g. the expected mime type, authentication headers).  Usually it ends up in writing boiler plate code to get around this.  Httpful solves this problem by letting you create "template" requests.  Subsequent requests will by default use the headers and settings of that template request.

    // Create the template
    $template = \Httpful\Request::init()
        ->method(\Httpful\Http::POST)     // Alternative to Request::post
        ->withoutStrictSsl()              // Ease up on some of the SSL checks
        ->expectsHtml()                   // Expect HTML responses
        ->sendsType(\Httpful\Mime::FORM); // Send application/x-www-form-urlencoded

    // Set it as a template
    \Httpful\Request::ini($template);

    // This new request will have all the settings
    // of our template by default.  We can override
    // any of these settings by settings them on this
    // new instance as we've done with expected type.
    $r = \Httpful\Request::init()->expectsJson();

## That's it

So that is the main gist of things.  You can find the source code on [GitHub](https://github.com/nategood/httpful).  Hopefully the next time you find yourself pulling your hair out using the PHP cURL client library to connect to a third party API, maybe Httpful can come to the rescue.

## Update

Finally have a landing page for the project.  Checkout the [Httpful PHP HTTP Client Site](http://phphttpclient.com).

## tl;dr

_The PHP cURL library is ugly and unintuitive.  Httpful is a sane HTTP library alternative that includes chaining, template requests, easy GPPD support, built in parsing and more.  It is on [GitHub](https://github.com/nategood/httpful)._

---

 - *Title* Httpful: The Sane PHP HTTP Library
 - *Keywords* http, php, rest, restful, httpful, curl