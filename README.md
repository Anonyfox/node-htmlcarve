#node-htmlcarve
Extract essential meta-informations from any web page, fast and dead simple.  Do you need general informations from a given html-site, like the title, a summary, a favicon or a possible RSS-Feed? Just throw an url into this module, and it'll try to find that stuff for you. 

**warning: this isn't ready for anything than tinkering around. there are currently *no tests* written!!**


## Installation
Clone this repository, grab the single coffeescript/javascript-file, or simply use NPM: 

```npm install htmlcarve``` 
(not yet published)

##Usage
use it from the command line: 

```htmlcarve http://venturebeat.com/```

or from inside a script (I'll use coffeescript): 

```
htmlcarve = require "htmlcarve"
htmlcarve.fromUrl "http://venturebeat.com/", (error, data) ->
  console.log data.info
```

The returned `data` object has several attributes, where `data.info` is the compressed general result. It has the following fields of interest: 

* `title` #=> the "headline" of the page. 
* `summary` #=> a short snippet describing the content
* `image` #=> an image to illustrate that stuff
* `author` #=> any author/creator of the page/content
* `language` #=> the language of this content.
* `feed` #=> the url of a rss/atom-feed if existing
* `favicon` #=> the url of an favicon of the page
* `keywords` #=> an array of keywords describing the page.

##How does this stuff work?
Htmlcarve will process several steps to gather all that informations. 
1. Scan for OpenGraphProtocol (OGP) metadata, and use ist. Usually these informations (if present) are the most valuable and desireable ones. 
2. Look for Twitter Card metadata. Append the found informations.
3. Go through general html metatags and extract informations from there. 
4. Merge the results. If any information is present in more than one step above, use the information from the higher-priorized source. Priorization-order: OGP > TwitterCard > HtmlMetaTags. 

##ToDo/Roadmap: 
- summarize the html-content on the given page, if no further informations are found. 
- extract keywords if none are present
- write some tests ;_;
- clean up the code
- include the full protocols, not only this quick'n'dirty hack. 
- include schema.org
- include microdata formats