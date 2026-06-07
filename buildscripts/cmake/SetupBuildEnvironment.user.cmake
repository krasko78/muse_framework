# Disable optimizations for RelWithDebInfo for improved debugging experience and faster compilation
STRING(REPLACE "/O2" "/Od" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
STRING(REPLACE "/Ob1" "/Ob0" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")

# Fix conflicting /INCREMENTAL and /OPT:ICF options causing a linker warning in the MuseScoreStudio project.
add_link_options(
    $<$<CONFIG:RELWITHDEBINFO>:/INCREMENTAL>
    $<$<CONFIG:RELWITHDEBINFO>:/OPT:NOICF,NOREF,NOLBR>
)

# This is a fix for "Debug info corrupted, recompile module" occasional errors in Visual Studio.
# They have to do with the use of precompiled headers (PCH). Here is what happens:
#    1. The DeclareModuleSetup.cmake script sets the "muse_global" project to create a precompiled header
#       and the other projects to reuse it from muse_global. See each project's properties: "C/C++" -> "Precompiled Headers".
#
#    2. When PCH is reused in Visual Studio, the PDB file of the project creating the PCH - in this case "muse_global.pdb" -
#       must be copied into every project that reuses the PCH so that the debug symbols from the PCH are combined with
#       the project's own debug symbols. For every project that reuses the PCH, CMake automatically generates a file
#       called copy_idb_pdb_Debug.cmake (e.g. in msvc.build_x64\src\framework\ui\muse_ui.dir) and adds a Pre-Build event
#       to the project that runs CMake and makes it execute this file. See for example project muse_ui's properties:
#       "Build Events" -> "Pre-Build Event".
#
#    3. The local copy of "muse_global.pdb" is set as the Program Database file for all projects that reuse the PCH.
#       Take a look for example at project muse_ui's properties: "C/C++" -> "Ouptut Files" -> "Program Database File Name".
#
#    4. As the project is compiled, its debug symbols are added to the local copy of "muse_globa.pdb".
#       Thus the project's debug symbols are combined with the debug symbols of the PCH.
#
#    5. After the project is compiled, the accumulated local "muse_global.pdb" is copied and renamed as "<project_name>.pdb".
#       The accumulated "muse_global.pdb" is retained. So for project muse_ui for example, at the end of the compile process
#       there will be two identical files: "muse_global.pdb" and "muse_ui.pdb". The two files reside in different folders.
#       It is unclear where this copy operation is set up but if you enable detailed output in Visual Studio
#       ("Tools" -> "Options" -> "Projects and Solutions" -> "Build and Run") and build, you will see it in the output.
#
# Now, for a full build, this works. A problem appears when "muse_global.pdb" is regenerated. Let's illustrate with an example
# and take project "muse_ui". For a full rebuild, project "muse_global" is compiled first and "muse_global.pdb" in it is updated.
# Then when building "muse_ui", "muse_global.pdb" from "project "muse_globa" is copied into "muse_ui". "muse_ui" is compiled,
# let's say that "unity_0_cxx.obj", "unity_1_cxx.obj", "unity_2_cxx.obj" and "unity_3_cxx.obj" are generated. Their debug symbols
# are added to the local "muse_global.pdb" on top of what it already contains from the "muse_global" project. So we have:
#
#     muse_global.pdb in muse_ui =
#         muse_global.pdb from muse_global
#       + unity_0_cxx.obj's debug symbols
#       + unity_1_cxx.obj's debug symbols
#       + unity_2_cxx.obj's debug symbols
#       + unity_3_cxx.obj's debug symbols
#
# All good. Now let's make a change to "settings.h" (add a space, save, undo, save) and build "muse_ui". "muse_global"
# is recompiled since it depends on "settings.h" and "muse_global.pdb" is updated. It is copied into "muse_ui", "muse_ui"
# is compiled, but let's say this time only "unity_2_cxx.obj" is regenerated since the other files do not depend on
# "settings.h". The debug symbols from the generation of "unity_2_cxx.obj" are added to the local "muse_global.pdb"
# on top of what it already contains from the "muse_global project". So this time we have:
#
#     muse_global.pdb in muse_ui =
#         muse_global.pdb from muse_global
#      + unity_2's debug symbols
#
# We end up losing the debug symbols for "unity_0_cxx.obj", "unity_1_cxx.obj" and "unity_3_cxx.obj". Later when projects
# depending on project "muse_ui" are built, for example "muse_ui_tests", Visual Studio reports a PDB/lib corruption errors
# and says we should recompile the module (although it does not say which module). When this happens, doing a full rebuild
# or cleaning the "muse_global" project and building fixes the issue but it is very annoying.
# Our fix is to instruct the compiler to not generate PDB files but store the debug info in the OBJ and LIB files.
# CAVEAT: This will make those files much larger. But eliminating the error and not having to do full rebuilds is a huge win.
STRING(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")

# Suppress the generation of aotstats stuff and projects
set(QT_QML_GENERATE_AOTSTATS OFF)

if(CC_IS_MSVC)
    # suppress C4651 warnings: Precompiled header was compiled with symbol D but D is not defined for current compile
    add_compile_options(/wd4651)
endif()
