//
//  AppDelegate.h
//  envswitch
//
//  Created by Carlos Yaconi on 5/5/14.
//  Copyright (c) 2014 Prey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *save;
@property (assign) IBOutlet NSButton *cancel;
@property (assign) IBOutlet NSButton *bash;
@property (assign) IBOutlet NSButton *node;
@property (assign) IBOutlet NSTextField *urlProd;
@property (assign) IBOutlet NSTextField *urlStaging;
@property (assign) IBOutlet NSTextField *urlLocalhost;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
