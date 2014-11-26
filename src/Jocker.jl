module Jocker

using Requests
using JSON

export Mode, socket, remote, Component, Container, Image, Ip, Port,
       Dock, lists, list

abstract Mode
abstract socket <: Mode
abstract remote <: Mode

abstract Component
abstract Container <: Component
abstract Image <: Component

typealias Ip String
typealias Port Unsigned


const OK = 200

immutable Dock
  host :: Ip
  port :: Port
  mode :: Union(Type{remote}, Type{socket})
end


headers = { "Content-Type" => "application/json"}

uri(conn::Dock, schema="http") = URI(schema, conn.host, conn.port)
uri(conn::Dock, path::String, schema="http") = URI(schema, conn.host, conn.port, path)

function list(e::Type{Container}, conn::Dock, query={"all" => 1})
  r = get(uri(conn, "/containers/json"), query=query)
  return r.status == OK ? JSON.parse(r.data) : []
end

function list(e::Type{Image}, conn::Dock, query={"all" => 1})
  r = get(uri(conn, "/images/json"), query=query)
  return r.status == OK ? JSON.parse(r.data) : []
end

end

macro lists(e, con)
  return :(list($e, $con))
end
