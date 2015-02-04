//
//  QREncoder.h
//  Created by Dominik Pich on 03/02/15.
//

#import <TargetConditionals.h>

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define DDImage UIImage
#define DDColor UIColor

#define DDScreenRect [UIScreen mainScreen].bounds
#define DDScreenScale [UIScreen mainScreen].scale
#else
#import <Cocoa/Cocoa.h>
#define DDImage NSImage
#define DDColor NSColor

#define DDScreenRect [NSScreen mainScreen].frame
#define DDScreenScale [NSScreen mainScreen].backingScaleFactor
#endif

// Error correction level
typedef NS_ENUM(NSUInteger, QRCodeErrorCorrectionLevel) {
    QRCodeErrorCorrectionLevelL=0,
    QRCodeErrorCorrectionLevelM=1,
    QRCodeErrorCorrectionLevelQ=2,
    QRCodeErrorCorrectionLevelH=3
};

//model :: http://www.qrcode.com/en/about/version.html
typedef NS_ENUM(NSUInteger, QRCodeModel) {
    QRCodeModel1=1,
    QRCodeModel2=2,
    QRCodeModel3=3,
    QRCodeModelAuto=0 //as low a model as possible, can go beyond 3 if needed
};

@interface QREncoder : NSObject

+ (DDImage*)imageForString:(NSString*)string; //must be UTF-8 (still binary encoding is assumed (!) - defaults to error correction L and Model Auto, the qr code is sized to fit the screen (the exact size is a multiple of the qr code size)


+ (DDImage*)imageForString:(NSString*)string //must be UTF-8 (still binary encoding is assumed (!))
           errorCorrection:(QRCodeErrorCorrectionLevel)eec
                     model:(QRCodeModel)model //can be more than the 3 defined levels. define an integer to make the QR as big as you like (it isnt specified to be though!)
           approximateSize:(NSUInteger)approximateSize; //the exact size is a multiple of the qr code size but never smaller than the code

//-

+ (DDImage*)imageForData:(NSData*)data; //(binary encoding is assumed (!)) - defaults to error correction L and Model Auto, the qr code is sized to fit the screen (the exact size is a multiple of the qr code size)

+ (DDImage*)imageForData:(NSData*)data //(binary encoding is assumed (!))
         errorCorrection:(QRCodeErrorCorrectionLevel)eec
                   model:(QRCodeModel)model //can be more than the 3 defined levels. define an integer to make the QR as big as you like (it isnt specified to be though!)
         approximateSize:(NSUInteger)approximateSize; //the exact size is a multiple of the qr code size but never smaller than the code

@end