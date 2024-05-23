-- luacheck: push no unused

local assert    = require "luassert"

describe("sparse-set.lua", function()
    local sparse_set
    local SparseIntSet

    setup(function()
        sparse_set = require "sparse-set"
    end)

    teardown(function()
        sparse_set = nil
    end)

    it("loads", function()
        SparseIntSet = sparse_set.SparseIntSet

        assert(sparse_set ~= nil)
        assert(SparseIntSet ~= nil)
    end)

    describe("SparseIntSet", function()
        it("works", function()
            local s = SparseIntSet(100)

            assert.are.equal(0, s.count)

            assert(s:insert(3))
            assert(s:insert(5))
            assert(s:insert(9))
            assert(s:insert(42))

            assert.are.equal(4, s.count)
            assert(s:contains(3))
            assert(s:contains(5))
            assert(s:contains(9))
            assert(s:contains(42))

            assert.is_false(s:contains(69))

            do
                local a = { 3, 5, 9, 42 }
                local i = 1
                s:each(function(x)
                    assert.are.equal(a[i], x)
                    i = i + 1
                end)
            end

            assert(s:unordered_remove(5))

            do
                local a = { 3, 42, 9 }
                local i = 1
                s:each(function(x)
                    assert.are.equal(a[i], x)
                    i = i + 1
                end)
            end

            assert(s:insert(1))
            assert(s:insert(2))
            assert(s:insert(4))
            assert(s:insert(6))
            assert(s:insert(100))

            assert(s:ordered_remove(3))

            do
                local a = { 42, 9, 1, 2, 4, 6, 100 }
                local i = 1
                s:each(function(x)
                    assert.are.equal(a[i], x)
                    i = i + 1
                end)
            end

            assert.are.equal(7, s.count)

            s:clear()

            assert.are.equal(0, s.count)

            s:each(function(x)
                assert(false)
            end)
        end)
    end)
end)

-- luacheck: pop