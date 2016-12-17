-- This is the starting point of the build scripts for the project.
-- It defines the common build settings that all the projects share
-- and calls the build scripts of all the sub-projects.

include("Helpers")

solution "CSharpGenerator"

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

  objdir (path.join("./", action, "obj"))
  targetdir (path.join("./", action, "lib", "%{cfg.buildcfg}"))

  startproject "Generator"

  group "CppSharp"
    include("CppSharp/src/Core")
    include("CppSharp/src/AST")
    include("CppSharp/src/CppParser/Bindings/CSharp")
    include("CppSharp/src/Parser")
    include("CppSharp/src/Generator")
    include("CppSharp/src/Runtime")

  group ""
  project "Generator"
    kind "ConsoleApp"
    language "C#"
    dotnetframework "4.6"
    location ("build/" .. action)

    files { "src/*.cs" }

    links { "CppSharp", "CppSharp.AST", "CppSharp.Generator", "CppSharp.Parser", "CppSharp.Parser.CSharp", "CppSharp.Runtime" }
    dependson { "CppSharp", "CppSharp.AST", "CppSharp.Generator", "CppSharp.Parser", "CppSharp.Parser.CSharp", "CppSharp.Runtime" }