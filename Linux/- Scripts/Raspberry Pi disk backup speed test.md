# Disk backup with ZSTD over network on Raspberry PI test
created: 2025-03-01 13:05
tags: #linux #automation #script #todo 
Terminology, general knowledge
---


Prerequisites
---


Sources
---


Code
---

**THIS SCRIPT CURRENTLY DOES NOT WORK, DON'T RUN IT, IT WILL JUST WASTER YOUR TIME WITHOUT RETURNING ANYTHING USEFUL**

```bash
#!/bin/bash

# Output CSV file. The header is: compression_level;timestamp;copied_bytes;time_taken;speed_mb
CSV_FILE="results.csv"
echo "compression_level;timestamp;copied_bytes;time_taken;speed_mb" > "$CSV_FILE"

# Define an array of compression levels to test, including negative levels.
levels=(-7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9)

for level in "${levels[@]}"; do
    # Record the current timestamp for the test.
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$TIMESTAMP] Running test with compression level $level..."

    # Run the command with a timeout of 120 seconds.
    # Using the long option --compression-level so negative levels are accepted.
    OUTPUT=$(timeout 120s bash -c "sudo dd conv=noerror,sync if=/dev/mmcblk0 bs=4M | zstd --compression-level=$level -T0 | ssh krissssz@192.168.0.150 'dd of=/home/krissssz/diskimage.img.zst'" 2>&1)
    
    # Example dd output: "2822766592 bytes (2.8 GB, 2.6 GiB) copied, 120.673 s, 23.4 MB/s"
    COPIED_BYTES=$(echo "$OUTPUT" | grep -oP '^\s*\d+(?= bytes)')
    TIME_TAKEN=$(echo "$OUTPUT" | grep -oP '(?<=copied, )\d+\.\d+(?= s)')
    SPEED_MB=$(echo "$OUTPUT" | grep -oP '(?<=, )\d+\.\d+(?= MB/s)')
    
    # If any of the expected values are missing, log a warning and mark the result as unavailable.
    if [[ -z "$COPIED_BYTES" || -z "$TIME_TAKEN" || -z "$SPEED_MB" ]]; then
        echo "Warning: Could not parse output for compression level $level." >&2
        echo "$level;$TIMESTAMP;NA;NA;NA" >> "$CSV_FILE"
        continue
    fi

    # Append the parsed results along with the compression level and timestamp to the CSV.
    echo "$level;$TIMESTAMP;$COPIED_BYTES;$TIME_TAKEN;$SPEED_MB" >> "$CSV_FILE"
    echo "[$TIMESTAMP] Test at level $level complete."
done

echo "All tests complete. Results are stored in '$CSV_FILE'."

```


