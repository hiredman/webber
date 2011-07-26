#import <Cocoa/Cocoa.h>
#import <WebKit/WebView.h>

#define WINDOW_X 800
#define WINDOW_Y 600

@interface Webber : NSObject {
  NSWindow* window;
}

@property (retain, nonatomic) NSWindow* window;

- (id) initWithStuff: (NSWindow *) w;

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector;

- (void) setWindowTitle: (NSString *) s;

- (SEL) SelectorFromString: (NSString *) s;

- (WebView*) createWebView;

- (void) addSubview:(NSView*) v;

- (void) runJS:(WebView*) wv code:(NSString*) c;

- (void) removeSubview:(NSView*) v;

@end

@implementation Webber

@synthesize window;

- (id) initWithStuff: (NSWindow *) w {
  [super init];
  self.window=w;
  return self;
}

- (void) setWindowTitle: (NSString *) s {
  [self.window setTitle:s];
}

- (SEL) SelectorFromString: (NSString*) s {
  return NSSelectorFromString(s);
}

- (WebView*) createWebView {
  return [[WebView alloc] initWithFrame:[[window contentView] frame]];
}

- (void) addSubview:(NSView*) v {
  [[self.window contentView] addSubview:v];
}

- (void) runJS:(WebView*) wv code:(NSString*) c {
  [wv stringByEvaluatingJavaScriptFromString:c];
}

- (void) removeSubview:(NSView*) v {
  [[self.window contentView] removeSubview: v];
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector { return NO; }

@end

int main ()
{
    [NSAutoreleasePool new];
    [NSApplication sharedApplication];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    id menubar = [[NSMenu new] autorelease];
    id appMenuItem = [[NSMenuItem new] autorelease];
    [menubar addItem:appMenuItem];
    [NSApp setMainMenu:menubar];
    id appMenu = [[NSMenu new] autorelease];
    id appName = [[NSProcessInfo processInfo] processName];
    id quitTitle = [@"Quit " stringByAppendingString:appName];
    id quitMenuItem = [[[NSMenuItem alloc] initWithTitle:quitTitle
        action:@selector(terminate:) keyEquivalent:@"q"] autorelease];
    [appMenu addItem:quitMenuItem];
    [appMenuItem setSubmenu:appMenu];
    id window = [[[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, WINDOW_X, WINDOW_Y)
        styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO]
            autorelease];
    [window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
    [window setTitle:appName];
    [window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
    id webv = [[WebView alloc] initWithFrame:[[window contentView] frame]];
    [window setContentView:[[NSSplitView alloc]
                             initWithFrame:[[window contentView] frame]]];
    [[window contentView] addSubview:webv];
    id note = [NSNotificationCenter defaultCenter];
    [note addObserverForName:@"NSApplicationDidFinishLaunchingNotification"
                      object:nil
                       queue:nil
                  usingBlock:^(NSNotification *n){
        [[webv mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"file:///Users/hiredman/src/webber/webber.html"]]];
        [[webv windowScriptObject] setValue:[[Webber alloc] initWithStuff:window] forKey:@"W"];
        [window makeFirstResponder:window];
          }];
    [NSApp run];
    return 0;
}
