# Djinni CMake

# What's djinni-cmake?

`djinni-cmake` is a project based on
[`djinni`](https://github.com/dropbox/djinni) by _dropbox_ and
[`polly`](https://github.com/ruslo/polly) by _ruslo_.<br/>
It is aimed as a basic project from which to start for mobile development.

# I'd like to compile it...

Well, quite easy.<br/>
There exist two ways to compile the `djinni_cmake` library: the core one and
the target one.<br/>
Let's explore both of them in the next sections, but first of all write down
the requirements below mentioned, for those are valid in any case.

This is a brief, yet incomplete list of requirements:

* gcc with support for C++14 (gcc 5+)
* doxygen >= 1.8
* cmake >= 3.0.0
* python3
* git
* graphviz (used by doxygen)

# Compile djinni-cmake: the core way.

The core way can be used to compile the `djinni_cmake` library for the host
system, as well as to extract the documentation.<br/>
It cannot be used to compile the library for the target systems (as an
example, Android or iOS).

First of all, run the following command from the root directory:

* `./deps.sh`

That script will download and compile all the dependencies of the project and
the `djinni-cmake` library won't compile without them being correctly set.<br/>
It could happen that you will never use this script again in the future, so feel
free to forget about it.

After building dependencies, you should run the following command:

* `./idl.sh`

This will regenerate any interface bindings that are defined in the interface
definition file.<br/>
Note that this intermediate step should be repeated again and again every time
a `.djinni` file is modified.

Finally, because in-source build is not allowed, you must move into the
`build` subdirectory and run the following commands:

* `cd build`
* `cmake ..`

By default, the build system sets internally the build type _Debug_, thus the
above commands will end in a bigger library which contains also the debug
symbols and will have been compiled with no optimizations at all.<br/>
In order to get the release version, use the following commands instead:

* `cd build`
* `cmake -DCMAKE_BUILD_TYPE=Release ..`

Any other approach is discouraged and isn't supported.

Finally, you can decide which target to compile (all the dependencies between
the targets should have been set along with the cmake configuration, anyway I
kindly invite you to point out any inconsistency).

It follows a summary of the most interesting targets from the available ones:

* `make` - Do you really need more details? :-)
* `make djinni_cmake` - Compile the `djinni_cmake` library
* `make docs` - Extract the documentation
* `make test` - Run all the available tests
* `make install` - Install all the artifacts in `<djinni_cmake.dir>/install/default`
* `make package` - Create a package that contains... well, almost everything

For further details and the complete list of targets, please consider to start
studying how the fantastic world of cmake and make works.

Because of a arguable issue of cmake, running the target _test_ won't work for
it doesn't depend on the tests themselves. You have to compile them before to
run the above mentioned target.<br/>
To execute the available tests, run the following commands:

* `make`
* `make test`

The same applies for the targets _install_ and _package_, for which the
following commands should be executed:

* `make`
* `make docs`
* `make install`
* `make package`

You can rebuild everything from scratch by simply deleting the content of the
`build` directory, as an example by using the following commands:

* `cd build`
* `rm -rf *`

# Compile djinni-cmake: the target way.

In order to compile the `djinni_cmake` library for the target platforms (that
is, at the time this document had been written, Android and iOS), the
followings are the required steps.

Copy the file `config.build.example` as `config.build` (do not simply rename
it), thus update the `config.build` file.<br/>
That file is highly commented, so it's suggested to open it and carefully read
it. By means of that file the user can properly set the target platform he wants
to compile for, the requested toolchains and all the required parameters which
are mandatory for the build system itself.

After that, run the following command:

* `./build.sh`

If everything is correctly configured, the build system starts and takes its
time to compile everything (at least, the first time it takes a while, while it
takes far less the other times, unless the user drops the hidden build
directory).

At the end of the build process, everything will be installed within the
directory: `<djinni_cmake.dir>/install`, properly placed within the right
directories.

# Does it work?

For further details, doubts and/or errors in the build system, please feel free
to contact me.<br/>
Have a look at the `AUTHORS` file for further details.
