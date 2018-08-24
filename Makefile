install:
	swift package update
	swift build -c release -Xswiftc -static-stdlib
	install .build/Release/SplashHTMLGen /usr/local/bin/SplashHTMLGen
	install .build/Release/SplashImageGen /usr/local/bin/SplashImageGen
	install .build/Release/SplashTokenizer /usr/local/bin/SplashTokenizer
