require 'unindentable'

module Rack
  class Honeypot
    include Unindentable

    HONEYPOT_HEADER = "X-Honeypot"

    def initialize(app, options={})
      @app = app

      @class_name     = options[:class_name] || "phonetoy"
      @label          = options[:label] || "Don't fill in this field"
      @input_name     = options[:input_name] || "email"
      @input_value    = options[:input_value] || ""
      @logger         = options[:logger]
      @always_enabled = options.fetch(:always_enabled, true)
    end

    def call(env)
      if spambot_submission?(Rack::Request.new(env).params)
        @logger.warn("[Rack::Honeypot] Spam bot detected; responded with null") unless @logger.nil?
        null_response
      else
        status, headers, body = @app.call(env)

        if @always_enabled || honeypot_header_present?(headers)
          body = insert_honeypot(body)
          headers = response_headers(headers, body)
        end

        [status, headers, body]
      end
    end

    private

    def spambot_submission?(form_hash)
      form_hash && form_hash[@input_name] && form_hash[@input_name] != @input_value
    end

    def honeypot_header_present?(headers)
      header = headers.delete(HONEYPOT_HEADER)
      header && header.index("enabled")
    end
    
    def null_response
      [200, {'Content-Type' => 'text/html', "Content-Length" => "0"}, []]
    end
    
    def response_body(response)
      body = ""

      # The body may not be an array, so we need to call #each here.
      response.each {|part| body << part }

      body
    end
    
    def response_headers(headers, body)
      headers.merge("Content-Length" => body.length.to_s)
    end

    def insert_honeypot(body)
      body = response_body(body)
      body.gsub!(/<\/head>/, css + "\n</head>")
      body.gsub!(/<form(.*)>/, '<form\1>' + "\n" + div)
      body
    end

    def css
      unindent <<-BLOCK
        <style type='text/css' media='all'>
          div.#{@class_name} {
            display:none;
          }
        </style>
      BLOCK
    end

    def div
      unindent <<-BLOCK
        <div class='#{@class_name}'>
          <label for='#{@input_name}'>#{@label}</label>
          <input type='text' name='#{@input_name}' value='#{@input_value}'/>
        </div>
      BLOCK
    end

  end
end
