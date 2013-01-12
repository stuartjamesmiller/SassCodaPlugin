//
//  SassPlugin.m
//  SassPlugin
//
//  Created by Stuart Miller on 12/01/2013.
//  Copyright (c) 2013 Stuart Miller. All rights reserved.
//

#import "SassPlugin.h"

@implementation SassPlugin

@synthesize mainWindow, sassFile, cssFile, sassOutput, readHandle;

//2.0.1 and higher
- (id)initWithPlugInController:(CodaPlugInsController*)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle
{
    return [self initWithController:aController];
}

- (id)initWithController:(CodaPlugInsController*)inController
{
	if ( (self = [super init]) != nil )
	{
		controller = inController;
		[controller registerActionWithTitle:NSLocalizedString(@"Sass Plugin", @"Sass Plugin") target:self selector:@selector(runSassPlugin:)];
	}
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector( readPipe: )
                                                 name:NSFileHandleReadCompletionNotification
                                               object:nil];
    
	return self;
}

- (void)runSassPlugin:(id)sender
{
    [self selectFiles];

    self.mainWindow = [[MainWindow alloc] initWithWindowNibName:@"MainWindow"];
    [self.mainWindow showWindow:self];
}

- (NSString*)name
{
	return @"Sass Plugin";
}

- (void)selectFiles
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    if ([openDlg runModal] == NSFileHandlingPanelOKButton){
       self.sassFile = [openDlg URL];
    }
    
    if ([openDlg runModal] == NSFileHandlingPanelOKButton){
        self.cssFile = [openDlg URL];
    }

    [self startSass];    
}

- (void)startSass
{
    NSString *sassApp = [NSString stringWithFormat:@"/usr/bin/sass"];
    NSString *watchFiles = [NSString stringWithFormat:@"%@:%@", [self.sassFile path], [self.cssFile path]];

    NSArray *args = [NSArray arrayWithObjects: [NSString stringWithFormat:@"--trace"], [NSString stringWithFormat:@"--watch"], watchFiles, nil];
    
    NSTask *sassTask = [[NSTask alloc] init];
    [sassTask setLaunchPath:sassApp];
    [sassTask setArguments:args];
    
    self.sassOutput = [NSPipe pipe];
    [sassTask setStandardOutput:self.sassOutput];

    self.readHandle = [self.sassOutput fileHandleForReading];
    [self.readHandle readInBackgroundAndNotify];
        
    [sassTask launch];
}

- (void)readPipe: (NSNotification *)notification
{
    NSData *data;
    NSString *text;
    
    if( [notification object] != self.readHandle )
        return;
    
    data = [[notification userInfo]
            objectForKey:NSFileHandleNotificationDataItem];
    text = [[NSString alloc] initWithData:data
                                 encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@", text);
    
    [self.mainWindow.sassNotification setStringValue:text];
    [self.readHandle readInBackgroundAndNotify];
}

@end
