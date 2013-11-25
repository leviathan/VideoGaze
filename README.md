VideoGaze
====================

This application fetches a video feed list from the vimeo API and displays the videos in a scrolling list.

The focus is on displaying the video feed in the smoothest and most convenient way to the user.

### Project Setup

Clone the project including submodules:

	$ git clone --recursive https://github.com/leviathan/VideoGaze.git

  $ gem install cocoapods

	$ cd VideoGaze

  $ pod setup (only needed when cocoapods aren't setup yet)

  $ pod install

Build and run the VideoGaze.xcworkspace project using XCode.

#### Cocoapods

http://www.raywenderlich.com/12139/introduction-to-cocoapods

***

### External Dependencies

Check the Podfile to see, which external components and libraries are beeing used in the project.

### Discussion

**Tests** - I'd use Kiwi for testing. Currently no tests are setup.

**Image-Caching** - I've considered using Path's FastImageCache, but did not implement this image cache yet. Mainly because the Vimeo API already return URLs for various image sizes.

However, using the FastImageCache might be useful, when the images sizes returned by the API are not sufficient and other image dimensions are required by the app (which they aren't currently).

https://github.com/path/FastImageCache



