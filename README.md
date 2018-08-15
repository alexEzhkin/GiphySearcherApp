# GifSearcher
GIF Searcher is the app that give ability to search and show GIFs. The main view of this app contains list of Trending GIFs and search bar, with help of this bar you can see GIFs that you type on search bar.

# Screenshots
![Show trending GIFs](https://user-images.githubusercontent.com/24452409/44171651-665a1480-a0e3-11e8-96cd-a0b1dfeb048a.png)![Show GIFs using search bar](https://user-images.githubusercontent.com/24452409/44171650-665a1480-a0e3-11e8-878a-d9de8f496699.png)![Show GIF and GIF size](https://user-images.githubusercontent.com/24452409/44171649-665a1480-a0e3-11e8-92eb-0d987033ee60.png)

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
Drag and drop the project directory into the terminal window. Now, it should say something like this:
```
cd /Users/someone/Downloads/WonderfulProject
```

After this, type pod init into the terminal
```
pod init
```

Open PodFile. Add the GiphySwift and FLAnimatedImage entry to your Podfile
```
pod 'GiphySwift'
pod 'FLAnimatedImage'
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

Run pods to grab the GiphySwift and FLAnimatedImage framework
```
pod install
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
