http = require("http")
path = require("path")
express = require("express")
md = require("markdown").markdown
fs = require("fs")
# optimist = require("optimist")
_ = require("underscore")

# todo breakout
read = (path) ->
  md.toHTML((fs.readFileSync path).toString())
init = (dir)->
  names = fs.readdirSync dir
  content = names.map (fn) -> read "#{dir}/#{fn}"
  cache = _.object names, content

  get: (fn) -> cache[fn]
  rand: () -> cache[names[Math.floor(Math.random() * names.length)]]
  links: () -> names.map (name) -> {link: "/" + name.replace(".md", "")}

conf =
  port: 80
  title: "My Blog powered by Inkt"
  dev: false
  serveStatic: true
  location:
    articles: "/content/articles"
    partials: "/content/partials"

if process.argv[2]
  cp = path.resolve(__dirname + "/" + process.argv[2])
  try
    _.extend conf, JSON.parse fs.readFileSync cp # todo better handle file paths
  catch e
    console.warn "[warn] Unable to read config file " + cp # todo use logger
    console.warn e.message

basedir = __dirname.replace /\/src$/, ""
partialdir = basedir + conf.location.partials
cache = init basedir + conf.location.articles

# App Configuration and Middleware
app = express()
app.set "views", __dirname + "/templates" # todo use theme dir conf.location.theme
app.use "/assets", express.static(basedir + "/assets") if conf.serveStatic
app.use express.logger 'dev' if conf.dev

# Routes
app.get "/", (req, res) ->
  res.render "home.jade",
    conf: conf
    intro: read partialdir + "/intro.md"

app.get "/dev/random", (req, res) ->
  # todo add Location header to actual article URL
  res.render "article.jade",
    conf: conf
    content: cache.rand()

app.get "/posts", (req, res) ->
  res.render "posts.jade",
    conf: conf
    articles: cache.links()

app.get "/:article", (req, res, next) ->
  content = cache.get "#{req.params.article}.md"
  res.status(404).render("errors/404.jade", conf: conf) unless content
  res.render "article.jade",
    conf: conf
    content: content

server = app.listen conf.port
