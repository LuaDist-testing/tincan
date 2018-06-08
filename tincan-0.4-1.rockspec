-- This file was automatically generated for the LuaDist project.

package = "tincan"
version = "0.4-1"

-- LuaDist source
source = {
  tag = "0.4-1",
  url = "git://github.com/LuaDist-testing/tincan.git"
}
-- Original source
-- source = {
--     url = "http://calminferno.net/lua/tincan-0.4.tar.gz"
-- }

description = {
    summary = "Dead simple persistent key value store library.",
    homepage = "http://calminferno.net/lua/",
    license = "GPLv3"
}

dependencies = {
    "lua >= 5.1"
}

build = {
    type = "builtin",
    modules = {
        tincan = "tincan.lua"
    }
}