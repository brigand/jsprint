#!/bin/sh

set -e

handle_fail() {
    echo; echo "Build failed"
    exit 1
}

# Ensure we're in the build directory
cd `dirname $0`

#tools/check-trailing-space.sh || handle_fail

OutDebugFile='output/jsprint.debug.js'
OutMinFile='output/jsprint.min.js'

# Delete output and temporary files (ensures we can write to them)
rm -f $OutDebugFile $OutMinFile $OutDebugFile.temp $OutMinFile.temp

cat closure-pre.js > $OutDebugFile.temp
cat ../src/bootstrap_gen.coffee | coffee -scb >> $OutDebugFile.temp
cat ../src/jsprint.coffee | coffee -scb >> $OutDebugFile.temp
cat closure-post.js >> $OutDebugFile.temp

# Now call Google Closure Compiler to produce a minified version
curl -d output_info=compiled_code -d output_format=text -d compilation_level=ADVANCED_OPTIMIZATIONS \
--data-urlencode js_code@$OutDebugFile.temp "http://closure-compiler.appspot.com/compile" > $OutMinFile.temp

# Finalise each file by prefixing with version header
cp version-header.js $OutDebugFile
cat $OutDebugFile.temp              >> $OutDebugFile
rm $OutDebugFile.temp

cp version-header.js $OutMinFile
cat $OutMinFile.temp                >> $OutMinFile
rm $OutMinFile.temp

# Read the version number, and trim any spaces 
Version=`cat version.txt | tr -d ' ' | sed 's/\n//g'`
sed -i -e "s/##VERSION##/$Version/g" $OutDebugFile $OutMinFile

# Delete the odd files left behind on Mac
rm -f output/*.js~

echo; echo "Build succeeded"

