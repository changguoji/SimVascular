# Copyright (c) 2014-2015 The Regents of the University of California.
# All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
# OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
set(proj TCL)
set(${proj}_DEPENDENCIES "")
if(LINUX)

endif()

ExternalProject_Include_Dependencies(${proj}
	PROJECT_VAR proj
	DEPENDS_VAR ${proj}_DEPENDENCIES
	EP_ARGS_VAR ${proj}_EP_ARGS
	USE_SYSTEM_VAR ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj}
	)

if(${PROJECT_NAME}_USE_SYSTEM_${proj})
	unset(${proj}_LIB_DIR CACHE)
endif()

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})

	unset(TCL_INCLUDE_PATH CACHE)
	unset(TCL_LIBRARY CACHE)
	unset(TCL_TCLSH CACHE)
	unset(TK_INCLUDE_PATH CACHE)
	unset(TK_LIBRARY CACHE)
	unset(TK_WISH CACHE)

	set(${proj}_OUTPUT_DIR ${CMAKE_BINARY_DIR}/externals/TclTk)
	set(${proj}_OUTPUT_BIN_DIR ${CMAKE_BINARY_DIR}/externals/TclTk)

	if(LINUX)
		set(SuperBuild_${proj}_URL "${SV_SUPERBUILD_LIBS_DIR}/linux/ubuntu/latest/tcltk-8.5.11-linux-x64-gnu.tar.gz" CACHE
			STRING "Location of ${proj}, can be web address or local path")
	elseif(APPLE)
		set(SuperBuild_${proj}_URL "${SV_SUPERBUILD_LIBS_DIR}/mac_osx/clang/latest/clang.x64.tcltk-8.6.4.tar.gz" CACHE
			STRING "Location of ${proj}, can be web address or local path")
	elseif(WIN32)
		set(SuperBuild_${proj}_URL "${SV_SUPERBUILD_LIBS_DIR}/windows/msvc_2013/latest/msvc_2013.x64.tcltk-8.6.4.zip" CACHE
			STRING "Location of ${proj}, can be web address or local path")
	endif()
	mark_as_superbuild(SuperBuild_${proj}_URL:STRING)
	mark_as_advanced(SuperBuild_${proj}_URL)

	set(SV_${proj}_DIR ${${proj}_SOURCE_DIR})
	
	ExternalProject_Add(${proj}
		URL ${SuperBuild_${proj}_URL}
		PREFIX ${${proj}_OUTPUT_DIR}-prefix
		SOURCE_DIR ${${proj}_OUTPUT_DIR}
		BINARY_DIR ${${proj}_OUTPUT_BIN_DIR}
		CONFIGURE_COMMAND ""
		BUILD_COMMAND ""
		UPDATE_COMMAND ""
		INSTALL_COMMAND ""
		CMAKE_CACHE_ARGS
		-DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
		-DCMAKE_C_COMPILER:STRING=${CMAKE_C_COMPILER}
		-DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
		-DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
		-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
		)

	if(WIN32)
		set(${proj}_SOURCE_DIR ${${proj}_OUTPUT_DIR})

		set(TCL_DLL_PATH ${${proj}_OUTPUT_BIN_DIR}/bin)
		set(TCL_INCLUDE_PATH ${${proj}_OUTPUT_BIN_DIR}/include)
		set(TCL_LIBRARY ${${proj}_OUTPUT_BIN_DIR}/lib/tcl85t.lib)
		set(TCL_TCLSH ${${proj}_OUTPUT_BIN_DIR}/bin/tclsh85t.exe)

		set(TK_INCLUDE_PATH ${${proj}_OUTPUT_BIN_DIR}/include)
		set(TK_LIBRARY ${${proj}_OUTPUT_BIN_DIR}/lib/tk85t.lib)
		set(TK_WISH ${${proj}_OUTPUT_BIN_DIR}/bin/wish85t.exe)
	endif()
	if(LINUX)

		set(${proj}_SOURCE_DIR ${${proj}_OUTPUT_DIR})
		set(SV_TCL_DIR ${${proj}_SOURCE_DIR})

		set(TCL_DLL_PATH ${${proj}_OUTPUT_BIN_DIR}/bin)
		set(TCL_INCLUDE_PATH ${${proj}_OUTPUT_BIN_DIR}/include)
		set(TCL_LIBRARY ${${proj}_OUTPUT_BIN_DIR}/lib/libtcl8.5.so)
		set(TCL_TCLSH ${${proj}_OUTPUT_BIN_DIR}/bin/tclsh8.5)

		set(TK_INCLUDE_PATH ${${proj}_OUTPUT_BIN_DIR}/include)
		set(TK_LIBRARY ${${proj}_OUTPUT_BIN_DIR}/lib/libtk8.5.so)
		set(TK_WISH ${${proj}_OUTPUT_BIN_DIR}/bin/wish8.5)
		mark_as_superbuild(TCL_INIT_PATH:PATH)
	endif()
	if(APPLE)
		set(${proj}_SOURCE_DIR ${${proj}_OUTPUT_DIR})
		set(SV_TCL_DIR ${${proj}_SOURCE_DIR})
		set(Tcl_Framework_Dir ${${proj}_OUTPUT_BIN_DIR}/Library/Frameworks/Tcl.framework)
		set(Tk_Framework_Dir ${${proj}_OUTPUT_BIN_DIR}/Library/Frameworks/Tk.framework)

		set(TCL_INCLUDE_PATH ${Tcl_Framework_Dir}/Headers)
		set(TCL_LIBRARY ${Tcl_Framework_Dir}/Versions/8.6/Tcl)
		set(TCL_TCLSH ${SuperBuild_${proj}_URL}/bin/tclsh8.6)

		set(TK_INCLUDE_PATH ${Tk_Framework_Dir}/Headers)
		set(TK_LIBRARY ${Tk_Framework_Dir}/Versions/8.6/Tk)
		set(TK_WISH ${SuperBuild_${proj}_URL}/bin/wish8.6)
		mark_as_superbuild(TCL_INIT_PATH:PATH)
	endif()

else()
	ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()

mark_as_superbuild(${proj}_SOURCE_DIR:PATH)
mark_as_superbuild(SV_${proj}_DIR:PATH)
mark_as_superbuild(TCL_DLL_PATH:PATH)
mark_as_superbuild(TCL_INCLUDE_PATH:PATH)
mark_as_superbuild(TCL_LIBRARY:PATH)
mark_as_superbuild(TCL_TCLSH:PATH)
mark_as_superbuild(TK_INCLUDE_PATH:PATH)
mark_as_superbuild(TK_LIBRARY:PATH)
mark_as_superbuild(TK_WISH:PATH)



#mark_as_superbuild(
	#  VARS ${proj}_DIR:PATH
	#  LABELS "FIND_PACKAGE"
	#  )

