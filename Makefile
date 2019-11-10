all:
	haxe build.hxml

retail:
	rm -rf build
	rm -rf retail
	mkdir -p retail/build
	haxe build.hxml
	rsync -avzm . ./retail -progress --exclude='**/phaser.js' --include='deps/**/*.css' --include='deps/**/*.js' --include='data/**' --include='src/*.css' --exclude='haxe-babylon' --exclude='examples' --exclude='test' --include='src/*.html' --include='*/' --include='index.html' --exclude='*'
	uglifyjs --compress --mangle -- build/generated.js > retail/build/generated.js

zip: retail
	rm -f retail.zip
	cd retail && zip -r ../retail.zip ./*

.PHONY: all retail
