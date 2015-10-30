//
//  MenuViewController.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/30.
//
//

import UIKit

protocol PCUMenuViewControllerDelegate: NSObjectProtocol {
    
    func menuItemDidPressed(menuViewController: PonyChatUI.UserInterface.MenuViewController, itemIndex: Int)
    
}

extension PonyChatUI.UserInterface {
    
    class MenuViewController: UIViewController {
        
        weak var delegate: PCUMenuViewControllerDelegate?
        
        var titles: [String] {
            didSet {
                reloadData()
            }
        }
        
        var isDown: Bool = false
        
        var upTriangleView = MenuUpTriangleView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let downTriangleView = MenuDownTriangleView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let segmentedControl = UISegmentedControl()
        
        init(titles: [String]) {
            self.titles = titles
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func showMenuView(referencePoint: CGPoint) {
            var sFrame = CGRectMake(
                referencePoint.x - widthOfSegmentedControl() / 2.0,
                referencePoint.y - 14.0 - 36.0,
                widthOfSegmentedControl(),
                36.0)
            if sFrame.origin.y < 0.0 {
                sFrame.origin.y = UIApplication.sharedApplication().statusBarFrame.size.height
                isDown = false
            }
            else {
                isDown = false
            }
            
            var triangleX = referencePoint.x - 20.0
            if referencePoint.x < 20.0 {
                triangleX = 20.0
            }
            else if referencePoint.x > view.bounds.width - 66.0 {
                triangleX = view.bounds.width - 66.0
            }
            
            upTriangleView.frame = CGRect(x: triangleX, y: sFrame.origin.y - 20.0, width: 40, height: 20)
            downTriangleView.frame = CGRect(x: triangleX, y: sFrame.origin.y + 36.0, width: 40, height: 20)
            
            if sFrame.origin.x < 0 + 8.0 {
                sFrame.origin.x = 0.0 + 8.0
            }
            else if sFrame.origin.x + sFrame.size.width > view.bounds.width - 8.0 {
                sFrame.origin.x = view.bounds.width - sFrame.size.width - 8.0
            }
            
            segmentedControl.frame = sFrame
            
            if let window = UIApplication.sharedApplication().keyWindow {
                self.segmentedControl.alpha = 1.0
                if self.isDown {
                    self.upTriangleView.alpha = 1.0
                }
                else {
                    self.downTriangleView.alpha = 1.0
                }
                window.addSubview(view)
                UIView.animateWithDuration(0.35,
                animations: { () -> Void in
                    self.view.alpha = 1.0
                },
                completion: { (_) -> Void in
                    self.view.alpha = 1.0
                })
            }
            
        }
        
        func dismiss() {
            self.segmentedControl.alpha = 0.0
            self.upTriangleView.alpha = 0.0
            self.downTriangleView.alpha = 0.0
            self.view.removeFromSuperview()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            configureViews()
            view.addSubview(self.upTriangleView)
            view.addSubview(self.downTriangleView)
            view.addSubview(self.segmentedControl)
            reloadData()
        }
        
        func reloadData() {
            segmentedControl.removeAllSegments()
            var index = 0
            for title in self.titles {
                segmentedControl.insertSegmentWithTitle(title, atIndex: index, animated: false)
                let textSize = (title as NSString).boundingRectWithSize(CGSize(width: CGFloat.max, height: CGFloat.max),
                    options: [],
                    attributes: [
                        NSForegroundColorAttributeName: UIColor.whiteColor(),
                        NSFontAttributeName: UIFont.systemFontOfSize(14)],
                    context: nil)
                segmentedControl.setWidth(textSize.width + 32, forSegmentAtIndex: index)
                index++
            }
        }
        
        func configureViews() {
            configureUpTriangle()
            configureDownTriangle()
            configureSegmentedControl()
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismiss"))
        }
        
        func configureUpTriangle() {
            upTriangleView.backgroundColor = UIColor.clearColor()
            upTriangleView.alpha = 0.0
        }
        
        func configureDownTriangle() {
            downTriangleView.backgroundColor = UIColor.clearColor()
            downTriangleView.alpha = 0.0
        }
        
        func configureSegmentedControl() {
            segmentedControl.tintColor = UIColor.clearColor()
            segmentedControl.backgroundColor = UIColor(white: 0.0, alpha: 0.85)
            segmentedControl.layer.cornerRadius = 6
            segmentedControl.layer.masksToBounds = true
            segmentedControl.setTitleTextAttributes([
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(14)
                ], forState: UIControlState.Normal)
            segmentedControl.setTitleTextAttributes([
                NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.5),
                NSFontAttributeName: UIFont.systemFontOfSize(14)
                ], forState: UIControlState.Highlighted)
            segmentedControl.setDividerImage(imageWithColor(UIColor(white: 1.0, alpha: 0.25)),
                forLeftSegmentState: .Normal,
                rightSegmentState: .Normal,
                barMetrics: .Default)
            segmentedControl.addTarget(self, action: "handleValueChanged", forControlEvents: .ValueChanged)
        }
        
        func widthOfSegmentedControl() -> CGFloat {
            var width:CGFloat = 0.0
            for title in self.titles {
                let textSize = (title as NSString).boundingRectWithSize(CGSize(width: CGFloat.max, height: CGFloat.max),
                    options: [],
                    attributes: [
                        NSForegroundColorAttributeName: UIColor.whiteColor(),
                        NSFontAttributeName: UIFont.systemFontOfSize(14)],
                    context: nil)
                width += textSize.width
                width += 32.0
            }
            if self.titles.count > 1 {
                width += 4.0
            }
            return width
        }
        
        func imageWithColor(color: UIColor) -> UIImage {
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillRect(context, rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
        func handleValueChanged() {
            if let delegate = delegate {
                delegate.menuItemDidPressed(self, itemIndex: segmentedControl.selectedSegmentIndex)
            }
            segmentedControl.selectedSegmentIndex = -1
            dismiss()
        }
        
    }
    
    class MenuUpTriangleView: UIView {
        
        override func drawRect(rect: CGRect) {
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 20, 17);
            let polygonPath = UIBezierPath()
            polygonPath.moveToPoint(CGPoint(x: 0, y: -7.25))
            polygonPath.addLineToPoint(CGPoint(x: 9.74, y: 3.62))
            polygonPath.addLineToPoint(CGPoint(x: -9.74, y: 3.63))
            polygonPath.closePath()
            UIColor(white: 0.0, alpha: 0.85).setFill()
            polygonPath.fill()
            CGContextRestoreGState(context)
        }
        
    }
    
    class MenuDownTriangleView: UIView {
        
        override func drawRect(rect: CGRect) {
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 20, 3);
            CGContextRotateCTM(context, -180.0 * CGFloat(M_PI) / 180.0);
            let polygonPath = UIBezierPath()
            polygonPath.moveToPoint(CGPoint(x: 0, y: -7.25))
            polygonPath.addLineToPoint(CGPoint(x: 9.74, y: 3.62))
            polygonPath.addLineToPoint(CGPoint(x: -9.74, y: 3.63))
            polygonPath.closePath()
            UIColor(white: 0.0, alpha: 0.85).setFill()
            polygonPath.fill()
            CGContextRestoreGState(context)
        }
        
    }
    
}

