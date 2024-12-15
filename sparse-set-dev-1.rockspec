rockspec_format = "3.0"

package = "sparse-set"
version = "dev-1"

source = {
    url = "git://github.com/vereena0x13/sparse-set.lua.git",
    branch = "master"
}

description = {
    summary = "An efficient sparse set implementation",
    homepage = "https://github.com/vereena0x13/sparse-set.lua",
    issues_url = "https://github.com/vereena0x13/sparse-set.lua/issues",
    maintainer = "vereena0x13",
    license = "MIT",
    labels = {
        "serialization"
    }
}

dependencies = {
    "lua >= 5.1",
    "middleclass"
}

build = {
    type = "builtin",
    modules = {
        ["sparse-set"] = "sparse-set.lua"
    },
    copy_directories = {
        "docs",
        "spec"
    }
}

test_dependencies = {
    "busted",
    "busted-htest"
}

test = {
    type = "busted"
}