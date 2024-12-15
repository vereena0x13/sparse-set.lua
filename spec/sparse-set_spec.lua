local assert    = require "luassert"

describe("sparse-set.lua", function()
    local SparseSet

    setup(function()
        local sparse_set = require "sparse-set"
        SparseSet = sparse_set.SparseSet
    end)

    teardown(function()
        SparseSet = nil
    end)

    describe("SparseSet", function()
        it("works", function()
            local s = SparseSet(100)

            assert.equal(0, s.count())

            assert(s.insert(3))
            assert(s.insert(5))
            assert(s(9))
            assert(s(42))
            assert.is_false(s(9))

            assert.equal(4, s.count())
            assert(s.contains(3))
            assert(s.contains(5))
            assert(s.contains(9))
            assert(s.contains(42))

            assert.is_false(s.contains(69))

            do
                local a = { 3, 5, 9, 42 }
                for i, x in s.iter() do
                    assert.equal(a[i], x)
                end
            end

            assert(s.unordered_remove(5))

            do
                local a = { 3, 42, 9 }
                for i, x in s.iter() do
                    assert.equal(a[i], x)
                end
            end

            assert(s.insert(1))
            assert(s.insert(2))
            assert(s.insert(4))
            assert(s.insert(6))
            assert(s.insert(100))

            assert(s[1])
            assert.is_false(s[27])

            assert(s.ordered_remove(3))

            do
                local a = { 42, 9, 1, 2, 4, 6, 100 }
                for i, x in s.iter() do
                    assert.equal(a[i], x)
                end
            end

            assert.equal(7, s.count())

            s.clear()

            assert.equal(0, s.count())

            assert(s.iter()() == nil)
        end)
    end)
end)