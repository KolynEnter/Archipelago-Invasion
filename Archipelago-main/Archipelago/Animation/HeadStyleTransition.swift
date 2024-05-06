//
//  ApeHeadTransition.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/31/23.
//

import UIKit

class HeadStyleTransition {
    var imageViews = [UIImageView]()
    
    init(picture: String) {
        // Assign the heads
        var myImage = UIImage(named: picture)
        myImage = myImage?.resized(to: CGSize(width: (myImage?.size.width)!/2, height: (myImage?.size.height)!/2))

        let initialX: CGFloat = 25
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return}
        guard let firstWindow = firstScene.windows.first else {return}
        let initialY: CGFloat = firstWindow.bounds.height
        
        for i in 0 ..< 8 {
            if i % 2 == 0 {
                let imageView = UIImageView(image: myImage)
                imageView.center = CGPoint(x: initialX + (CGFloat(i) * (imageView.image?.size.width)!), y: 0)
                imageView.layer.zPosition = 1
                imageViews.append(imageView)
            } else {
                let imageView = UIImageView(image: myImage)
                imageView.center = CGPoint(x: initialX + (CGFloat(i) * (imageView.image?.size.width)!), y: initialY)
                imageView.layer.zPosition = 1
                imageViews.append(imageView)
            }
        }
        
        // Assign the gray rectangles
        // Times 3 beacuse going from landscape to portrait will result in incomplete transition animation
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: myImage!.size.width, height: (firstWindow.bounds.height + myImage!.size.height)*3 ))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(backGroundColor.cgColor)
            //ctx.cgContext.setFillColor(UIColor.purple.cgColor)
            ctx.cgContext.setLineWidth(0)
            
            let rectangle = CGRect(x: 0, y: 0, width: myImage!.size.width, height: (firstWindow.bounds.height + myImage!.size.height)*3 )
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        for i in 0 ..< 8 {
            if i % 2 == 0 {
                let blackRectangle = UIImageView(image: img)
                blackRectangle.center = CGPoint(x: initialX + (CGFloat(i) * myImage!.size.width),
                                                y: (-firstWindow.bounds.height/2 - myImage!.size.height/2)*3 )
                imageViews.append(blackRectangle)
            } else {
                let grayRectangle = UIImageView(image: img)
                grayRectangle.center = CGPoint(x: initialX + (CGFloat(i) * myImage!.size.width),
                                                y: initialY + (firstWindow.bounds.height/2 + myImage!.size.height/2)*3 )
                imageViews.append(grayRectangle)
            }
        }
    }
    
    func addAllImages(view: UIView) {
        for imageView in imageViews {
            view.addSubview(imageView)
        }
    }

    func slidingImage() {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return}
        guard let firstWindow = firstScene.windows.first else {return}
        let transitHeight = (imageViews[0].image?.size.height)! + firstWindow.bounds.height
        
        for i in 0 ..< imageViews.count {
            if i % 2 == 0 {
                UIView.animate(withDuration: 3.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0.01, animations: {
                    self.imageViews[i].transform = CGAffineTransform(translationX: 0, y: transitHeight*2)
                })
            } else {
                UIView.animate(withDuration: 3.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0.01, animations: {
                    self.imageViews[i].transform = CGAffineTransform(translationX: 0, y: -transitHeight*2)
                })
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
            for imageView in self.imageViews {
                imageView.removeFromSuperview()
            }
        })
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
