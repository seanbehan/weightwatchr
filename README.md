# WeightWatchr

A simple Spine, localStorage application that tracks your weight.

You can preview the app here http://seanbehan.com/weightwatchr

There is a Spine presentation here http://seanbehan.com/weightwatchr/presentation.html

## Installation

The Spine application code is written in Coffeescript and when saved is compiled (with Guard) to the lib/application.js file.

If you make any changes to lib/application.coffee and want automatic compilation, Ruby and Rubygems are required. Otherwise just 
manually compile Coffeescript.

```bash
git clone git@github.com:bseanvt/weightwatchr.git
cd weightwatchr
bundle install
bundle exec guard # Coffeescript should compile automatically!
```

This is just a regular HTML/Javascript application so it should run in any browser without the need for a server. Just open the index.html file and everything is good to go!