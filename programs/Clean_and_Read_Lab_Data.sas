TITLE;

FILENAME REFFILE DISK '/nfsshare/sashls2/mattb/XMB111/data/LabExtract.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX REPLACE
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

TITLE "Columns Exaclty as in Import FIle";
PROC CONTENTS DATA=WORK.IMPORT VARNUM ; 
ODS SELECT ATTRIBUTES position;
RUN;


proc python;
submit;

import pandas as pd

def update_column_names(input_file, output_file):
    # Read the Excel file
    df = pd.read_excel(input_file)

    # Update column names
    new_columns = []
    for column in df.columns:
        # Find the index of the first ":"
        index_of_colon = column.find(":")
        if index_of_colon != -1:
            # Find the index of the next ";"
            index_of_semicolon = column.find(";", index_of_colon)
            if index_of_semicolon != -1:
                new_column_name = column[index_of_colon + 1:index_of_semicolon].strip()
            else:
                new_column_name = column[index_of_colon + 1:].strip()
            
            new_columns.append(new_column_name)
        else:
            new_columns.append(column)

    # Update column names in the DataFrame
    df.columns = new_columns

    # Save the modified DataFrame to a new Excel file
    df.to_excel(output_file, index=False)


update_column_names('/nfsshare/sashls2/mattb/XMB111/data/LabExtract.xlsx', '/nfsshare/sashls2/mattb/XMB111/data/LabExtract_Clean.xlsx')

endsubmit;
run;


TITLE "Columns after Python Code Execution";
FILENAME REFFILE DISK '/nfsshare/sashls2/mattb/XMB111/data/LabExtract_Clean.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX REPLACE
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT VARNUM; ODS SELECT ATTRIBUTES position; RUN;

TITLE;

