//
//  MainViewController.m
//  envswitch
//
//  Created by Carlos Yaconi on 5/7/14.
//  Copyright (c) 2014 Prey. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

int const prod=1;
int const staging=2;
int const localhost=3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}



- (void)loadDefaults
{
    NSURL *defaultPrefsFile = [[NSBundle mainBundle]
                               URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs =
    [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
     
    
    [self.bash setState:[[[NSUserDefaults standardUserDefaults] objectForKey:@"bash"] boolValue]];
    [self.node setState:[[[NSUserDefaults standardUserDefaults] objectForKey:@"node"] boolValue]];
    
    [self.urlProd setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"urlProd"]];
    [self.apiProd setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"apiProd"]];
    [self.devProd setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"devProd"]];
    [self.httpsProd setState:[[[NSUserDefaults standardUserDefaults] objectForKey:@"httpsProd"] boolValue]];
    
    [self.urlStaging setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"urlStaging"]];
    [self.apiStaging setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"apiStaging"]];
    [self.devStaging setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"devStaging"]];
    [self.httpsStaging setState:[[[NSUserDefaults standardUserDefaults] objectForKey:@"httpsStaging"] boolValue]];
    
    [self.urlLocalhost setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"urlLocalhost"]];
    [self.apiLocalhost setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"apiLocalhost"]];
    [self.devLocalhost setStringValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"devLocalhost"]];
    [self.httpsLocalhost setState:[[[NSUserDefaults standardUserDefaults] objectForKey:@"httpsLocalhost"] boolValue]];
    
    [self.urlProd resignFirstResponder];
    
}

- (IBAction)exitApp:(NSButton*)sender {
    [NSApp terminate:self];
}

- (void)willClose
{
    [[NSUserDefaults standardUserDefaults] setObject:[self.urlProd stringValue] forKey:@"urlProd"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.apiProd stringValue] forKey:@"apiProd"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.devProd stringValue] forKey:@"devProd"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[self.httpsProd state]== NSOnState] forKey:@"httpsProd"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[self.urlStaging stringValue] forKey:@"urlStaging"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.apiStaging stringValue] forKey:@"apiStaging"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.devStaging stringValue] forKey:@"devStaging"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[self.httpsStaging state]== NSOnState] forKey:@"httpsStaging"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[self.urlLocalhost stringValue] forKey:@"urlLocalhost"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.apiLocalhost stringValue] forKey:@"apiLocalhost"];
    [[NSUserDefaults standardUserDefaults] setObject:[self.devLocalhost stringValue] forKey:@"devLocalhost"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[self.httpsLocalhost state]== NSOnState] forKey:@"httpsLocalhost"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[self.bash state]== NSOnState] forKey:@"bash"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[self.node state]== NSOnState] forKey:@"node"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)applyProduction:(id)sender
{
    [self performUpdateWithEnv:prod];
    [(AppDelegate *)[[NSApplication sharedApplication] delegate] drawIconForEnv:@"production"];
}
- (IBAction)applyStaging:(id)sender
{
    [self performUpdateWithEnv:staging];
    [(AppDelegate *)[[NSApplication sharedApplication] delegate] drawIconForEnv:@"staging"];
}
- (IBAction)applyLocalhost:(id)sender
{
    [self performUpdateWithEnv:localhost];
    [(AppDelegate *)[[NSApplication sharedApplication] delegate] drawIconForEnv:@"localhost"];
}

- (IBAction)selectProduction:(id)sender {
    [self.envTabs selectTabViewItemWithIdentifier:@"production"];
}

- (IBAction)selectStaging:(id)sender {
    [self.envTabs selectTabViewItemWithIdentifier:@"staging"];
}

- (IBAction)selectLocalhost:(id)sender {
    [self.envTabs selectTabViewItemWithIdentifier:@"localhost"];
}


-(void)performUpdateWithEnv: (int) env
{
    NSString *protocol = @"http";
    NSString *url;
    NSString *apiKey=nil;
    NSString *deviceKey=nil;

    switch (env) {
        case prod:
            if ([self.httpsProd state] == NSOnState)
                protocol = @"https";
            url = [self.urlProd stringValue];
            apiKey = [self.apiProd stringValue];
            deviceKey = [self.devProd stringValue];
            break;
            
        case staging:
            if ([self.httpsStaging state] == NSOnState)
                protocol = @"https";
            url = [self.urlStaging stringValue];
            apiKey = [self.apiStaging stringValue];
            deviceKey = [self.devStaging stringValue];
            break;
            
        case localhost:
            if ([self.httpsLocalhost state] == NSOnState)
                protocol = @"https";
            url = [self.urlLocalhost stringValue];
            apiKey = [self.apiLocalhost stringValue];
            deviceKey = [self.devLocalhost stringValue];
            break;
            
        default:
            break;
    }
    [self updateConfigWithUrl:url andProtocol:protocol andApikey:apiKey andDeviceKey:deviceKey];
    

    
}

- (void) updateConfigWithUrl: (NSString*) url andProtocol: (NSString*) protocol andApikey: (NSString*) apiKey andDeviceKey: (NSString*) deviceKey
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
            
            [self replaceInText:bashConfig usingRegexExp:@"check_url=.*" withText: [NSString stringWithFormat: @"check_url='%@://%@'", protocol, url]];
            if (apiKey != nil)
                [self replaceInText:bashConfig usingRegexExp:@"api_key=.*" withText: [NSString stringWithFormat: @"api_key='%@'", apiKey]];
            if (deviceKey != nil)
                [self replaceInText:bashConfig usingRegexExp:@"device_key=.*" withText: [NSString stringWithFormat: @"device_key='%@'", deviceKey]];
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
            [self replaceInText:nodeConfig usingRegexExp:@"host = .*" withText: [NSString stringWithFormat: @"host = %@", url]];
            [self replaceInText:nodeConfig usingRegexExp:@"protocol = .*" withText: [NSString stringWithFormat: @"protocol = %@", protocol]];
            if (apiKey != nil)
                [self replaceInText:nodeConfig usingRegexExp:@"api_key = .*" withText: [NSString stringWithFormat: @"api_key = '%@'", apiKey]];
            if (deviceKey != nil){
                if (![deviceKey isEqualToString:@""]) deviceKey = [NSString stringWithFormat: @"'%@'", deviceKey];
                [self replaceInText:nodeConfig usingRegexExp:@"device_key = .*" withText: [NSString stringWithFormat: @"device_key = %@", deviceKey]];
            }
            [nodeConfig writeToFile:nodeTmpPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            [cmd appendFormat:@"mv %@ %@; chown prey %@", nodeTmpPath, nodeConfigPath, nodeConfigPath];
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

- (void)rightMouseUp:(NSEvent *)event {
    
    NSMenu* theMenu;
    theMenu = [[NSMenu alloc] initWithTitle:@""];
    [theMenu setAutoenablesItems:NO];
    NSMenuItem *quitItem = nil;
    quitItem = [theMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    [quitItem setKeyEquivalentModifierMask:NSCommandKeyMask];
    [theMenu popUpMenuPositioningItem:quitItem atLocation:[NSEvent mouseLocation] inView:nil];
}


@end
