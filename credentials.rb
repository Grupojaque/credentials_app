require 'shellwords'  # To escape passwords passed to the command line
require 'sinatra'     # Minimal web framework

get '/' do
  erb :index
end

post '/encode' do
  password = params[:password]
  hashes = {
    'MySQL'     => mysql_encode(params[:password]),
    'Linux'     => linux_encode(params[:password]),
    'HTTP Auth' => http_auth_encode(params[:password]),
  }
  erb :encode, :locals => { hashes: hashes }
end

def mysql_encode(password)
  'yyy'
end

def linux_encode(password)
  `mkpasswd -m sha-512 #{Shellwords.escape(password)} 2>/dev/null`.chomp
  $?.exitstatus == 0 ? hash : '(mkpasswd not available)'
rescue Errno::ENOENT # Only failed this way once (on OSX). Not sure why.
  '(mkpasswd not available)'
end

def http_auth_encode(password)
  hash = `htpasswd -nbB user #{Shellwords.escape(password)} 2>/dev/null`.chomp.split(':').last
  $?.exitstatus == 0 ? hash : "(htpasswd not available, or version doesn't support bcrypt)"
end
