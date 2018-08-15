//
//  DetailViewController.swift
//  GiphySearcher
//
//  Created by Alex on 15.08.18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import FLAnimatedImage
import GiphySwift

class DetailViewController: UIViewController {

    @IBOutlet weak var showSizeLabel: UILabel!
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    var gifImageForView = [GiphyImage]()
    
    private let queue = DispatchQueue(label: "GiphySearcher", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imgFromGifImage = gifImageForView.first
        guard let url = urlFor(image: imgFromGifImage!) else { fatalError("Unable to retrieve URL for image") }
        
        queue.async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                
                OperationQueue.main.addOperation {
                    DispatchQueue.main.async {
                        let gifImage = FLAnimatedImage(animatedGIFData: data)
                        let widthGifImage = gifImage?.size.width
                        let heightGifImage = gifImage?.size.height
                        self.gifImageView.frame = CGRect(x: 0, y: 0, width: widthGifImage!, height: heightGifImage!)
                        self.gifImageView.center = (self.gifImageView.superview?.center)!
                        self.showSizeLabel.text = "Size of Gif: Width: \(widthGifImage!) Height: \(heightGifImage!)"
                        self.gifImageView.animatedImage = gifImage
                    }
                }
            }.resume()
        }
    }
    
    func urlFor(image: GiphyImage) -> URL? {
        if let image = image as? GiphyImageResult {
            return URL(string: image.images.fixedHeight.downsampled.gif.url)
        }
        
        // NOTE: The Giphy API returns these URLs as HTTP - Here we convert them first to HTTPS
        if let image = image as? GiphyRandomImageResult {
            var urlComponents = URLComponents(string: image.images.fixedHeight.downsampled.gif.url)
            urlComponents?.scheme = "https"
            return urlComponents?.url
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
