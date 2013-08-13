all:

%.min.js: %.js
	@curl -d compilation_level=ADVANCED_OPTIMIZATIONS -d output_format=text -d output_info=compiled_code --data-urlencode "js_code@$<" http://closure-compiler.appspot.com/compile > $OUT

clean:
	@rm $(LIB)
