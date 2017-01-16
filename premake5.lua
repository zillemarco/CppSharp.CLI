-- This is the starting point of the build scripts for the project.
-- It defines the common build settings that all the projects share
-- and calls the build scripts of all the sub-projects.

dofile "CppSharp/build/Helpers.lua"
dofile "CppSharp/build/LLVM.lua"

solution "CppSharp.CLI"

  configurations { "Debug", "Release" }
  architecture "x86_64"

  filter "system:windows"
    architecture "x86"

  filter "system:macosx"
    architecture "x86"

  filter "configurations:Release"
    flags { "Optimize" }    

  filter {}

  characterset "Unicode"
  symbols "On"

  local action = _ACTION or ""
  
  location ("build/" .. action)

  objdir (path.join("./build/", action, "obj"))
  targetdir (path.join("./build/", action, "lib", "%{cfg.buildcfg}"))

  startproject "CppSharp.CLI"

  group "CppSharp"
    include("CppSharp/src/Core")
    include("CppSharp/src/AST")
    include("CppSharp/src/CppParser")
    include("CppSharp/src/CppParser/Bindings")
    include("CppSharp/src/CppParser/ParserGen")
    include("CppSharp/src/Parser")
    include("CppSharp/src/Generator")
    include("CppSharp/src/Runtime")

  group ""
  project "CppSharp.CLI"
    kind "ConsoleApp"
    language "C#"
    dotnetframework "4.6"
    location ("build/" .. action)
    
    objdir (path.join("./build/", action, "obj"))
    targetdir (path.join("./build/", action, "lib", "%{cfg.buildcfg}"))

    files { "src/*.cs" }

    links { "CppSharp", "CppSharp.AST", "CppSharp.Generator", "CppSharp.Parser", "CppSharp.Parser.CLI", "CppSharp.Runtime" }
    dependson { "CppSharp", "CppSharp.AST", "CppSharp.Generator", "CppSharp.Parser", "CppSharp.Parser.CLI", "CppSharp.Runtime" }