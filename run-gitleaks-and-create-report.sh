#! /bin/bash

# Venv for running a python file - not needed in containerised env
# source ./venv/bin/activate

convert_to_excel(){
    python /apps/create-excel-from-JSON.py "$1" "$2"
}

the_date=$(date '+%d-%m-%Y')

# TODO: currently your script just gets rid of the old json files - but wajid wants you to keep a record of them


# The repo name should be passed in as an argument
run_gitleaks(){
  # Check if gitleaks is installed
  if ! command -v gitleaks; then
    echo "TERMINATING - gitleaks binary not found"
    exit
  fi

  # If report does not exist: 
  if [ ! -e /data/${1}/gitleaks-report.json ]; then
    echo "[INFO] Report does not exist"
    gitleaks git --report-path /data/${1}/gitleaks-report.json # This will save the report in a file called gitleaks-report.json
    
    # condition if there are no leaks 
    if [ "$(jq length /data/${1}/gitleaks-report.json)" -eq 0 ]; then
      echo "[INFO] Entering 0 length json zone"
      convert_to_excel "/data/${1}/gitleaks-report.json" "/data/${1}/report_${the_date}_NO-LEAKS.xlsx"
    else
      echo "[INFO] Leaks are present"
      convert_to_excel "/data/${1}/gitleaks-report.json" "/data/${1}/report_${the_date}.xlsx" 
    fi

  # If the report already exists
  else 
    echo "[INFO] Report already exists"
    # Run gitleaks but with a baseline
    gitleaks git --baseline-path /data/${1}/gitleaks-report.json --report-path /data/${1}/gitleaks-new-findings.json
    
    # If there are no NEW leaks - reflect in the file name
    if [ "$(jq length /data/${1}/gitleaks-new-findings.json)" -eq 0 ]; then
      echo "[INFO] Entering 0 length json zone"
      convert_to_excel "/data/${1}/gitleaks-new-findings.json" "/data/${1}/new-findings-report_${the_date}_NO-LEAKS.xlsx"
      echo "[INFO] Leaks are present"
      convert_to_excel "/data/${1}/gitleaks-new-findings.json" "/data/${1}/new-findings-report_${the_date}.xlsx" 
    fi

    gitleaks git --report-path /data/${1}/gitleaks-report.json # make a new baseline for the next time around
  fi
}

