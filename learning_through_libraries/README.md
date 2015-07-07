# Learning through Libraries

I believe that a good library...

- teaches the user about the domain it models
- makes it easy to create correct systems via composing high-level functions
- doesn't restrict the user from accessing low-level functions

A poor library instead attempts to accomplish things _for_ the user, usually
failing to predict how the library will ultimately be used.

A great example of quality library structure is Haskell's [WAI][1], which
presents an lightweight interface for creating web applications. With only a
basic understanding of HTTP, we proceed to create a web application— and learn
quite a bit about HTTP requests and responses—by following the types presented
in WAI and some corresponding libraries.

 [1]: http://hackage.haskell.org/package/wai
