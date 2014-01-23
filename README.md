#node-htmlcarve
Extract essential meta-informations from any web page, fast and dead simple.  Do you need general informations from a given html-site, like the title, a summary, a favicon or a possible RSS-Feed? Just throw an url into this module, and it'll try to find that stuff for you. 

## Installation
Clone this repository, grab the single coffeescript/javascript-file, or simply use NPM: 

```npm install htmlcarve```

##Usage
use it from the command line: 

```htmlcarve http://venturebeat.com/```

or from inside a script (I'll use coffeescript): 

```
htmlcarve = require "htmlcarve"
htmlcarve.fromUrl "http://venturebeat.com/", (error, data) ->
  console.log data.result
```

##Samples

```JSON
$ htmlcarve http://venturebeat.com/2014/01/20/ouch-hp-is-now-promoting-pcs-running-windows-7-because-windows-8-isnt-doing-so-hot/
{ source: 
   { html_meta: 
      { title: 'Ouch: HP is now promoting PCs running Windows 7 (because Windows 8 isn\'t doing so hot) | VentureBeat | Business | by Ricardo Bilton',
        summary: undefined,
        image: 'http://venturebeat.files.wordpress.com/2014/01/patrick-collison-headshot.jpg?w=311&h=150&crop=1',
        language: 'en',
        feed: 'http://feeds.venturebeat.com/VentureBeat',
        favicon: 'http://0.gravatar.com/blavatar/6a5449d7551fc1e8f149b0920ca4b6f6?s=16',
        keywords: undefined,
        author: undefined },
     open_graph: 
      { title: 'Ouch: HP is now promoting PCs running Windows 7 (because Windows 8 isn\'t doing so hot)',
        summary: 'HP\'s new Windows 7 promotion should tell you all you need to know about the state of its Windows 8 hardware. With its latest promotion, HP is heavily pushing PCs running Windows 7, which it says it...',
        image: 'http://venturebeat.files.wordpress.com/2014/01/hp-windows.png',
        language: undefined },
     twitter_card: 
      { title: undefined,
        summary: undefined,
        image: undefined,
        author: '@chernandburn' } },
  result: 
   { title: 'Ouch: HP is now promoting PCs running Windows 7 (because Windows 8 isn\'t doing so hot)',
     summary: 'HP\'s new Windows 7 promotion should tell you all you need to know about the state of its Windows 8 hardware. With its latest promotion, HP is heavily pushing PCs running Windows 7, which it says it...',
     image: 'http://venturebeat.files.wordpress.com/2014/01/hp-windows.png',
     author: '@chernandburn',
     language: 'en',
     feed: 'http://feeds.venturebeat.com/VentureBeat',
     favicon: 'http://0.gravatar.com/blavatar/6a5449d7551fc1e8f149b0920ca4b6f6?s=16',
     keywords: undefined },
  links: 
   { deep: 'http://venturebeat.com/2014/01/20/ouch-hp-is-now-promoting-pcs-running-windows-7-because-windows-8-isnt-doing-so-hot/',
     shallow: 'http://venturebeat.com/2014/01/20/ouch-hp-is-now-promoting-pcs-running-windows-7-because-windows-8-isnt-doing-so-hot/',
     base: 'http://venturebeat.com' } }
```

```JSON
$ htmlcarve http://www.spin.com/articles/miserable-halloween-dream-stream/
{ source: 
   { html_meta: 
      { title: 'Stream Miserable\'s Cratering \'Halloween Dream\' | SPIN | SPIN Mix | Premieres',
        summary: 'Ex-Whirr singer preps solo EP for February 18 release',
        image: 'http://www.spin.com/sites/all/themes/zen_spin/assets/images/default-images/spin-logo.png',
        language: 'en',
        feed: 'http://www.spin.com/rss.xml',
        favicon: 'http://www.spin.com/favicon.ico',
        keywords: 'miserable',
        author: undefined },
     open_graph: 
      { title: 'Stream Miserable\'s Cratering \'Halloween Dream\'',
        summary: 'Ex-Whirr singer preps solo EP for February 18 release',
        image: 'http://www.spin.com/sites/all/files/140122-miserable.jpg',
        language: undefined },
     twitter_card: 
      { title: 'Stream Miserable\'s Cratering \'Halloween Dream\'',
        summary: 'Ex-Whirr singer preps solo EP for February 18 release',
        image: 'http://www.spin.com/sites/all/files/140122-miserable.jpg',
        author: undefined } },
  result: 
   { title: 'Stream Miserable\'s Cratering \'Halloween Dream\'',
     summary: 'Ex-Whirr singer preps solo EP for February 18 release',
     image: 'http://www.spin.com/sites/all/files/140122-miserable.jpg',
     author: undefined,
     language: 'en',
     feed: 'http://www.spin.com/rss.xml',
     favicon: 'http://www.spin.com/favicon.ico',
     keywords: 'miserable' },
  links: 
   { deep: 'http://www.spin.com/articles/miserable-halloween-dream-stream/',
     shallow: 'http://www.spin.com/articles/miserable-halloween-dream-stream/',
     base: 'http://www.spin.com' } }
```

##How does this stuff work?
Htmlcarve will process several steps to gather all that informations. 

1. Scan for OpenGraphProtocol (OGP) metadata, and use ist. Usually these informations (if present) are the most valuable and desireable ones. 

2. Look for Twitter Card metadata. Append the found informations.

3. Go through general html metatags and extract informations from there. 

4. Merge the results. If any information is present in more than one step above, use the information from the higher-priorized source. *Priorization-order: OGP > TwitterCard > HtmlMetaTags.*

##ToDo/Roadmap: 
- summarize the html-content on the given page, if no further informations are found. 
- extract keywords if none are present
- include the full protocols, not only this quick'n'dirty hack. 
- include schema.org
- include microdata formats

##License
MIT.
