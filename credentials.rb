# stdlib
require 'pathname'
require 'shellwords'  # To escape passwords passed to the command line
require 'json'

# gems
require 'sinatra'     # Minimal web framework
require 'mysql2'

get '/' do
  erb :index
end

post '/encode' do
  erb :encoded, :locals => { hashes: encode(params[:password]) }
end

get '/status' do
  hashes = encode('password')
  if hashes.detect { |_, hash| '(' == hash[0] }
    status 500
  end
  JSON.pretty_generate hashes
end

def encode(password)
  {
    'mysql' => mysql_encode(password),
    'linux' => linux_encode(password),
    'http'  => http_auth_encode(password),
  }
end

# Encoders

def mysql_encode(password)
  mysql.query(%[SELECT PASSWORD('#{mysql_escape_password(password)}')]).first.values.first
end

def linux_encode(password)
  hash = `mkpasswd -m sha-512 #{Shellwords.escape(password)} 2>/dev/null`.chomp
  $?.exitstatus == 0 ? hash : '(mkpasswd not available)'
rescue Errno::ENOENT # Only failed this way once (on OSX). Not sure why.
  '(mkpasswd not available)'
end

def http_auth_encode(password)
  hash = `htpasswd -nbB user #{Shellwords.escape(password)} 2>/dev/null`.chomp.split(':').last
  $?.exitstatus == 0 ? hash : "(htpasswd not available, or version doesn't support bcrypt)"
end

# Helpers

def mysql
  return @mysql if @mysql

  config_file = ENV['MYCNF'] || '~/.my.cnf'
  myconfig = Pathname.new(config_file).expand_path
  if myconfig.exist?
    @mysql = Mysql2::Client.new(:default_file => myconfig.to_s)
  else
    raise "MySQL login configuration file not found"
  end
  @mysql
end

def mysql_escape_password(password)
  password.gsub("'", "\\'")
end
