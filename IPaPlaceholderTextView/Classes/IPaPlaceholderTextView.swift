//
//  IPaPlaceholderTextView.swift
//  IPaPlaceholderTextView
//
//  Created by IPa Chen on 2015/7/10.
//  Copyright (c) 2015年 A Magic Studio. All rights reserved.
//

import UIKit
import IPaDesignableUI
//@IBDesignable
open class IPaPlaceholderTextView: IPaDesignableTextView {
    
    @IBInspectable open var placeholder:String = ""
        {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable open var placeholderColor:UIColor = UIColor.darkGray
        {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var textChangedObserver:NSObjectProtocol?
    override open func awakeFromNib() {
        super.awakeFromNib()
        addTextChangeObserver()
    }
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func addTextChangeObserver() {
        textChangedObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: self, queue: nil, using: {
            noti in
            self.setNeedsDisplay()
        })
      
    }
    deinit {
        if let textChangedObserver = textChangedObserver {
            NotificationCenter.default.removeObserver(textChangedObserver)
        }
        //        removeObserver(self, forKeyPath: "font")
        //        removeObserver(self, forKeyPath: "text")
        //        removeObserver(self, forKeyPath: "placeholder")
        //        removeObserver(self, forKeyPath: "placeholderColor")
        //        removeObserver(self, forKeyPath: "textContainerInset")
    }
    override open func draw(_ rect: CGRect) {
        //return if hasText
        if self.hasText {
            return
        }
        
        // attr
        var attrs:[String:Any] = [NSForegroundColorAttributeName:self.placeholderColor]
        if let font = self.font {
            attrs[NSFontAttributeName] = font
        }
        
        var placeHolderRect = rect
        //draw text
        placeHolderRect.origin.x = textContainerInset.left + textContainer.lineFragmentPadding
        placeHolderRect.origin.y = textContainerInset.top
        placeHolderRect.size.width = self.bounds.width  - textContainerInset.left - textContainerInset.right - textContainer.lineFragmentPadding - textContainer.lineFragmentPadding
        placeHolderRect.size.height = self.bounds.height - textContainerInset.top - textContainerInset.bottom
        (self.placeholder as NSString).draw(in: placeHolderRect, withAttributes: attrs)
        
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
}
