//
//  ViewController.swift
//  TestAppSVG
//
//  Created by Rustem Manafov on 10.05.23.
//

import UIKit
import PocketSVG
import Kingfisher
import AlamofireImage

class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageViewConstraints()
        
        let svgUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/02/SVG_logo.svg")!
        let processor = SVGProcessor(size: CGSize(width: 200, height: 50))
        KingfisherManager.shared.retrieveImage(with: svgUrl, options: [.processor(processor), .forceRefresh]) {  result in
            switch (result){
            case .success(let value):
                self.imageView.image = value.image
            case .failure(let error):
                print("error", error.localizedDescription)
            }
        }
    }
    
    func imageViewConstraints() {
        imageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 28).isActive = true
    }
    
    struct SVGProcessor: ImageProcessor {
        
        let identifier = "svgprocessor"
        var size: CGSize!
        init(size: CGSize) {
            self.size = size
        }
        func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> Image? {
            switch item {
            case .image(let image):
                //  print("already an image")
                return image
            case .data(let data):
                //  print("svg string")
                if let svgString = String(data: data, encoding: .utf8){
                    // let layer = SVGLayer(
                    let path = SVGBezierPath.paths(fromSVGString: svgString)
                    let layer = SVGLayer()
                    layer.paths = path
                    let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    layer.frame = frame
                    let img = self.snapshotImage(for: layer)
                    return img
                }
                return nil
            }
        }
        
        func snapshotImage(for view: CALayer) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            view.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
}




