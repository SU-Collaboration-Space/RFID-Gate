import serial
import time
import subprocess
import requests

def check_access_via_api(hex_data):
    """
    Checks the scanned RFID tag against the API.
    Returns the value of 'access_granted' from the JSON response.
    """
    api_url = f"http://10.*.*.*/api/check.php?rfid={hex_data}" # Path to the check.php file, which will query the ID against a database
    print(f"Checking API: {api_url}")

    try:
        # Make the GET request to the API with a timeout
        response = requests.get(api_url, timeout=5)
        
        # Raise an exception for bad status codes (4xx or 5xx)
        response.raise_for_status()
        
        # Parse the JSON response
        data = response.json()
        
        # Expected JSON format: {"access_granted": true/false, "message": "..."}
        # Safely get the 'access_granted' value. Default to True if key is missing.
        access_status = data.get('access_granted', True)
        print(f"API Response: {data}")
        return access_status

    except requests.exceptions.RequestException as e:
        # Handle network errors, timeouts, bad status codes, etc.
        print(f"API Error: Could not connect or received an error. {e}")
        # Return True as a safe default to prevent unwanted snapshots on API failure
        return True

def capture_rtsp_snapshot():
    """
    Captures a single frame from an RTSP stream using ffmpeg.
    """
    command = [
        'ffmpeg', '-y', '-i', 'rtsp://user:pass@ip.add.re.ss:554/Streaming/Channels/101',
        '-vframes', '1', '-strftime', '1', '/var/www/html/capture/%Y-%m-%d_%H-%M-%S.jpg'
    ]
    print("Leave denied. Taking picture...")
    try:
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        print("Screenshot saved successfully!")
    except FileNotFoundError:
        print("Error: 'ffmpeg' command not found.")
    except subprocess.CalledProcessError as e:
        print(f"Error executing FFmpeg command. Return code: {e.returncode}")
        print("FFmpeg stderr output:\n", e.stderr)

def read_rfid():
    """
    Listens for RFID data, checks it via API, and takes a snapshot on denial.
    """
    try:
        ser = serial.Serial(
            port='/dev/ttyAMA0', baudrate=115200, parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE, bytesize=serial.EIGHTBITS, timeout=1
        )
        print("Listening for RFID tags...")
        while True:
            line = ser.readline()
            if line:
                hex_data = line.hex().upper()
                print(f"\n--- New Tag Scanned ---\nReceived Hex Data: {hex_data}")
                
                # --- THIS IS THE NEW LOGIC ---
                # Check the scanned tag against the API
                access_granted = check_access_via_api(hex_data)
                
                # If the API returns exactly False for 'access_granted'
                if access_granted is False:
                    # Call the function to take a picture
                    capture_rtsp_snapshot()
                else:
                    # This will run if access is granted OR if there was an API error
                    print("Leave granted or API check passed.")
                # -----------------------------

            time.sleep(0.1)
    except serial.SerialException as e:
        print(f"Error: Could not open serial port. {e}")
    except KeyboardInterrupt:
        print("\nProgram stopped by user.")
    finally:
        if 'ser' in locals() and ser.is_open:
            ser.close()
            print("Serial port closed.")

if __name__ == '__main__':
    read_rfid()
