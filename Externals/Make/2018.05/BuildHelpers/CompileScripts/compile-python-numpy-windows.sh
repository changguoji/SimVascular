subst S: C:/cygwin64/usr/local/sv/ext/2018.05/src

rm -Rf REPLACEME_SV_TOP_BLD_DIR_NUMPY
cp -Rf REPLACEME_SV_TOP_SRC_DIR_NUMPY REPLACEME_SV_TOP_BLD_DIR_NUMPY
cp tmp/compile.msvc.numpy.bat REPLACEME_SV_TOP_BLD_DIR_NUMPY
pushd REPLACEME_SV_TOP_BLD_DIR_NUMPY
cmd /C compile.msvc.numpy.bat
cp -Rf REPLACEME_SV_TOP_BIN_DIR_PYTHON/Lib/site-packages/*numpy*egg/numpy REPLACEME_SV_TOP_BIN_DIR_PYTHON/Lib/site-packages
popd

subst S: /D
