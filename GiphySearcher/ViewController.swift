//
//  ViewController.swift
//  GiphySearcher
//
//  Created by Alex on 14.08.18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import FLAnimatedImage
import GiphySwift


class ImageCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCell"
    @IBOutlet weak var imageView: FLAnimatedImageView!
    override func prepareForReuse() {
        imageView.image = nil
    }
}

class CollectionViewController: UICollectionViewController {
    
    var images = [GiphyImage]()
    
    let layout = UICollectionViewFlowLayout()
    let searchBar = UISearchBar()
    var displaySearchBar = false
    
    private let queue = DispatchQueue(label: "com.giphyswift.example", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestImages()
        
        layout.headerReferenceSize = CGSize(width: view.frame.size.width, height: displaySearchBar == true ? 44 : 0)
        layout.itemSize = CGSize(width: 120, height: 120)
        collectionView?.collectionViewLayout = layout
    }
    
    func requestImages(){
        Giphy.Gif.request(.trending, completionHandler: processResult)
    }
    
    func processResult(result: Any) {
        if let result = result as? GiphyRequestResult {
            if case .success(let images) = result {
                self.images = images.result
                self.updateUI()
            }
        }
        
        if let result = result as? GiphyRandomRequestResult {
            if case .success(let images) = result {
                self.images = images.result
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell
            else { fatalError("Could not dequeue cell with reuseIdentifier: \(ImageCell.reuseIdentifier)") }
        
        let image = images[indexPath.row]
        guard let url = urlFor(image: image) else { fatalError("Unable to retrieve URL for image") }
        
        queue.async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                
                OperationQueue.main.addOperation {
                    DispatchQueue.main.async {
                        let gifImage = FLAnimatedImage(animatedGIFData: data)
                        cell.imageView.animatedImage = gifImage
                    }
                }
                
                }.resume()
        }
        
        return cell
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

