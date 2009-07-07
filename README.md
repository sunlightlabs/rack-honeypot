# Honeypot, a Rack Middleware for trapping spambots

Written by Luigi Montanez of the Sunlight Labs. Copyright 2009.

This middleware acts as a spam trap. It inserts, into every outputted `<form>`, a text field that a spambot will really want to fill in, but is actually not used by the app. The field is hidden to humans via CSS, and includes a warning label for screenreading software.

Then, for incoming requests, the middleware will check if the text field has been set to an unexpected value. If it has, that means a spambot has altered the field, and the spambot is booted to a dead end blank page.

## Configuration

To use in your Rails app, place `honeypot.rb` in `lib/rack`.

Then in `environment.rb`:

    config.middleware.use "Rack::Honeypot"

That's all there is to it.

There are a few options you can pass in:
  
  * `:class_name` is the class assigned to the parent div of the honeypot. Defaults to "phonetoy", an anagram of honeypot.
  * `:label` is the warning label displayed to those with CSS disabled. Defaults to "Don't fill in this field".
  * `:input_name` is the name of the form field. Ensure that this is tempting to a spambot if you modify it. Defaults to "email".
  * `:input_value` is the value of the form field that would only be modified by a spambot. Defaults to blank.

See the `Rack::Honeypot#initialize` method for the defaults.

If you want to modify the options used, simply do:

    config.middleware.use "Rack::Honeypot", :input_name => "firstname"

## Props

Based on [django-honeypot](http://github.com/sunlightlabs/django-honeypot) by James Turk.

Credit to Geoff Buesing for a first stab at this [idea in Rack](http://mad.ly/2009/05/01/honeypot-filter-as-a-rack-middleware/).

See LICENSE.md for proper reuse guidelines.