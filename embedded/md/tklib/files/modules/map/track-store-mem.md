
[//000000001]: # (map\_track\_store\_memory \- Map display support)
[//000000002]: # (Generated from file 'track\-store\-mem\.man' by tcllib/doctools with format 'markdown')
[//000000003]: # (map\_track\_store\_memory\(n\) 0\.1 tklib "Map display support")

<hr> [ <a href="../../../../toc.md">Main Table Of Contents</a> &#124; <a
href="../../../toc.md">Table Of Contents</a> &#124; <a
href="../../../../index.md">Keyword Index</a> &#124; <a
href="../../../../toc0.md">Categories</a> &#124; <a
href="../../../../toc1.md">Modules</a> &#124; <a
href="../../../../toc2.md">Applications</a> ] <hr>

# NAME

map\_track\_store\_memory \- In\-memory store for geo/track definitions

# <a name='toc'></a>Table Of Contents

  - [Table Of Contents](#toc)

  - [Synopsis](#synopsis)

  - [Description](#section1)

  - [API](#section2)

  - [EXAMPLE](#section3)

  - [Bugs, Ideas, Feedback](#section4)

  - [Keywords](#keywords)

  - [Category](#category)

# <a name='synopsis'></a>SYNOPSIS

package require Tcl 8\.6\-  
package require Tcl 8\.6\-  
package require debug  
package require debug::caller  
package require map::slippy 0\.8  
package require snit  
package require map::track::store::memory ?0\.1?  

# <a name='description'></a>DESCRIPTION

This package provides \.\.\. In\-memory store for geo/track definitions, with
memoized calculation of extended attributes\. Base data is taken from a backing
store\. Anything API\-compatible to map::track::store::fs

# <a name='section2'></a>API

# <a name='section3'></a>EXAMPLE

# <a name='section4'></a>Bugs, Ideas, Feedback

# <a name='keywords'></a>KEYWORDS

[center, geo/track](\.\./\.\./\.\./\.\./index\.md\#center\_geo\_track), [diameter,
geo/track](\.\./\.\./\.\./\.\./index\.md\#diameter\_geo\_track), [geo/track pixels,
zoom](\.\./\.\./\.\./\.\./index\.md\#geo\_track\_pixels\_zoom), [geo/track,
center](\.\./\.\./\.\./\.\./index\.md\#geo\_track\_center), [geo/track,
diameter](\.\./\.\./\.\./\.\./index\.md\#geo\_track\_diameter), [geo/track, memory
store](\.\./\.\./\.\./\.\./index\.md\#geo\_track\_memory\_store), [geo/track, perimeter
length](\.\./\.\./\.\./\.\./index\.md\#geo\_track\_perimeter\_length), [length,
geo/track, perimeter](\.\./\.\./\.\./\.\./index\.md\#length\_geo\_track\_perimeter),
[map](\.\./\.\./\.\./\.\./index\.md\#map), [memory store,
geo/track](\.\./\.\./\.\./\.\./index\.md\#memory\_store\_geo\_track), [perimeter length,
geo/track](\.\./\.\./\.\./\.\./index\.md\#perimeter\_length\_geo\_track), [pixels, zoom,
geo/track](\.\./\.\./\.\./\.\./index\.md\#pixels\_zoom\_geo\_track), [store, geo/track,
memory](\.\./\.\./\.\./\.\./index\.md\#store\_geo\_track\_memory), [zoom, geo/track
pixels](\.\./\.\./\.\./\.\./index\.md\#zoom\_geo\_track\_pixels)

# <a name='category'></a>CATEGORY

Map Display and Supporting Utilities
