module Rack
  class Honeypot

    def initialize(app, options={})
      @app = app
      @class_name   = options[:class_name] || "phonetoy"
      @label        = options[:label] || "Don't fill in this field"
      @input_name   = options[:input_name] || "email"
      @input_value  = options[:input_value] || ""
    end

    def call(env)
      if spambot_submission?(Rack::Request.new(env).params)
        send_to_dead_end
      else
        status, headers, response = @app.call(env)
        new_body = insert_honeypot(build_response_body(response))
        new_headers = recalculate_body_length(headers, new_body)
        [status, new_headers, new_body]
      end
    end

    def spambot_submission?(form_hash)
      form_hash && form_hash[@input_name] && form_hash[@input_name] != @input_value
    end
    
    def send_to_dead_end
      [200, {'Content-Type' => 'text/html', "Content-Length" => "0"}, []]
    end
    
    def build_response_body(response)
      response_body = ""
      response.each { |part| response_body += part }
      response_body
    end
    
    def recalculate_body_length(headers, body)
      new_headers = headers
      new_headers["Content-Length"] = body.length.to_s
      new_headers
    end

    def insert_honeypot(body)
      css = <<-CSSCODE
      <style type='text/css' media='all'>
        div.#{@class_name} {
          display:none;
        }
      </style>
      CSSCODE
      
      div = <<-DIVCODE
      <div class='#{@class_name}'>
        <label for='#{@input_name}'>#{@label}</label>
        <input type='text' name='#{@input_name}' value='#{@input_value}'/>
      </div>
      DIVCODE

      body.gsub!(/<\/head>/, css + "\n</head>")
      body.gsub!(/<form(.*)>/, '<form\1>' + "\n" + div)
      body
    end

  end
end
