#include <lua/lua.h>
#include <lua/lauxlib.h>
#include <lua/lualib.h>
#include <syslog.h>

#import <UIKit/UIKit.h>

#define LOG(format, ...) syslog(LOG_WARNING, "LuaJIT_Test: " format, ## __VA_ARGS__)

int l_log(lua_State *L)
{
    LOG("%s", lua_tostring(L, 1));
    return 0;
}

bool dostring(lua_State *L, const char *str)
{
    bool success = luaL_dostring(L, str) == 0;
    if(!success) {
        LOG("ERROR: %s", lua_tostring(L, -1));
    }
    return success;
}

int main(int argc, char *argv[])
{
    LOG("starting");
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    lua_pushcfunction(L, l_log);
    lua_setglobal(L, "log");

    dostring(L, "ffi = require 'ffi'");
    LOG("generating mcode");
    dostring(L, "f = ffi.cast('void (*)()', function() log('jit works') end)");
    LOG("about to test jit");
    dostring(L, "f()");

    LOG("everything works! :D");

    return UIApplicationMain(argc, argv, nil, @"AppDelegate");
}

// app boilerplate

@interface AppDelegate : NSObject<UIApplicationDelegate>
@end

@implementation AppDelegate
-(BOOL)application:(id)a didFinishLaunchingWithOptions:(id)b
{

    return true;
}
@end
