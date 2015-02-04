//
//  AppDelegate.m
//  obj-osx-demo
//
//  Created by Dominik Pich on 04/02/15.
//
//

#import "AppDelegate.h"
#import "QREncoder.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSImage *qrCode = [QREncoder imageForString:@"DEMODEMODEMO"];
    NSImageView *imageView = [[self.window.contentView subviews] firstObject];
    
    imageView.image = qrCode;
}

@end
