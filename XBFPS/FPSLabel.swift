//
//  FPSLabel.swift
//  XBFPS
//
//  Created by xiaobin liu on 2017/12/23.
//  Copyright © 2017年 Sky. All rights reserved.
//

import UIKit

/// MARK - PFS标签
final class FPSLabel: UILabel, FPSDelegate {

    /// pfs
    private lazy var fps = FPS()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textAlignment = .center
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.fps.delegate = self
    }
    
    /// MARK - FPSDelegate
    func fps(fps: FPS, currentFPS: Double) {
        
        let color = UIColor(hue: CGFloat(0.27 * (currentFPS - 0.2)), saturation: 1, brightness: 0.9, alpha: 1)
        let mutableAttributedString = NSMutableAttributedString(string: "\(Int(currentFPS)) FPS")
        mutableAttributedString.setAttributes([NSAttributedStringKey.foregroundColor : color], range: NSMakeRange(0, mutableAttributedString.length - 3))
        mutableAttributedString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], range: NSMakeRange(mutableAttributedString.length - 3, 3))
        self.font = UIFont(name: "Menlo", size: 14)
        mutableAttributedString.setAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 4) as Any], range: NSMakeRange(mutableAttributedString.length - 4, 1))
        self.attributedText = mutableAttributedString;
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 55, height: 20))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
