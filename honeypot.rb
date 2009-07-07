# Honeypot, a Rack Middleware for trapping spambots
#
# Written by Luigi Montanez of the Sunlight Labs. Copyright 2009.
#
# This middleware acts as a spam trap. It inserts, into every
# outputted <form>, a text field that a spambot will really
# want to fill in, but is actually not used by the app. The
# field is hidden to humans via CSS, and includes a warning
# label for screenreading software.
#
# Then, for incoming requests, the middleware will check if
# the text field has been set to an unexpected value. If it
# has, that means a spambot has altered the field, and the
# spambot is booted to a dead end blank page.
#
# To use in your Rails app, place this file in lib/rack.
# Then in environment.rb:
#   config.middleware.use "Rack::Honeypot"
#
# That's all you have do do!
# 
# There are a few options you can pass in:
#   :class_name is the class assigned to the parent div of the honeypot
#   :label is the warning label displayed to those with CSS disabled
#   :input_name is the name of the form field. Ensure that this is tempting to a spambot if you modify.
#   :input_value is the value of the form field that would only be modified by a spambot.
#
# See the Rack::Honeypot#initialize method for the defaults.
# 
# If you want to modify the options used, simply do:
#
#   config.middleware.use "Rack::Honeypot", :input_name => "firstname"
#
# Based on: http://github.com/sunlightlabs/django-honeypot
#
# Credit to Geoff Buesing for a first stab at this idea in Rack:
# http://mad.ly/2009/05/01/honeypot-filter-as-a-rack-middleware/
#
# See LICENSE for proper reuse guidelines.
module Rack
  class Honeypot

    def initialize(app, options={})
      @app = app
      @class_name = options[:class_name] || "phonetoy"
      @label = options[:label] || "Don't fill in this field"
      @input_name = options[:input_name] || "email"
      @input_value = options[:input_value] || ""
    end

    def call(env)
  
      # handle a request (inbound)
      form_hash = env["rack.request.form_hash"]
      if form_hash && form_hash[@input_name] != @input_value
        return [200, {'Content-Type' => 'text/html', "Content-Length" => "0"}, []]
      else
        # handle a response (outbound)
        status, headers, response = @app.call(env)
        response_body = ""
        response.each { |part| response_body += part }
        response_body = honeypotize(response_body)
        headers["Content-Length"] = response_body.length.to_s
        [status, headers, response_body]
      end
    end

    def honeypotize(body)
      css = "<style type='text/css' media='all'>div.#{@class_name} {display:none;}</style>"
      honeypot_field = "<div class='#{@class_name}'><label for='#{@input_name}'>#{@label}</label><input type='text' name='#{@input_name}' value='#{@input_value}'/></div>"
      body.gsub!(/<\/head>/, css + '</head>')
      body.gsub!(/<form(.*)>/, '<form\1>' + honeypot_field)
      body
    end

  end
end