//
//  MainViewController.h
//  envswitch
//
//  Created by Carlos Yaconi on 5/7/14.
//  Copyright (c) 2014 Prey. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "AXStatusItemPopup.h"

@interface EnvSwitcherViewController : NSViewController <NSTabViewDelegate>

@property(weak, nonatomic) AXStatusItemPopup *statusItemPopup;

@property (assign) IBOutlet WebView *webView;
@property (weak) IBOutlet NSTabView *envTabs;

@property (assign) IBOutlet NSButton *bash;
@property (assign) IBOutlet NSButton *node;

@property (assign) IBOutlet NSTextField *urlProd;
@property (assign) IBOutlet NSTextField *apiProd;
@property (assign) IBOutlet NSTextField *devProd;
@property (assign) IBOutlet NSButton *httpsProd;

@property (assign) IBOutlet NSTextField *urlStaging;
@property (assign) IBOutlet NSTextField *apiStaging;
@property (assign) IBOutlet NSTextField *devStaging;
@property (assign) IBOutlet NSButton *httpsStaging;

@property (assign) IBOutlet NSTextField *urlLocalhost;
@property (assign) IBOutlet NSTextField *apiLocalhost;
@property (assign) IBOutlet NSTextField *devLocalhost;
@property (assign) IBOutlet NSButton *httpsLocalhost;
@property (weak) IBOutlet NSButton *hostsCheck;

- (IBAction)applyProduction:(id)sender;
- (IBAction)applyStaging:(id)sender;
- (IBAction)applyLocalhost:(id)sender;

- (IBAction)selectProduction:(id)sender;
- (IBAction)selectStaging:(id)sender;
- (IBAction)selectLocalhost:(id)sender;
- (IBAction)hostsClicked:(NSButton *)sender;

@end
