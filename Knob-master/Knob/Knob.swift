// Knob.swift
// Copyright © 2018 Chris Gulley. All rights reserved.

import UIKit

/**
 * Return vector from lhs point to rhs point.
 */
func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
    return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

extension CGVector {
    /**
     * Returns angle between vector and receiver in radians. Return is between
     * 0 and 2 * PI in clockwise direction.
     */
    func angleFromVector(_ vector: CGVector) -> Double {
        let angle = Double(atan2(dy, dx) - atan2(vector.dy, vector.dx))
        return angle > 0 ? angle : angle + 2 * Double.pi
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}

extension UIColor {
    /**
     * Returns a color with adjusted saturation and brigtness than can be used to
     * indicate control is disabled.
     */
    func disabledColor() -> UIColor {
        var h = CGFloat(0)
        var s = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)
        
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s * 0.5, brightness: b * 1.2, alpha: a)
    }
}

extension CATransaction {
    static func doWithNoAnimation(_ action:()->Void) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        action()
        CATransaction.commit()
    }
}

/**
 * A Knob object is a visual control used to select a value from a range of values between
 * 0 and 2 * PI radians. A user rotates the control using a single figure pan gesture with
 * values increasing as the knob is rotated clockwise. The value resets from 2 * PI to 0 as
 * the user rotates the knob through the 12 o'clock position.
 */
open class Knob: UIControl {
    fileprivate let indicatorLayer = CAShapeLayer()
    fileprivate let lineWidth = CGFloat(1)
    fileprivate var lastVector = CGVector.zero
    fileprivate var angle = 0.0
    
    /**
     * Contains the current value.
     */
    open var value: Double {
        get {
            return angle
        }
        set {
            angle = newValue.truncatingRemainder(dividingBy: (Double.pi * 2))
            updateLayer()
        }
       
        
    }
    
    override open var frame: CGRect {
        didSet {
            CATransaction.doWithNoAnimation {
                self.updateLayer()
            }
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            CATransaction.doWithNoAnimation {
                self.updateLayer()
            }
        }
    }
    
    override open var tintColor: UIColor! {
        didSet {
            CATransaction.doWithNoAnimation {
                self.updateLayer()
            }
        }
    }
    
    fileprivate var knobBackgroundColor: UIColor?
    override open var backgroundColor: UIColor? {
        get {
           return knobBackgroundColor
        }
        
        set {
            knobBackgroundColor = newValue
            updateLayer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateLayer()
    }
    
    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        updateLayer()
    }
    
    fileprivate func updateLayer() {
        let shapeLayer = layer as! CAShapeLayer
        if let color = knobBackgroundColor {
            shapeLayer.fillColor = isEnabled ? color.cgColor : (color.disabledColor().cgColor)
        }
        else {
            shapeLayer.fillColor = UIColor.clear.cgColor
        }
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = isEnabled ? tintColor.cgColor : (tintColor.disabledColor().cgColor)
        shapeLayer.lineWidth = lineWidth
        
        // Adjust drawing rectangle for line width
        var dx = shapeLayer.lineWidth / 2, dy = shapeLayer.lineWidth / 2
        
        // Draw perfect circle even if view is rectangular
        if bounds.width > bounds.height {
            dx += (bounds.width - bounds.height) / 2
        }
        else if bounds.height > bounds.width {
            dy += (bounds.height - bounds.width) / 2
        }
        let ovalRect = bounds.insetBy(dx: dx, dy: dy)
        shapeLayer.path = UIBezierPath(ovalIn: ovalRect).cgPath
        
        // Adjust for line width to keep tick mark inside circle
        let shortSide = min(bounds.width, bounds.height)
        indicatorLayer.bounds = CGRect(x: 0, y: 0, width: shortSide - 2 * lineWidth, height: shortSide - 2 * lineWidth)
        
        updateIndicator()
        
        indicatorLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        indicatorLayer.lineWidth = shapeLayer.lineWidth
        indicatorLayer.strokeColor = shapeLayer.strokeColor
        indicatorLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.addSublayer(indicatorLayer)
    }
    
    /**
     * Draw value indicator, usually in response to the value changing.
     */
    fileprivate func updateIndicator() {
        let linePath = UIBezierPath()
        
        // Adjust the angle to be in the counterclockwise direction from the positive
        // x-axis to accomodate the standard parametric equations for a circle used below.
        let t = 5 / 2 * Double.pi - angle
        let center = indicatorLayer.bounds.center
        
        let x1 = center.x + (indicatorLayer.bounds.width / 2) * CGFloat(cos(t))
        let y1 = center.y - (indicatorLayer.bounds.height / 2) * CGFloat(sin(t))
        linePath.move(to: CGPoint(x:x1, y:y1))

        let x2 = center.x + (indicatorLayer.bounds.width / 3) * CGFloat(cos(t))
        let y2 = center.y - (indicatorLayer.bounds.height / 3) * CGFloat(sin(t))
        linePath.addLine(to: CGPoint(x:x2, y:y2))
        
        indicatorLayer.path = linePath.cgPath
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        lastVector = touch.location(in: self) - bounds.center
        return true
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // Calculate vector from center to touch.
        let vector = touch.location(in: self) - bounds.center
        
        // Add angular difference to our current value.
        angle = (angle + vector.angleFromVector(lastVector)).truncatingRemainder(dividingBy: (2 * Double.pi))
        
        lastVector = vector
        updateIndicator()
        
        sendActions(for: UIControlEvents.valueChanged)
        
        return true
    }
    
    open override class var layerClass : AnyClass {
        return CAShapeLayer.self
    }
}
