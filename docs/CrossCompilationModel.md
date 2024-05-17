
# Cross-Compilation Model

## Components

When compiling Swift code, the compiler will consult three different sources of
inputs outside of the user provided code.

1. Compiler Resources
2. System (C/C++) Headers
3. Platform Swift Modules (SDK Overlay)

These pieces compose in a particular manner to build a system image to build
code against.

The compiler resources are content for the compiler that the compiler provides.
In the case of the Swift compiler, this includes the Swift shims. Whilst this is
a compiler resource, the packaging may not necessarily be part of the toolchain
due to interdependencies. Some of this content is required to process the
system headers themselves (e.g. clang's builtin resource headers).

The C/C++ system headers (and libraries) are what is traditionally called the
Unix "sysroot". On Darwin, this is the SDK which is shipped to the user, while
on Windows, this is called the Windows SDK, which is a separate installable
component.

The platform Swift modules provided by the SDK overlay overlays the sysroot or
(C/C++) SDK. This overlay is a set of "extensions" to the system provided
headers allowing for a better import into Swift. This may be in the form of API
Notes, module maps, wrapper types, or Swift `extension`s. This code may or may
not be fully inlined into the client code and thus be part of the platform ABI.

## Flags

The compiler resources are controlled via the driver flag `-resource-dir`.
This allows the driver to select the correct location in most cases while
allowing the developer control to override the value if required.
Normally, you should not need to set this flag as the location of these files is intrinsic to the compiler.

The system headers are more interesting. Since this is C/C++ content, this is
actually consumed through the clang importer rather than the Swift compiler. The
Swift toolchain uses clang as the C/C++ compiler on all platforms as it is
embedded to generate inline FFI to enable seamless C/C++ bridging to Swift. The
flag used by clang is derived from the GCC toolchain, and is spelt `--sysroot`.
The compiler driver is responsible for identifying the structure of the sysroot. When cross-compiling, there isn't a consistent location for these files, so the driver must expose an argument to specify where to find these files.
sysroot, although because there is no uniform installation location, this
parameter needs to be exposed to the user to allow selection, particularly in
the case of cross-compilation.

Currently, we do not have a good way to isolate the SDK overlay from the
remainder of the required content. On Darwin platforms, this content is shipped
as part of the SDK. As a result the singular `-sdk` flag allows control over the
platform SDK and SDK overlay. Windows uses a split model as the Windows SDK is
split into multiple components and can be controlled individually (i.e. UCRT
version, SDK version, VCRuntime version). The `-sdk` flag is used to specify the
location of the SDK overlay which is applied to the system SDK. By default, the
environment variable `SDKROOT` is used to seed the value of `-sdk`, though the
user may specify the value explicitly. Other platforms do not currently have a
flag to control this location and the toolchain defaults to a set of relative
paths to locate the content. This prevents cross-compilation as the included
content would be for a single platform.

## Solution

Generalising the above structure and sharing the common sharing gives way to the
following set of flags for cross-compilation:

1. `-target`: specifies the triple for the host
2. `-sysroot`: specifies the (C/C++) sysroot for the host platform content
3. `-sdk`: specifies the Swift SDK overlay for the host

The values for these may be defaulted by the driver on a per-platform basis.

The `-sysroot` flag identifies the location for the C/C++ headers and libraries required for compilation. This is primarily used by non-Darwin, non-Windows hosts as Darwin has its own SDK concept that allows for co-installation and Windows uses a different model which merges multiple locations in memory.

The `-sdk` flag identifies the location of the "Swift SDK overlay", which provides the necessary content for Swift compilation (including binary swiftmodules). This includes the standard library and the core libraries (dispatch, Foundation, and possibly XCTest - Windows isolates XCTest from the rest of the SDK). The Swift shims are also provided by this location as they are a dependency for properly processing the Swift core library.

## Compatibility

In order to retain compatibility with older toolchain releases which did not include support for the `-sysroot` flag, the driver shall default the value to the value provided to `-sdk`. This allows us to transition between the existing toolchains which expected a single root containing all the necessary components.
This allows the driver to make the most appropriate choice for the host that is
being compiled for without loss of generality. A platform may opt to ignore one
or more of these flags (e.g. Windows does not use `-sysroot` as the system
headers are not organised like the traditional unix layout).
