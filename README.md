# GifSearcher
GIF Searcher is the app that give ability to search and show GIFs. The main view of this app contains list of Trending GIFs and search bar, with help of this bar you can see GIFs that you type on search bar.

# Screenshots
![Show trending GIFs](https://user-images.githubusercontent.com/24452409/44164579-196c4300-a0cf-11e8-867b-278333afb945.png)![Show GIFs using search bar](https://user-images.githubusercontent.com/24452409/44164578-18d3ac80-a0cf-11e8-9b52-4d1f0f1371ad.png)![Show GIF and GIF size](https://user-images.githubusercontent.com/24452409/44164576-18d3ac80-a0cf-11e8-9bd4-ef5f2da4c355.png)

# Installation

### CocoaPods Setup

Open Terminal
If you haven't already done so, run this command
```
sudo gem install cocoapods
```

Wait for it to finish before proceeding.
Find the project directory in the Finder. This should be the folder that has the Xcode project in it.
Type cd into the terminal, followed by a space.
Drag and drop the project directory into the terminal window. It should now say something like this:
```
cd /Users/someone/Downloads/WonderfulProject
```

After this type pod init into the terminal
```
pod init
```

Open PodFile. Add the GiphySwift and FLAnimatedImage entry to your Podfile
```
pod 'GiphySwift'
pod 'FLAnimatedImage'
```

Run pods to grab the GiphySwift and FLAnimatedImage framework
```
pod install
```

After all, your PodFile should be like this:
```
platform :ios, '9.0'
use_frameworks!

target 'GiphySearcher' do
  pod 'GiphySwift'
  pod 'FLAnimatedImage'
end
```

# GifSearcher App
Clone or download the repository, setup CocoaPods and open GifSearcher.xcworkspace to check out the GifSearcher app.

# Thanks
* <a href="https://github.com/Flipboard">FLAnimatedImage</a>
* <a href="https://developers.giphy.com">GIPHY</a>
* <a href="https://github.com/mseijas/GiphySwift">Matias Seijas</a>

# Author
Alex Ezhkin

LinkedIn: https://www.linkedin.com/in/aleksandr-ezhkin-bbaa07134/
