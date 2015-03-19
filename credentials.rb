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
  password = params[:password]
  hashes = {
    'mysql' => mysql_encode(params[:password]),
    'linux' => linux_encode(params[:password]),
    'http'  => http_auth_encode(params[:password]),
  }
  erb :encoded, :locals => { hashes: hashes }
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
