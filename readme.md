# Live HLS Project

This is a project for rebroadcasting HLS (HTTP Live Streaming). It uses a Docker containerized application to capture m3u8 streams and convert them to HLS format, then uploads the output to Google Drive.

## System Requirements

- Docker

## Usage

1. Clone the project to your local machine:

   ```
   git clone https://github.com/a840817a/live-hls.git
   ```

2. Navigate to the project directory:

   ```
   cd repository
   ```

3. Build the Docker image:

   ```
   docker build -t live-hls .
   ```

4. Run the Docker container:

   ```
   docker run -p 8080:8080 -e HLS_URL="YOUR_HLS_URL" -e SERVICE_ACCOUNT_KEY="YOUR_SERVICE_ACCOUNT_KEY" -e DRIVE_FOLDER_ID="YOUR_DRIVE_FOLDER_ID" -e FILE_NAME="YOUR_FILE_NAME" live-hls
   ```

   Replace the following values with your own configurations:

   - `YOUR_HLS_URL`: Enter the URL of the HLS stream you want to capture.
   - `YOUR_SERVICE_ACCOUNT_KEY`: The content of your Google service account key.
   - `YOUR_DRIVE_FOLDER_ID`: The ID of the Google Drive target folder.
   - `YOUR_FILE_NAME`: The name of the file to upload to Google Drive.

5. Access `http://localhost:8080` in your browser, and you should see the player and play the HLS live stream.

## Code Structure

- `Dockerfile`: The build script for the Docker image, including the required packages and configurations.
- `entrypoint.sh`: The entry point script for the Docker container, responsible for starting Nginx, capturing and converting the HLS stream, and uploading to Google Drive.
- `nginx.conf`: The configuration file for Nginx, setting up server listening ports and path mapping.
- `index.html`: The HTML file for the web player, using video.js to play the HLS stream.
- `uploadGoogleDrive.sh`: The script for uploading files to Google Drive, authenticating and uploading using the Google Drive API and service account key.

## Notes

- Make sure you have replaced the relevant configuration values, including HLS_URL, SERVICE_ACCOUNT_KEY, DRIVE_FOLDER_ID, and FILE_NAME.
- Ensure that your Google service account key has the necessary permissions for Google Drive uploads.
- Ensure that the 8080 port on your host is not already in use.

## Additional Resources

- [HTTP Live Streaming (HLS) Official Documentation](https://developer.apple.com/streaming/)
- [Docker Official Website](https://www.docker.com/)

For any questions or issues, feel free to contact us.

