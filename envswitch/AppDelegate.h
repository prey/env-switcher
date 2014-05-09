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

-(void) drawIconForEnv: (NSString*) env;

@end
