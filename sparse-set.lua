--- sparse-set
-- An efficient sparse set implementation (based on [An Efficient Representation for Sparse Sets](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.30.7319&rep=rep1&type=pdf))
--
-- @module sparse-set
-- @author vereena0x13
-- @license MIT
-- @copyright Vereena Inara 2021-2024


local type          = type
local error         = error
local tostring      = tostring
local setmetatable  = setmetatable
local sprintf       = string.format
local math_floor    = math.floor


local function errorf(...) return error(sprintf(...)) end


local function check_integer(x)
    if type(x) ~= "number" or x ~= math_floor(x) then
        errorf("expected positive integer, got %s", tostring(x))
    end
end


local function check_bounds(x, len)
    if x < 1 or (len ~= nil and x > len) then
        errorf("out of bounds: expected positive integer between [1,%d], got %d", len, x)
    end
end


local SparseSet
--- Creates a `SparseSet` object.
-- A `SparseSet` is an efficient representation of a set
-- that represents elements as positive integers in the range [1,N].
-- @tparam number length The maximum element the set may contain.
-- @treturn SparseSet
function SparseSet(length)
    check_integer(length)
    if length <= 0 then error("SparseSet length must be >= 1") end

    local set = {}

    local dense = {}
    local sparse = {}
    local count = 0

    for i = 1, length do
        dense[i] = 0
        sparse[i] = 0
    end

    --- Returns the number of elements in this `SparseSet`.
    -- @treturn number
    function set.count() return count end

    --- Removes all elements from the `SparseSet` in `O(1)` time.
    function set.clear() count = 0 end

    --- Checks if this `SparseSet` contains an element `x`.
    -- @tparam number x
    -- @treturn boolean
    function set.contains(x)
        check_integer(x)
        check_bounds(x)
        local s = sparse[x]
        return x <= length and
               s <= count and
               dense[s] == x
    end
    local set_contains = set.contains

    --- Inserts an element `x` into the `SparseSet`.
    -- @tparam number x
    -- @treturn boolean `true` if the element was inserted, `false` if it was already in the `SparseSet`.
    function set.insert(x)
        if set_contains(x) then return false end
        check_bounds(x, length)

        count = count + 1
        dense[count] = x
        sparse[x] = count

        return true
    end
    local set_insert = set.insert

    --- Removes an element `x` from the `SparseSet`.
    -- @tparam number x
    -- @treturn boolean `true` if the element was removed, `false` if it was not in the `SparseSet`.
    function set.unordered_remove(x)
        if not set_contains(x) then return false end
        check_bounds(x, length)

        local i = sparse[x]
        local e = dense[count]

        dense[i] = e
        sparse[e] = i
        count = count - 1

        return true
    end

    --- Removes an element `x` from the `SparseSet`, preserving insertion order.
    -- @tparam number x
    -- @treturn boolean `true` if the element was removed, `false` if it was not in the `SparseSet`.
    function set.ordered_remove(x)
        if not set_contains(x) then return false end

        local s = sparse[x]
        for i = s, count - 1 do
            local e = dense[i + 1]
            dense[i] = e
            sparse[e] = i
        end
        count = count - 1

        return true
    end

    --- Returns an iterator function over indices up to the current `count` of this
    --- `SparseSet` as well as each associated element in the set.
    -- @treturn function
    function set.iter()
        -- TODO: produce an error if the set is modified while being iterated
        local i = 0
        return function()
            if i >= count then return end
            i = i + 1
            return i, dense[i]
        end
    end

    return setmetatable(set, {
        __metatable = "< SparseSet >",
        __newindex = function(_, _, _) error("access violation") end,
        __index = function(_, k)
            if type(k) == "number" then return set_contains(k) end
            return rawget(set, k)
        end,
        __call = function(_, x)
            check_integer(x)
            check_bounds(x, length)
            return set_insert(x)
        end,
        -- TODO: __tostring = function(_) return ... end
    })
end


return setmetatable({
    SparseSet       = SparseSet,
    _VERSION        = 'sparse-set.lua v0.1.0',
    _DESCRIPTION    = '',
    _URL            = 'https://github.com/vereena0x13/sparse-set.lua',
    _LICENSE        = [[
        MIT LICENSE

        Copyright (c) 2021-2024 Vereena Inara

        Permission is hereby granted, free of charge, to any person obtaining a
        copy of this software and associated documentation files (the
        "Software"), to deal in the Software without restriction, including
        without limitation the rights to use, copy, modify, merge, publish,
        distribute, sublicense, and/or sell copies of the Software, and to
        permit persons to whom the Software is furnished to do so, subject to
        the following conditions:

        The above copyright notice and this permission notice shall be included
        in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
        OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
        IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
        CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
        SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    ]],
}, {
    __metatable = "sparse-set.lua",
    __newindex  = function() error("access violation") end,
    __tostring  = function() return "sparse-set.lua" end,
    __call      = function(_, ...) return SparseSet(...) end
})