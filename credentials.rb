require 'sinatra'

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
  'xxx'
end

def http_auth_encode(password)
  'zzz'
end
