//
//  StatusItemPopup.h
//  StatusItemPopup
//
//  Created by Alexander Schuch on 06/03/13.
//  Copyright (c) 2013 Alexander Schuch. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (canBecomeKeyWindow)

@end

@protocol AXStatusItemPopupDelegate <NSObject>

@optional

- (BOOL) shouldPopupOpen;
- (void) popupWillOpen;
- (void) popupDidOpen;

- (BOOL) shouldPopupClose;
- (void) popupWillClose;
- (void) popupDidClose;

@end

@interface AXStatusItemPopup : NSView <NSPopoverDelegate, NSWindowDelegate, NSApplicationDelegate>

// properties
@property(assign, nonatomic, getter=isAnimated) BOOL animated;
@property(strong, nonatomic) NSImage *image;
@property(strong, nonatomic) NSImage *alternateImage;
@property(weak) id<AXStatusItemPopupDelegate> delegate;


// alloc
+ (id)statusItemPopupWithViewController:(NSViewController *)controller;
+ (id)statusItemPopupWithViewController:(NSViewController *)controller image:(NSImage *)image;
+ (id)statusItemPopupWithViewController:(NSViewController *)controller image:(NSImage *)image alternateImage:(NSImage *)alternateImage;

// init
- (id)initWithViewController:(NSViewController *)controller;
- (id)initWithViewController:(NSViewController *)controller image:(NSImage *)image;
- (id)initWithViewController:(NSViewController *)controller image:(NSImage *)image alternateImage:(NSImage *)alternateImage;


// show / hide popover
- (void)togglePopover;
- (void)togglePopoverAnimated: (BOOL)animated;
- (void)showPopover;
- (void)showPopoverAnimated:(BOOL)animated;
- (void)hidePopover;

@end
