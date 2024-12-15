--- sparse-set
-- An efficient sparse set implementation (based on [An Efficient Representation for Sparse Sets](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.30.7319&rep=rep1&type=pdf))
--
-- @module sparse-set
-- @author vereena0x13
-- @license MIT
-- @copyright Vereena Inara 2021-2024

local class = require "middleclass"

local SparseSet = class("sparse-set.SparseSet")

--- Creates a `SparseSet` object.
-- A `SparseSet` is an efficient representation of a set
-- that represents elements as positive integers in the range [1,N].
-- @tparam number length The maximum element the set may contain.
-- @treturn SparseSet
function SparseSet:initialize(length)
    self.dense = {}
    self.sparse = {}
    self.count = 0
    self.length = length
    for i = 1, length do
        self.dense[i] = 0
        self.sparse[i] = 0
    end
end

--- Checks if this `SparseSet` contains an element `x`.
-- @tparam number x
-- @treturn boolean
function SparseSet:contains(x)
    if type(x) ~= "number" then error("expected number, got " .. type(x)) end
    if x < 1 or x % 1 ~= 0 then error("expected integer >= 1, got " .. tostring(x)) end
    local s = self.sparse[x]
    return x <= self.length and s <= self.count and self.dense[s] == x
end

--- Inserts an element `x` into the `SparseSet`.
-- @tparam number x
-- @treturn boolean `true` if the element was inserted, `false` if it was already in the `SparseSet`.
function SparseSet:insert(x)
    if self:contains(x) then return false end
    if x > self.length then error("out of bounds: got " .. tostring(x) .. "; max is " .. tostring(self.length)) end

    self.count = self.count + 1
    self.dense[self.count] = x
    self.sparse[x] = self.count

    return true
end

--- Removes an element `x` from the `SparseSet`.
-- @tparam number x
-- @treturn boolean `true` if the element was remove, `false` if it was not in the `SparseSet`.
function SparseSet:unordered_remove(x)
    if not self:contains(x) then return false end

    local i = self.sparse[x]
    local e = self.dense[self.count]

    self.dense[i] = e
    self.sparse[e] = i
    self.count = self.count - 1

    return true
end

--- Removes an element `x` from the `SparseSet`, preserving insertion order.
-- @tparam number x
-- @treturn boolean `true` if the element was remove, `false` if it was not in the `SparseSet`.
function SparseSet:ordered_remove(x)
    if not self:contains(x) then return false end

    local s = self.sparse[x]
    for i = s, self.count - 1 do
        local e = self.dense[i + 1]
        self.dense[i] = e
        self.sparse[e] = i
    end
    self.count = self.count - 1

    return true
end

--- Removes all elements from the `SparseSet` in `O(1)` time.
function SparseSet:clear()
    self.count = 0
end

--- Calls the specified callback `fn` with each element in the `SparseSet`.
-- @tparam function fn
function SparseSet:each(fn)
    for i = 1, self.count do
        fn(self.dense[i])
    end
end

return setmetatable({
    _DESCRIPTION    = "An efficient sparse set implementation",
    _URL            = "https://github.com/vereena0x13/sparse-set.lua",
    _VERSION        = "sparse-set.lua 0.1.0",
    _LICENSE        = [[
        MIT License

        Copyright (c) 2021-2024 Vereena Inara

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    ]],
    SparseSet = SparseSet
}, {
    -- luacheck: push no unused args
    __newindex = function(t, k, v)
        error("cannot modify read-only table")
    end,
    --luacheck: pop
    __metatable = false
})
