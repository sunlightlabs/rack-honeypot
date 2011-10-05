require 'rubygems'
require 'rack/test'
require 'test/unit'
require 'unindentable'

require File.expand_path(File.dirname(__FILE__) + '/../lib/rack/honeypot')

# To run this test, you need to have rack-test gem installed: sudo gem install rack-test

class HoneypotTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include Unindentable

  def app
    content = unindent <<-BLOCK
      <html>
        <head>
        </head>
        <body>
          <form></form>
          Hello World!
        </body>
      </html>
    BLOCK
    hello_world_app = lambda do |env|
      [
        200,
        {
          'Content-Type'   => 'text/plain',
          'Content-Length' => content.length.to_s
        },
        [content]
      ]
    end
    app = Rack::Honeypot.new(hello_world_app, :input_name => 'honeypot_email')
  end

  def test_normal_request_should_go_through
    get '/'
    assert_equal 200, last_response.status
    assert_not_equal '', last_response.body
  end

  def test_request_with_form_should_add_honeypot_css
    get '/'
    assert_equal 200, last_response.status
    css = unindent <<-BLOCK
      <style type='text/css' media='all'>
        div.phonetoy {
          display:none;
        }
      </style>
    BLOCK
    assert last_response.body.index(css)
  end

  def test_request_with_form_should_add_honeypot_div
    get '/'
    assert_equal 200, last_response.status
  
    div = unindent <<-BLOCK
      <div class='phonetoy'>
        <label for='honeypot_email'>Don't fill in this field</label>
        <input type='text' name='honeypot_email' value=''/>
      </div>
    BLOCK
    assert last_response.body.index(div)
  end
  
  def test_spam_request_should_be_sent_to_dead_end
    post '/', :honeypot_email => 'joe@example.com'
    assert_equal 200, last_response.status
    assert_equal '', last_response.body
  end

end
