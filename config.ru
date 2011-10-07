require 'bundler/setup'
require 'sinatra/base'
require 'rack/rewrite'


use Rack::Rewrite do
  r301 %r{/?/(.*)}, 'http://blog.xdite.net/$1', :if => Proc.new { |rack_env|
    (rack_env["QUERY_STRING"] =~ /p=(.+)/) || rack_env["QUERY_STRING"] =~ /q=(.+)/ || rack_env["QUERY_STRING"] =~ /feed=(.+)/
  }
end

# The project root directory
$root = ::File.dirname(__FILE__)

class SinatraStaticServer < Sinatra::Base  

  get(/.+/) do
    send_sinatra_file(request.path) {404}
  end

  not_found do
    send_sinatra_file('404.html') {"Sorry, I cannot find #{request.path}"}
  end

  def send_sinatra_file(path, &missing_file_block)
    file_path = File.join(File.dirname(__FILE__), 'public',  path)
    file_path = File.join(file_path, 'index.html') unless file_path =~ /\.[a-z]+$/i  
    File.exist?(file_path) ? send_file(file_path) : missing_file_block.call
  end

end

run SinatraStaticServer