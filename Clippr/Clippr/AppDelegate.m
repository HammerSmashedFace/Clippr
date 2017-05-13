//
//  AppDelegate.m
//  Clippr
//
//  Created by Viktor Radulov on 5/13/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "AppDelegate.h"
#import "SFClipboardManager.h"
#import "SFWindowController.h"
#import <Carbon/Carbon.h>

@interface AppDelegate ()

@property (nonatomic, assign) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) SFClipboardManager *manager;
@property (nonatomic, retain, readonly) SFWindowController *windowController;

@property (nonatomic, assign, readwrite) EventHotKeyRef hotKey;
@property (nonatomic, retain, readwrite) id eventMonitor;

@end

@implementation AppDelegate

@synthesize manager = _manager;
@synthesize windowController = _windowController;

- (SFClipboardManager *)manager
{
	if (_manager == nil)
	{
		_manager = [[SFClipboardManager alloc] init];
	}
	return _manager;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	[NSApp hide:self];
}

- (SFWindowController *)windowController
{
	if (_windowController == nil)
	{
		_windowController = [[SFWindowController alloc] initWithWindowNibName:@"Window"];
		_windowController.manager = self.manager;
	}
	return _windowController;
}

- (void)registerShortcut
{
	EventHotKeyID hotKeyID;
	hotKeyID.signature = 'clip';
	hotKeyID.id = 'clip';
	
	EventHotKeyRef hotKey = NULL;
	RegisterEventHotKey(kVK_ANSI_V, optionKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKey);
	self.hotKey = hotKey;
}

- (void)unregisterShortcut
{
	UnregisterEventHotKey(self.hotKey);
	self.hotKey = nil;
}

- (BOOL)isShortcutRegistered
{
	return (self.hotKey != nil);
}

- (void)setupShortcut
{
	EventHandlerRef eventHandlerRef;
	EventTypeSpec hotKeyPressedSpec = { .eventClass = kEventClassKeyboard, .eventKind = kEventHotKeyPressed };
	InstallEventHandler(GetEventDispatcherTarget(), ASCarbonEventCallback, 1, &hotKeyPressedSpec, (__bridge void *)self, &eventHandlerRef);
	
	
	EventHandlerRef eventHandlerRefRel;
	EventTypeSpec hotKeyReleasedSpec = { .eventClass = kEventClassKeyboard, .eventKind = kEventHotKeyReleased };
	InstallEventHandler(GetEventDispatcherTarget(), ASCarbonEventCallbackRel, 1, &hotKeyReleasedSpec, (__bridge void *)self, &eventHandlerRefRel);
	
	[self registerShortcut];
}

static OSStatus ASCarbonEventCallback(EventHandlerCallRef _, EventRef event, void *context)
{
	AppDelegate *dispatcher = (__bridge id)context;
	if (!dispatcher.windowController.window.visible)
	{
		[dispatcher.windowController.window makeKeyAndOrderFront:nil];
	}
	else
	{
		[dispatcher.windowController moveDown:nil];
	}
	return noErr;
}

CGEventRef keyUpCallback (CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
	[((AppDelegate *)NSApp.delegate).windowController close];
	return event;
}

static OSStatus ASCarbonEventCallbackRel(EventHandlerCallRef _, EventRef event, void *context)
{
	CFMachPortRef keyUpEventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,kCGEventTapOptionListenOnly, CGEventMaskBit(kCGEventFlagsChanged), &keyUpCallback,NULL);
	
	CFRunLoopSourceRef keyUpRunLoopSourceRef = CFMachPortCreateRunLoopSource(NULL, keyUpEventTap, 0);
	CFRelease(keyUpEventTap);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), keyUpRunLoopSourceRef, kCFRunLoopDefaultMode);
	CFRelease(keyUpRunLoopSourceRef);
	return noErr;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self windowController];
	[self setupShortcut];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[self unregisterShortcut];
}

@end
