# Share Photos Tool

![Made with Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)
![Photo Share](https://img.shields.io/badge/Photo%20Share-Enabled-brightgreen)
![Latest Version](https://img.shields.io/github/v/release/mashunterbd/Share-Photos)
![Kali Nethunter](https://img.shields.io/badge/Kali%20Nethunter-Compatible-blue)
![QR Code](https://img.shields.io/badge/QR%20Code-Supported-orange)

This tool allows you to share photos taken on specific dates via a local web server. It provides an interface to select, view, and download photos through a browser.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
  - [Clone the Repository](#clone-the-repository)
  - [Navigate to the Directory](#navigate-to-the-directory)
  - [Make the Script Executable](#make-the-script-executable)
  - [Install Dependencies](#install-dependencies)
- [Usage](#usage)
  - [Run the Script](#run-the-script)
  - [Select Date Option](#select-date-option)
  - [Enter Custom Date](#enter-custom-date)
  - [Access Photos](#access-photos)
  - [Stop the Server](#stop-the-server)
- [Benefits](#benefits)
- [Troubleshooting](#troubleshooting)
- [Example](#example)

## Features

- Filter and share photos by specific dates.
- Provide options to share photos taken today, yesterday, or on a custom date.
- Generate a QR code for easy access to the local web server.
- Allow friends to connect via a hotspot and download the photos.

## Installation

To use this tool, follow the steps below:

### Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/mashunterbd/Share-Photos.git
````

### Navigate to the Directory

Change to the directory where the script is located:

```bash
cd Share-Photos
```

### Make the Script Executable

Ensure the script has executable permissions:

```bash
chmod +x share-photos.sh
```

### Install Dependencies

Install the required dependencies:

- **ExifTool**: Used to filter photos by their creation date.
- **Python3**: Used to run a simple HTTP server.
- **qrcode-terminal**: Used to generate QR codes in the terminal.

On Debian-based systems (like Ubuntu), you can install these dependencies using:

```bash
sudo apt update
sudo apt install exiftool python3 qrcode-terminal
```

## Usage

### Run the Script

Execute the script from the terminal:

```bash
./share-photos.sh
```

### Select Date Option

You will be prompted to choose an option to filter photos by date:

```
Choose an option to filter photos by date:
1) Custom Date (YYYY/MM/DD)
2) Yesterday
3) Today
Enter your choice: 
```

- Choose `1` to enter a custom date.
- Choose `2` to filter photos taken yesterday.
- Choose `3` to filter photos taken today.

### Enter Custom Date

If you choose the custom date option, enter the date in the format `YYYY/MM/DD`:

```
Enter the date (YYYY/MM/DD): 2024/06/24
```

### Access Photos

- If there are photos available for the selected date, the script will start a local HTTP server on port 8000.
- A QR code will be generated for easy access.
- Use a QR code scanner on your mobile device to scan the code and open the browser to view and download photos.

### Stop the Server

- Press Enter in the terminal to stop the server and clean up temporary files.
- The server will stop and all temporary files will be removed.

## Benefits

- **Easy Sharing**: Quickly share photos taken on specific dates with friends.
- **Local Hosting**: Host the photos locally on your machine without the need for an internet connection.
- **Secure Access**: Use QR codes to securely and conveniently share access to your local server.
- **Selective Download**: Allow friends to select and download only the photos they want.

## Troubleshooting

- **No Photos Found**: If no photos are available for the selected date, the script will notify you and not start the server.
- **Dependencies**: Ensure all required dependencies are installed and properly configured.

## Example

Here’s a step-by-step example of running the script and sharing photos taken on a custom date:

1. Clone the repository:
   ```bash
   git clone https://github.com/mashunterbd/Share-Photos.git
   cd Share-Photos
   chmod +x share-photos.sh
   ```

2. Install dependencies:
   ```bash
   sudo apt update
   sudo apt install exiftool python3 qrcode-terminal
   ```

3. Run the script:
   ```bash
   ./share-photos.sh
   ```

4. Choose a custom date:
   ```
   Choose an option to filter photos by date:
   1) Custom Date (YYYY/MM/DD)
   2) Yesterday
   3) Today
   Enter your choice: 1
   Enter the date (YYYY/MM/DD): 2024/06/24
   ```

5. Scan the QR code generated in the terminal with your mobile device to view and download photos.

By following this guide, you can effectively use the `share-photos.sh` script to share your photos easily and securely.

```
