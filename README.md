# Astronomy Picture of the Day App

![Logo NASA](lib\assets\splash\app_icon_foreground.png)

This project is a mobile application developed using Dart language and Flutter framework. The app fetches media from NASA's "Astronomy Picture of the Day" website and presents them in an organized manner. It consists of two screens: a list of media and a detail screen for each image. The app also supports offline functionality, allowing users to view previously loaded media even without an internet connection.

## Features

- `Image List`: Displays titles and dates of the media with a search field to filter media by title or date.
- `Detail Screen`: Provides detailed information about each image, including the image itself, date, title, and explanation.
- `Offline Support`: Works seamlessly in offline mode, allowing users to access previously loaded media.
- `Responsive Design`: Supports multiple resolutions and sizes for various devices.
- `Internationalization (i18n)`: Supports 3 languages ​​located in the **lib/assets/i18n** folder: en_US, es_ES, pt_BR
- `Pull-to-refresh and Pagination`: Provides pull-to-refresh functionality and pagination for a better user experience.

## NASA API Integration

The app retrieves media from NASA's API, specifically the "Astronomy Picture of the Day" API. The integration with the NASA API ensures that users receive up-to-date and accurate information about astronomy pictures.

## Project Structure

- `Retrieval of NASA Media`: Media from NASA's "Astronomy Picture of the Day" are retrieved using the API provided by NASA. The API key is securely stored and used to make requests to the API.
- `Pagination and Pull-to-Refresh`: On the media list screen, pagination functionality was implemented to load more media as the user scrolls down the list. Additionally, pull-to-refresh functionality allows the user to refresh the media list by pulling down.
- `Offline Functionality`: The application works offline, allowing users to view previously loaded media even without an internet connection. Media List are stored locally for offline access.
