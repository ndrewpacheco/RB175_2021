require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")

  params = params.split("&").each_with_object({}) do |pair, hsh|
    key, value = pair.split("=")
    hsh[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  # original parsing:

  # http_method = request_line.match(/^[A-Z]+/)[0]
  # path = request_line.match(/\/[^?]*/)[0]
  # query = request_line.match(/\?\S+/).to_s
  # params = query.scan(/\w+=\d/)

  # params.map! do |param|
  #   [param.match(/[a-z]+/).to_s, param.match(/\d+/).to_s]
  # end

  # params = params.to_h

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK\r\n\r\n"
  client.puts request_line
  client.puts http_method
  client.puts path
  client.puts params

  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  rolls.times do
    roll = rand(sides) + 1
    client.puts roll
  end

  client.close
end