--[[
Copyright (c) 2011 James Turner <james@calminferno.net>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

--[[
Tincan v0.4 - dead simple persistent key value store library

Usage:
    local tincan = require("tincan")
    tincan.load()

    local uid = tincan.set("uid", 1)

    tincan.set("uid:" .. uid, {name = "Jane Doe",
                               email = "jane.doe@example.com"})
    uid = tincan.incr("uid")

    tincan.set("uid:" .. uid, {name = "John Doe",
                               email = "john.doe@example.com"})
    uid = tincan.incr("uid")

    tincan.save()

    -- <more code here>

    local user = tincan.get("uid:1")
    print(user.name, user.email)
]]

local M = {}
M.store = {}

local function serialize(o)
    local t = {}

    if type(o) == "boolean" or type(o) == "number" then
        table.insert(t, tostring(o))
    elseif type(o) == "string" then
        table.insert(t, string.format("%q", o))
    elseif type(o) == "table" then
        table.insert(t, "{")

        for k, v in pairs(o) do
            table.insert(t, "[")
            table.insert(t, serialize(k))
            table.insert(t, "] = ")
            table.insert(t, serialize(v))
            table.insert(t, ",")
        end

        table.insert(t, "}")
    else
        error("cannot serialize a " .. type(o))
    end

    return table.concat(t)
end

function M.set(key, value)
    M.store[key] = value
    return value
end

M.put = M.set -- will be removed in next version

function M.get(key)
    return M.store[key]
end

function M.delete(key)
    M.store[key] = nil
    return nil
end

function M.exists(key)
    if M.store[key] ~= nil then
        return true
    else
        return false
    end
end

function M.incr(key)
    local value = M.store[key]

    if type(value) == "number" then
        M.store[key] = value + 1
        return value + 1
    else
        error("cannot increment a non-number")
    end
end

function M.decr(key)
    local value = M.store[key]

    if type(value) == "number" then
        M.store[key] = value - 1
        return value - 1
    else
        error("cannot decrement a non-number")
    end
end

function M.load(file)
    file = file or "tincan.db"
    local func, err = loadfile(file)

    if func then
        M.store = func()
    elseif not string.find(err, "No such file", 1, true) then
        error("cannot parse file " .. file)
    end
end

function M.save(file)
    file = file or "tincan.db"
    file = assert(io.open(file, "w"))
    file:write("return " .. serialize(M.store))
    file:close()
end

return M
