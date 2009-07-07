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