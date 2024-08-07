#!/bin/bash

for dir in */; do
    folder="${dir%/}"
    yaml_file="$folder/$folder.yaml"
    if [ -f "$yaml_file" ]; then
        cpu=$(grep -oE 'cpu: "[0-9]+[a-zA-Z]*"' "$yaml_file" | cut -d'"' -f2 | grep -oP [0-9]+)
        memory=$(grep -oE 'memory: "[0-9]+[a-zA-Z]*"' "$yaml_file" | cut -d'"' -f2 | grep -oP [0-9]+)

        cpu_limit=$(echo "scale=0; $cpu*1.5/1" | bc -l)
        memory_limit=$(echo "scale=0; $memory*1.5/1" | bc -l)
        sed -i "/memory:/a \          limits:\n            cpu: \"${cpu_limit}m\"\n            memory: \"${memory_limit}Mi\"" "$yaml_file"
    fi
done
