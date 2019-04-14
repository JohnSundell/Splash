install:
	swift package update
	swift build -c release
	install .build/Release/SplashHTMLGen /usr/local/bin/SplashHTMLGen
	install .build/Release/SplashMarkdown /usr/local/bin/SplashMarkdown
	install .build/Release/SplashImageGen /usr/local/bin/SplashImageGen
	install .build/Release/SplashTokenizer /usr/local/bin/SplashTokenizer
