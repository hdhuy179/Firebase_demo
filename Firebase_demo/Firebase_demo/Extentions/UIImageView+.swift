//
//  UIImageView+.swift
//  Firebase_demo
//
//  Created by Hoang Dinh Huy on 11/5/19.
//  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
//

import UIKit

extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error? ) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func loadImage(from url: URL) {
        getData(from: url) { (data, response, err) in
            guard let data = data, err == nil else {
                print("Error getting Image from \(url) \(err!.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
