/* Example: convert input library to UTF-8 in new output library */
libname sdtm '/nfsshare/sashls2/mattb/XMB111/data/SDTM';
libname rawUTF8 '/nfsshare/sashls2/mattb/XMB111/data/RawUTF8' outencoding=utf8;

%include '/nfsshare/sashls2/mattb/XMB111/macros/convertToUTF8.sas';

%convertToUTF8(lib=sdtm, outlib=rawUTF8, logfile=/nfsshare/sashls2/mattb/XMB111/data/RawUTF8/utf8_conversion.txt);
