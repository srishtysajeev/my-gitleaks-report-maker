import sys
import pandas as pd
import json
from openpyxl import load_workbook
from openpyxl.worksheet.datavalidation import DataValidation

# When running the script the name of the json and the excel file must be given in as arguments
json_name = sys.argv[1]
excel_name = sys.argv[2]

print(f"Converting {json_name} to excel")

try:
    with open(json_name) as file:
        data = json.load(file)
    # Need to normalize to get correct headers
    df = pd.json_normalize(data)
    print(df)

except json.decoder.JSONDecodeError:
    print("JSON is empty — creating Excel file with only headers.")
    df = pd.DataFrame() 

# Convert any list-like fields to comma-separated strings
for col in df.columns:
    if df[col].apply(lambda x: isinstance(x, list)).any():
        df[col] = df[col].apply(lambda x: ", ".join(x) if isinstance(x, list) else x)

# Export to Excel
df.to_excel(excel_name, index=False)

# Load workbook
wb = load_workbook(excel_name)
ws = wb.active

# TODO:
# What if new fields are added in gitleaks?
# You should add a bit to automatically find the next empty column
# Add extra header fields 

ws["T1"] = "Leak Classification"
ws["U1"] = "Impact Assessment"
ws["V1"] = "Developer Comments"
ws["W1"] = "Mitigation Status"
ws["X1"] = "Security Team Comments"

# Dropdown definitions 
dv_q = DataValidation(type="list",
                      formula1='"Genuine,False Positive,Test,Other"',
                      allow_blank=True)

dv_r = DataValidation(type="list",
                      formula1='"Critical,Medium,Low,Informational"',
                      allow_blank=True)

dv_t = DataValidation(type="list",
                      formula1='"Action Taken,Not Applicable,Pending,Completed"',
                      allow_blank=True)

ws.add_data_validation(dv_q)
ws.add_data_validation(dv_r)
ws.add_data_validation(dv_t)

# Apply dropdowns only if rows exist 
max_row = ws.max_row
if max_row > 1:
    dv_q.add(f"Q2:Q{max_row}")
    dv_r.add(f"R2:R{max_row}")
    dv_t.add(f"T2:T{max_row}")

# Save final file
wb.save(excel_name)
