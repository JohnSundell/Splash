install:
	swift package update
	swift build -c release
	install .build/release/SplashHTMLGen /usr/local/bin/SplashHTMLGen
	install .build/release/SplashMarkdown /usr/local/bin/SplashMarkdown
	install .build/release/SplashImageGen /usr/local/bin/SplashImageGen
	install .build/release/SplashTokenizer /usr/local/bin/SplashTokenizer
