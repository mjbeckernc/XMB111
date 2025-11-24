%macro convertToUTF8(lib=, outlib=, logfile=);

  %if %superq(lib)= %then %do;
    %put ERROR: You must specify the input library (lib=);
    %return;
  %end;
  %if %superq(outlib)= %then %let outlib=&lib._utf8;
  %if %superq(logfile)= %then %let logfile=convert_utf8_log.txt;

  /* Create log to track conversions */
  filename convlog "&logfile";

  data _null_;
    file convlog;
    put "Conversion Log: " / "Date: %sysfunc(datetime(),datetime19.)" /;
  run;

    /* Loop through datasets in library */
  proc sql noprint;
    select memname into :dslist separated by ' '
    from dictionary.tables
    where libname = "%upcase(&lib)";
  quit;

  %let n=%sysfunc(countw(&dslist));

  %do i=1 %to &n;
    %let dsn=%scan(&dslist,&i);
    %let enc=;
    /* Retrieve encoding */
    proc sql noprint;
      select encoding into :enc trimmed
      from dictionary.tables
      where libname="%upcase(&lib)" and memname="%upcase(&dsn)";
    quit;

    %if "%upcase(&enc)" ne "UTF-8" %then %do;
      %put NOTE: Converting &lib..&dsn (encoding=&enc) to UTF-8...;
      data _null_;
        file convlog mod;
        put "Converting &lib..&dsn (encoding=&enc) to UTF-8";
      run;

      proc copy noclone in=&lib out=&outlib;
        select &dsn;
      run;
    %end;
    %else %do;
      %put NOTE: &lib..&dsn is already UTF-8, skipping.;
      data _null_;
        file convlog mod;
        put "Skipping &lib..&dsn (already UTF-8)";
      run;
    %end;
  %end;

    %put NOTE: Conversion complete! Log saved in &logfile.;

%mend convertToUTF8;