//
//  CircleView.swift
//  CoachMarksExample
//
//  Created by Tulio Troncoso on 6/15/17.
//  Copyright © 2017 Darin Doria. All rights reserved.
//

import Foundation
import UIKit

class FocusView: UIView {
    enum FocusSwipeDirection {
        case leftToRight
        case rightToLeft
    }
    
    var animationShouldStop: Bool = false
    var swipeDirection: FocusSwipeDirection = .leftToRight
    
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let shapeLayer = self.layer as! CAShapeLayer
        
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).cgPath
        shapeLayer.backgroundColor = UIColor.white.cgColor
        shapeLayer.shadowRadius = 8
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapeLayer.shadowColor = UIColor(red: 0, green: 0.299, blue: 0.715, alpha: 1.0).cgColor
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).cgPath
        
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func userTap(recognizer: UITapGestureRecognizer) {
        isHidden = true
        removeFromSuperview()
    }
    
    
    func swipe(in frame: CGRect) {
        center(view: self, in: frame)
        animateSwipe()
    }
    
    func animateSwipe() {
        guard !animationShouldStop else {
            return
        }
        
        let scale = CGAffineTransform(scaleX: 2, y: 2)
        let translateRight = CGAffineTransform(translationX: 260, y: 0)
        
        if (swipeDirection == .leftToRight) {
            transform = scale;
        } else {
            // Start on the right hand side as well as scaling
            transform = translateRight.concatenating(scale)
        }
        
        alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.3, options: [], animations: {
            if (self.swipeDirection == .leftToRight) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            } else {
                self.transform = translateRight
            }
            
            self.alpha = 1.0
        }, completion: { (finished) in
            UIView.animate(withDuration: 1.0, animations: {
                if (self.swipeDirection == .leftToRight) {
                    self.transform = translateRight
                } else {
                    self.transform = CGAffineTransform.identity
                }
                
                self.alpha = 0
            }, completion: { (finished) in
                self.perform(#selector(self.animateSwipe))
            })
        })
    }
    
    
    // MARK:- Helper Functions
    func center(view: UIView, in frame: CGRect) {
        centerX(view: view, in: frame)
        centerY(view: view, in: frame)
    }
    
    func centerX(view: UIView, in frame: CGRect) {
        let centerX = frame.origin.x + (frame.height /  2)
        let offsetX = 260 / 2
        let newX = centerX + CGFloat(offsetX)
        
        view.frame = CGRect(x: newX, y: view.frame.origin.y, width: 40, height: 40)
    }
    
    func centerY(view: UIView, in frame: CGRect) {
        let centerY = frame.origin.y + (frame.height / 2)
        let offsetY = frame.height / 2
        let newY = centerY - offsetY
        
        view.frame = CGRect(x: view.frame.origin.x, y: newY, width: 40, height: 40)
    }
}