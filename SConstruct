#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")
# tweak this if you want to use different folders, or more folders, to store your source code in.
env["ENV"] = os.environ
env.ParseConfig("pkg-config dbus-1 --cflags --libs")
sources = Glob("src/*.cpp")

if env["platform"] == "linux":
    library = env.SharedLibrary(
        "addons/dbus/bin/libdbusg{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )
else:
    library = None

Default(library)
