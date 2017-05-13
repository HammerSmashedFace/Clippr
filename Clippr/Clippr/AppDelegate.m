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
	hotKeyID.signature = 'apsl';
	hotKeyID.id = 'apsl';
	
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
	[self registerShortcut];
}

- (void)invalidateShortcut
{
	[self unregisterShortcut];
}

static OSStatus ASCarbonEventCallback(EventHandlerCallRef _, EventRef event, void *context)
{
	AppDelegate *dispatcher = (__bridge id)context;
	[dispatcher.windowController.window makeKeyAndOrderFront:nil];
	return noErr;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self windowController];
	[self setupShortcut];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}


@end
