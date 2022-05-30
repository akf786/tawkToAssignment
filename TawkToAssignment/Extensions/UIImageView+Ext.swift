//
//  UIImageView+Ext.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    
    //MARK: - Download Image Network Call
    static func downloadImageData(from url: URL, completion: @escaping (_ data: Data?) -> () ) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil else {
                completion(nil)
                return
            }
            
            completion(data)
            
        }.resume()
    }
    
    
    //MARK: - Get Image From Cache or From Api
    func downloadImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFit, invertImage: Bool = false) {
        if let cacheImage = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            DispatchQueue.main.async { [weak self] in
                self?.image = cacheImage
            }
            return
        }
        
        
        UIImageView.downloadImageData(from: url) { data in
            guard let imageData = data, let image = UIImage(data: imageData) else {
                return
            }
            
            imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }
    }
}
