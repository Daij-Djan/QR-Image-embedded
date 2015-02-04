//
//  QREncoder.m
//  Created by Dominik Pich on 03/02/15.
//
#import "QREncoder.h"
#include "QR_Encode.h"

@implementation QREncoder

+ (DDImage*)imageForString:(NSString*)string {
    CGSize size = DDScreenRect.size;
    CGFloat scale = DDScreenScale;
    double x = size.width * scale;
    double y = size.height * scale;
    
    return [self imageForString:string
                errorCorrection:QRCodeErrorCorrectionLevelL
                          model:QRCodeModelAuto
                approximateSize:MIN(x,y)];
}

+ (DDImage*)imageForString:(NSString*)string
           errorCorrection:(QRCodeErrorCorrectionLevel)eec
                     model:(QRCodeModel)model
           approximateSize:(NSUInteger)approximateSize {
    const void *bytes = string.UTF8String;
    
    // **** This calls the library and encodes the data
    BYTE QR_m_data[3917]; //max possible bits resolution 177*177/8+1
    int qrWidth=EncodeData(eec, model, bytes, 0, QR_m_data);
    if(qrWidth <= 0)
        return nil;
    
    CGFloat scale = MAX(ceil(approximateSize / qrWidth), 1);
    CGFloat pixelSize = qrWidth * scale;
    
    return [self createImageFromQRCodeData:QR_m_data
                                QRCodeWith:qrWidth
                                 pixelSize:pixelSize];
}

//-

+ (DDImage*)imageForData:(NSData*)data {
    CGSize size = DDScreenRect.size;
    CGFloat scale = DDScreenScale;
    double x = size.width * scale;
    double y = size.height * scale;
    
    return [self imageForData:data
              errorCorrection:QRCodeErrorCorrectionLevelL
                        model:QRCodeModelAuto
              approximateSize:MIN(x,y)];
}

+ (DDImage*)imageForData:(NSData*)data
         errorCorrection:(QRCodeErrorCorrectionLevel)eec
                   model:(QRCodeModel)model
         approximateSize:(NSUInteger)approximateSize {
    const void *bytes = data.bytes;
    NSUInteger length = data.length;
    
    // **** This calls the library and encodes the data
    BYTE QR_m_data[3917]; //max possible bits resolution 177*177/8+1
    int qrWidth=EncodeData(eec, model, bytes, (int)length, QR_m_data);
    if(qrWidth <= 0)
        return nil;
    
    CGFloat scale = MAX(ceil(approximateSize / qrWidth), 1);
    CGFloat pixelSize = qrWidth * scale;
    
    return [self createImageFromQRCodeData:QR_m_data
                                QRCodeWith:qrWidth
                                 pixelSize:pixelSize];
}

//-

+ (DDImage*)createImageFromQRCodeData:(BYTE*)qrData
                           QRCodeWith:(int)qrWidth
                      pixelSize:(NSUInteger)pixelSize {
    NSUInteger scale = pixelSize / qrWidth;
    CGRect rect = CGRectMake(0, 0, scale, scale);
    CGRect imgRect = CGRectMake(0, 0, pixelSize, pixelSize);
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    UIGraphicsBeginImageContext(imgRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
#else
    NSImage *image = [[NSImage alloc] initWithSize:imgRect.size];
    
    //just locking onto this WORKS but calling the graphicsContext's new CGContext method on the context then, gives an error: -[NSSnapshotBitmapGraphicsContext CGContext]: unrecognized selector sent to instance 0x600000092c00
    //so we use the port property. it is deprecated but works ;)
    [image lockFocus];
    CGContextRef context = [NSGraphicsContext currentContext].graphicsPort;

    CGContextTranslateCTM(context, 0.0, imgRect.size.height);
    CGContextScaleCTM(context, 1.0, - 1.0);
#endif
    
    CGContextSetFillColorWithColor(context, [DDColor whiteColor].CGColor);
    CGContextFillRect(context, imgRect);
    CGContextSetFillColorWithColor(context, [DDColor blackColor].CGColor);

    int size=((qrWidth*qrWidth)/8)+(((qrWidth*qrWidth)%8)?1:0);
    int bit_count=0;
    for(int n=0;n<size;n++) {
        int b=0;
        for(b=7;b>=0;b--) {
            //move to next row if needed
            if(bit_count && (bit_count % qrWidth) == 0) {
                rect.origin.x = 0;
                rect.origin.y += scale;
            }
           
            //exit if we are done
            if (((n+1)*8)-b > (qrWidth * qrWidth)) {
                break;
            }

            //read the bit
            BOOL bitIsSet = (qrData[n] & (1 << b)) != 0;
            bit_count++;
            
            //draw the block if needed
            if(bitIsSet) {
                CGContextFillRect(context, rect);
            }
            
            //progress in row
            rect.origin.x += scale;
        }
    }
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    DDImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#else
    [image unlockFocus];
#endif
    return image;
}

@end