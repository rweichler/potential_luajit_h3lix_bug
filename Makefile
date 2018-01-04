APP_NAME=LuaJIT_Test.app

all:
	mkdir -p $(APP_NAME)
	clang main.m -isysroot $(shell xcrun --sdk iphoneos --show-sdk-path) -arch armv7 -arch arm64 -framework Foundation -framework UIKit -Ldeps/lib -Ideps/include -lluajit -o $(APP_NAME)/a.out
	ldid -S $(APP_NAME)/a.out
	cp Info.plist $(APP_NAME)

