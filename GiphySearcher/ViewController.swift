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
    var displaySearchBar = true
    
    private let queue = DispatchQueue(label: "GiphySearcher", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestImages(searchText: searchBar.text)
        
        layout.headerReferenceSize = CGSize(width: view.frame.size.width, height: displaySearchBar == true ? 60 : 0)
        let itemWidthSize = UIScreen.main.bounds.width/2 - 3
        let itemHeightSize = UIScreen.main.bounds.height/4 - 20
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        layout.itemSize = CGSize(width: itemWidthSize, height: itemHeightSize)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        collectionView?.collectionViewLayout = layout

        searchBar.delegate = self
    }
    
    func requestImages(searchText: String?){
        if (searchText == nil || searchText == ""){
            Giphy.Gif.request(.trending, completionHandler: processResult)
        } else {
            guard let searchText = searchText else {
                displaySearchBar = true
                return
            }
            Giphy.Gif.request(.search(searchText), completionHandler: processResult)
        }
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else { return UICollectionReusableView() }
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
        reusableView.addSubview(searchBar)
        searchBar.placeholder = "Please enter the name of the gif"
        searchBar.sizeToFit()
        return reusableView
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            requestImages(searchText: searchText)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        let imageForGif = images[indexPath.row]
        detVC.gifImageForView.append(imageForGif)
        self.navigationController?.pushViewController(detVC, animated: true)
    }
}

extension CollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestImages(searchText: searchBar.text)
    }
}

