//
//  SassPlugin.h
//  SassPlugin
//
//  Created by Stuart Miller on 12/01/2013.
//  Copyright (c) 2013 Stuart Miller. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CodaPlugInsController.h"
#import "MainWindow.h"

@class CodaPlugInsController;

@interface SassPlugin : NSObject <CodaPlugIn>
{
	CodaPlugInsController* controller;
}

@property MainWindow *mainWindow;
@property NSURL *sassFile, *cssFile;
@property NSPipe *sassOutput;
@property NSFileHandle *readHandle;

@end
