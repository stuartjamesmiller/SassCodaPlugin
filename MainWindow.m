//
//  MainWindow.m
//  SassPlugin
//
//  Created by Stuart Miller on 12/01/2013.
//  Copyright (c) 2013 Stuart Miller. All rights reserved.
//

#import "MainWindow.h"

@interface MainWindow ()

@end

@implementation MainWindow

@synthesize sassNotification;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
