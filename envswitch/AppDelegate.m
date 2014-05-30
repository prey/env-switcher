//
//  AppDelegate.m
//  envswitch
//
//  Created by Carlos Yaconi on 5/5/14.
//  Copyright (c) 2014 Prey. All rights reserved.
//

#import "AppDelegate.h"
#import "EnvSwitcherViewController.h"
#import "AXStatusItemPopup.h"

@interface AppDelegate () {
    AXStatusItemPopup *_statusItemPopup;
}

@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    EnvSwitcherViewController *envSwitcherViewController = [[EnvSwitcherViewController alloc] initWithNibName:@"EnvSwitcherViewController" bundle:nil];
    
    [self drawIconForEnv:nil];
    NSImage *image = [NSImage imageNamed:[[NSUserDefaults standardUserDefaults] stringForKey:@"icon"]];
    NSImage *alternateImage = [NSImage imageNamed:[[NSUserDefaults standardUserDefaults] stringForKey:@"iconH"]];
    
    _statusItemPopup = [[AXStatusItemPopup alloc] initWithViewController:envSwitcherViewController image:image alternateImage:alternateImage];
    [self.window close];
}


-(void) drawIconForEnv: (NSString*) env
{
    if (env != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:env forKey:@"icon"];
        [[NSUserDefaults standardUserDefaults] setObject:[env stringByAppendingString:@"H"] forKey:@"iconH"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _statusItemPopup.image = [NSImage imageNamed:[[NSUserDefaults standardUserDefaults] stringForKey:@"icon"]];
    _statusItemPopup.alternateImage = [NSImage imageNamed:[[NSUserDefaults standardUserDefaults] stringForKey:@"iconH"]];
}


@end
