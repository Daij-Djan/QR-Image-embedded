#include "QR_Encode.h"
#include <stdio.h>
#include <wchar.h>
#include <locale.h>

int main(int argc, char *argv[])
{
  setlocale(LC_ALL, "");
  if (argc<2) {
    wprintf(L"qrencode <input string> [QR Code level] [QR Code version] [output file]\n");
    wprintf(L"level and version default to 3 and 0, the output file defaults to NONE \n");
    return 1;
  }

  int level=3;
  if(argc>2) {
    level = atoi(argv[2]);
  }

  int version=0;
  if(argc>3) {
    version = atoi(argv[3]);
  }

  // **** This calls the library and encodes the data
  // *** length is taken from NULL termination, however can also be passed by parameter.
  BYTE QR_m_data[3917]; //max possible bits resolution 177*177/8+1
  int QR_width=EncodeData(level,version,argv[1],0,QR_m_data);
  int size=((QR_width*QR_width)/8)+(((QR_width*QR_width)%8)?1:0);

  // Write the data to the output file
  if(argc>4) {
    FILE *f=fopen(argv[4],"w");
    wprintf(L"\nwriting file %i bytes size \n",size);
    fwrite(QR_m_data,size,1,f);
    fclose(f);
  }
    
  // This code dumps the QR code to the screen as ASCII.
  wprintf(L"QR Code width: %u\n",QR_width);
  
  int bit_count=0;
  wprintf(L"%i",size);
  int n;
  for(n=0;n<size;n++) {
    int b=0;
    for(b=7;b>=0;b--) {
      
      if((bit_count%QR_width) == 0) wprintf(L"\n");
      if (((n+1)*8)-b>QR_width*QR_width){break;}
      if((QR_m_data[n] & (1 << b)) != 0) {wprintf(L"x");wprintf(L"x"); }
                                    else {wprintf(L" ");wprintf(L" "); }
      bit_count++;
    }
  }
  //wprintf(L"\n");
  return 0;
}
