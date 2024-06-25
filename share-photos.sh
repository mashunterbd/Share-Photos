#!/bin/bash

# Function to create the HTML file with the file list based on their types
create_html_file() {
  cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shared Photos and Videos</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            background-color: #f9f9f9;
            margin: 20px;
        }
        .file-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            width: 100%;
            margin-top: 20px;
        }
        .file-item {
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px;
            text-align: center;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 180px;
        }
        .file-item img {
            max-width: 100px;
            max-height: 100px;
        }
        .file-item input[type="checkbox"] {
            display: block;
            margin: 10px auto;
        }
        .file-item .file-name {
            margin-top: 10px;
            font-size: 14px;
            word-wrap: break-word;
        }
        .file-item button {
            display: block;
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            font-size: 16px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .file-item button:hover {
            background-color: #218838;
        }
        .download-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            width: 100%;
        }
        .download-buttons button {
            padding: 15px 30px;
            margin: 5px;
            font-size: 18px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .download-buttons button:hover {
            background-color: #0056b3;
        }
    </style>
    <script>
        function downloadMarkedFiles() {
            const markedCheckboxes = document.querySelectorAll('input[name="fileCheckbox"]:checked');
            markedCheckboxes.forEach(checkbox => {
                const link = document.createElement('a');
                link.href = checkbox.value;
                link.download = checkbox.value;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            });
        }

        function downloadAllFiles() {
            const allCheckboxes = document.querySelectorAll('input[name="fileCheckbox"]');
            allCheckboxes.forEach(checkbox => {
                const link = document.createElement('a');
                link.href = checkbox.value;
                link.download = checkbox.value;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            });
        }
    </script>
</head>
<body>
    <div class="download-buttons">
        <button onclick="downloadMarkedFiles()">Download Marked Files</button>
        <button onclick="downloadAllFiles()">Download All Files</button>
    </div>
    <div class="file-container">
EOF

  # Add file items to the HTML
  while read file; do
    if [[ -f $file ]]; then
      file_icon=""
      case "${file##*.}" in
        jpg|jpeg|png|gif)
          file_icon="$file"
          ;;
        mp4|avi|mov)
          file_icon="video-icon.png"  # Placeholder icon for video files
          ;;
        mp3|wav)
          file_icon="audio-icon.png"  # Placeholder icon for audio files
          ;;
        txt)
          file_icon="txt-icon.png"  # Placeholder icon for text files
          ;;
        pdf)
          file_icon="pdf-icon.png"  # Placeholder icon for PDF files
          ;;
        doc|docx)
          file_icon="doc-icon.png"  # Placeholder icon for document files
          ;;
        *)
          file_icon="file-icon.png"  # Generic file icon
          ;;
      esac

      # Copy the file to the current directory for preview and download purposes
      cp "$file" .

      # Generate HTML for each file
      cat <<EOF >> index.html
        <div class="file-item">
            <img src="$file_icon" alt="File">
            <input type="checkbox" name="fileCheckbox" value="$file">
            <div class="file-name">$file</div>
            <button onclick="window.location.href='$file'">Download</button>
        </div>
EOF
    fi
  done < filtered_files.txt

  # Complete HTML file
  cat <<EOF >> index.html
    </div>
</body>
</html>
EOF
}

# Function to generate QR code
generate_qr() {
    qrcode-terminal "http://${1}:8000"
}

# Check if wlan0 has an IP address
if ip addr show wlan0 | grep -q "inet "; then
    wlan0_ip=$(ip addr show wlan0 | awk '/inet / {print $2}' | cut -d '/' -f1)
fi

# Check if wlan1 has an IP address
if ip addr show wlan1 | grep -q "inet "; then
    wlan1_ip=$(ip addr show wlan1 | awk '/inet / {print $2}' | cut -d '/' -f1)
fi

# Main script
echo "Choose an option to filter photos by date:"
echo "1) Custom Date (YYYY/MM/DD)"
echo "2) Yesterday"
echo "3) Today"
read -p "Enter your choice: " choice

case $choice in
  1)
    read -p "Enter the date (YYYY/MM/DD): " custom_date
    exif_date=${custom_date//\//:}
    ;;
  2)
    exif_date=$(date -d "yesterday" "+%Y:%m:%d")
    ;;
  3)
    exif_date=$(date "+%Y:%m:%d")
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac

# Filter files based on the selected date
exiftool -if "\$CreateDate =~ /$exif_date/" -p "\$FileName" -q -r * > filtered_files.txt

# Check if any files were found
if [[ ! -s filtered_files.txt ]]; then
  echo "No images available for the date you provided."
  rm filtered_files.txt
  exit 1
fi

# Create the HTML file
create_html_file

# Start a simple HTTP server to serve the HTML file
echo "Starting HTTP server on port 8000..."
python3 -m http.server 8000 &

# Get the process ID of the HTTP server
server_pid=$!

# Generate and display QR code for the server URL
if [[ -n $wlan1_ip ]]; then
    generate_qr "$wlan1_ip"
elif [[ -n $wlan0_ip ]]; then
    generate_qr "$wlan0_ip"
else
    echo "No wireless network connection found. Generating QR code for localhost."
    generate_qr "127.0.0.1"
fi

# Prompt user to press Enter to stop
echo "Press Enter to stop the server and clean up..."
read

# Stop the HTTP server
kill $server_pid

# Clean up
rm filtered_files.txt
rm index.html

echo "Clean up complete. Server stopped."
