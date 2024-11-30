#!/bin/bash

start_year=24
start_month=11
end_year=25
end_month=12

year=$start_year
month=$start_month

while [ $year -lt $end_year ] || { [ $year -eq $end_year ] && [ $month -le $end_month ]; }; do
    formatted_month=$(printf "%02d" $month)
    dir_name="$year$formatted_month"
    mkdir -p "$dir_name"
    touch "$dir_name/$dir_name.md"
    
    month=$((month + 1))
    if [ $month -gt 12 ]; then
        month=1
        year=$((year + 1))
    fi
done
