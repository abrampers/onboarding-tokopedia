import UIKit

extension UIScrollView {
    public func scrollToBottomAnimated(_ animated: Bool) {
        if contentSize.height > bounds.size.height {
            let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + self.contentInset.bottom)
            setContentOffset(bottomOffset, animated: animated)
        }
    }
    
    @objc public func scrollToTop() {
        self.scrollToTop(animated: true)
    }
    
    public func scrollToTop(animated: Bool) {
        let inset = self.contentInset
        self.setContentOffset(CGPoint(x: -inset.left, y: -inset.top), animated: animated)
    }
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    public func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            
            self.scrollRectToVisible(CGRect(x: 0.0, y: childStartPoint.y, width: 1.0, height: self.frame.height), animated: animated)
        }
    }
    
    public func scrollIsAtBottom() -> Bool {
        let height = frame.size.height
        let contentYoffset = contentOffset.y
        let distanceFromBottom = contentSize.height - contentYoffset
        return distanceFromBottom <= height
    }
}
