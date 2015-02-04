A QR Code encoding library
--------------------------

This 'library' offers a C function that encodes data in a QR Code. The output is a binary stream representing the QR Code. 

It also includes a QREncoder Objective-C class that can be used in osx/ios to generate a NSImage/UIImage 

###How to use it in C
The main function is EncodeData and can be used as follows:

    int QR_width=EncodeData(level,version,inputdata,inputdata_length,outputdata_area);

If you set inputdata_length to 0 the function will determine the length from NULL termination of inputdata.

`QR_width` then contains the width of the code. So the function with writes `QR_width*QR_width` bits to the given `outputdata`.

1s represent black, 0s white. To use this data you'd iterate over it something like this:

    for(int y=0;y<QR_width;y++) {
        for(int x=0;x<QR_width;x++) {
            int value = get_next_bit();
            draw_pixel(x,y,value);
        }
    }

###How to work with the objective-C class 

The objC bindings define the class QREncoder which is cross-platform and also works with objc and swift. 

It defines methods for encoding NSStrings or NSData objects into a QR Code returned to you as image.

[obj] `NSImage *qrCode = [QREncoder imageForString:@"DEMODEMODEMO"];`<br/>
[swift] `let qrCode = QREncoder.imageForString("DEMODEMODEMO")`

######license
The code of the library and the three demos is provided under the terms of the BSD license.
