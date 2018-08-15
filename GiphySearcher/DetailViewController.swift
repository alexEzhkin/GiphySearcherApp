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

    @IBOutlet weak var showSize: UILabel!
    @IBOutlet weak var gifView: FLAnimatedImageView!
    var gifImage = [GiphyImage]()
    
    private let queue = DispatchQueue(label: "GiphySearcher", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imgFromGifImage = gifImage.first
        guard let url = urlFor(image: imgFromGifImage!) else { fatalError("Unable to retrieve URL for image") }
        
        queue.async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                
                OperationQueue.main.addOperation {
                    DispatchQueue.main.async {
                        let gifImage = FLAnimatedImage(animatedGIFData: data)
                        let a = gifImage?.size.width
                        let b = gifImage?.size.height
                        self.gifView.frame = CGRect(x: 0, y: 0, width: a!, height: b!)
                        self.gifView.center = (self.gifView.superview?.center)!
                        self.showSize.text = "Size of Gif: Width: \(a!) Height: \(b!)"
                        self.gifView.animatedImage = gifImage
                    }
                }
            }.resume()
        }
        
        
        // Do any additional setup after loading the view.
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
