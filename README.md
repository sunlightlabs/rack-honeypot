# Honeypot, a Rack Middleware for trapping spambots

Written by Luigi Montanez of the Sunlight Labs, with contributions from Luc Castera. Copyright 2009.

This middleware acts as a spam trap. It inserts, into every outputted `<form>`, a text field that a spambot will really want to fill in, but is actually not used by the app. The field is hidden to humans via CSS, and includes a warning label for screenreading software.

In the `<body>`:

    <form>
      <div class='phonetoy'>
        <label for='email'>Don't fill in this field</label>
        <input type='text' name='email' value=''/>
      </div>
    [...]

In the `<head>`:
  
    <style type='text/css' media='all'>
      div.phonetoy {
        display:none;
      }
    </style>
  
Then, for incoming requests, the middleware will check if the text field has been set to an unexpected value. If it has, that means a spambot has altered the field, and the spambot is booted to a dead end blank page.

## Configuration

To use in your Rails app, place `honeypot.rb` in `lib/rack`.

Then in `environment.rb`:

    config.middleware.use "Rack::Honeypot"

That's all there is to it. Fire up your app, View Source on a page with a form, and see the magic.

There are a few options you can pass in:
  
  * `:class_name` is the class assigned to the parent div of the honeypot. Defaults to "phonetoy", an anagram of honeypot.
  * `:label` is the warning label displayed to those with CSS disabled. Defaults to "Don't fill in this field".
  * `:input_name` is the name of the form field. Ensure that this is tempting to a spambot if you modify it. Defaults to "email".
  * `:input_value` is the value of the form field that would only be modified by a spambot. Defaults to blank.

If you want to modify the options used, simply do:

    config.middleware.use "Rack::Honeypot", :input_name => "firstname"


## Tests

To run the tests:

    sudo gem install rack-test
    cd test
    ruby test_honeypot.rb

    
## Props

Based on [django-honeypot](http://github.com/sunlightlabs/django-honeypot) by James Turk.

Credit to Geoff Buesing for a first stab at this [idea in Rack](http://mad.ly/2009/05/01/honeypot-filter-as-a-rack-middleware/).

See LICENSE.md for proper reuse guidelines.
