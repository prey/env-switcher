//
//  AppDelegate.m
//  envswitch
//
//  Created by Carlos Yaconi on 5/5/14.
//  Copyright (c) 2014 Prey. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

NSStatusItem *statusItem;
NSMenu *theMenu;
int x;
int y;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [self.window close];
    [self loadDefaults];
    [self createMenu];

}

- (void) createMenu
{
    theMenu = [[NSMenu alloc] initWithTitle:@""];
    [theMenu setAutoenablesItems:NO];
    
    NSMenuItem *prodItem = nil;
    prodItem = [theMenu addItemWithTitle:@"Production" action:@selector(handleProduction:) keyEquivalent:@"p"];
    [prodItem setKeyEquivalentModifierMask:NSCommandKeyMask];
    NSMenuItem *stagingItem = nil;
    stagingItem = [theMenu addItemWithTitle:@"Staging" action:@selector(handleStaging:) keyEquivalent:@"s"];
    [stagingItem setKeyEquivalentModifierMask:NSCommandKeyMask];
    [theMenu addItem:[NSMenuItem separatorItem]];
    NSMenuItem *prefItem = nil;
    prefItem = [theMenu addItemWithTitle:@"Preferences..." action:@selector(handlePreferences:) keyEquivalent:@","];
    [prefItem setKeyEquivalentModifierMask:NSCommandKeyMask];
    [theMenu addItem:[NSMenuItem separatorItem]];
    NSMenuItem *quitItem = nil;
    quitItem = [theMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    [quitItem setKeyEquivalentModifierMask:NSCommandKeyMask];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setImage:[NSImage imageNamed:@"icon.png"]];
    [statusItem setToolTip:@"Prey environment switcher"];
    [statusItem setHighlightMode:YES];
    [statusItem setEnabled:YES];
    [statusItem setMenu:theMenu];

}

-(void) loadDefaults
{
    NSURL *defaultPrefsFile = [[NSBundle mainBundle]
                               URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs =
    [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    
    [self.bash setState:[[[NSUserDefaults standardUserDefaults] objectForKey:@"bash"] boolValue]];
    [self.node setState:[[[NSUserDefaults standardUserDefaults] objectForKey:@"node"] boolValue]];
    [self.urlProd setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"urlProd"]];
    [self.urlStaging setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"urlStaging"]];
}

-(void)handleProduction:(id) sender
{
    [self modifyCheckUrlWith:[self.urlProd stringValue]];
}

-(void)handleStaging:(id) sender
{
    [self modifyCheckUrlWith:[self.urlStaging stringValue]];
}

-(void)handlePreferences:(id) sender
{
    [self.window makeKeyAndOrderFront:NSApp];
    [NSApp activateIgnoringOtherApps:YES];
}

-(void)modifyCheckUrlWith: (NSString*) newUrl
{
    NSError * error;
    
    NSString * bashConfigPath = @"/usr/share/prey/config";
    NSString * nodeConfigPath = @"/etc/prey/prey.conf";
    NSString * bashTmpPath = @"/tmp/config";
    NSString * nodeTmpPath = @"/tmp/prey.conf";
    NSMutableString * cmd = [NSMutableString stringWithCapacity:100];
    
    if ([self.bash state] == NSOnState){
        NSString *stringBashConfig = [[NSString alloc] initWithContentsOfFile:bashConfigPath
                                                                     encoding:NSUTF8StringEncoding
                                                                        error:&error];
        if (stringBashConfig != nil)
        {
            NSMutableString *bashConfig = [NSMutableString stringWithCapacity:[stringBashConfig length]];
            [bashConfig appendString:stringBashConfig];
            [self replaceInText:bashConfig usingRegexExp:@"check_url=.*" withText: [NSString stringWithFormat: @"check_url='https://%@'", newUrl]];
            [bashConfig writeToFile:bashTmpPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            [cmd appendFormat:@"mv %@ %@;", bashTmpPath, bashConfigPath];
        }
    }
    if ([self.node state] == NSOnState){
        
        NSString *stringNodeConfig = [[NSString alloc] initWithContentsOfFile:nodeConfigPath
                                                                     encoding:NSUTF8StringEncoding
                                                                        error:&error];
        if (stringNodeConfig != nil)
        {
            NSMutableString *nodeConfig = [NSMutableString stringWithCapacity:[stringNodeConfig length]];
            [nodeConfig appendString:stringNodeConfig];
            [self replaceInText:nodeConfig usingRegexExp:@"host = .*" withText: [NSString stringWithFormat: @"host = %@", newUrl]];
            [nodeConfig writeToFile:nodeTmpPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            [cmd appendFormat:@"mv %@ %@", nodeTmpPath, nodeConfigPath];
        }
    }
    
    if (cmd.length > 0)
    {
        error = nil;
        NSDictionary *errorDict = [NSDictionary new];
        NSString *script = [NSString stringWithFormat: @"do shell script \"%@\" with administrator privileges", cmd];
        NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
        [appleScript executeAndReturnError:&errorDict];
        if (error != nil)
            NSLog(@"%@", [error userInfo]);
    }

}

- (void) replaceInText: (NSMutableString*) text usingRegexExp: (NSString*) regexp withText: (NSString*) newText
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexp options:NSRegularExpressionCaseInsensitive error:&error];
    [regex replaceMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:newText];
}

- (IBAction)save:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[self.urlProd stringValue] forKey:@"urlProd"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.urlStaging stringValue] forKey:@"urlStaging"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[self.bash state]== NSOnState] forKey:@"bash"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[self.node state]== NSOnState] forKey:@"node"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.window close];
}

- (IBAction)cancel:(id)sender {
    [self loadDefaults];
    [self.window close];
}
@end
