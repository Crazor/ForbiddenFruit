// Taken from https://gist.github.com/lukeredpath/1057420
// See http://lukeredpath.co.uk/blog/a-note-on-objective-c-singletons.html

#ifndef ForbiddenFruit_GCDSingleton_h
#define ForbiddenFruit_GCDSingleton_h

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#endif
