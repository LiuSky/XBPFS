//
//  PFS.swift
//  XBFPS
//
//  Created by xiaobin liu on 2017/12/23.
//  Copyright © 2017年 Sky. All rights reserved.
//  “每秒的帧数(fps)或者说帧率表示图形处理器处理场时每秒钟能够更新的次数。高的帧率可以得到更流畅、更逼真的动画。一般来说30fps就是可以接受的，但是将性能提升至60fps则可以明显提升交”“互感和逼真感，但是一般来说超过75fps一般就不容易察觉到有明显的流畅度提升了。如果帧率超过屏幕刷新率只会浪费图形处理的能力，因为监视器不能以这么快的速度更新，这样超过刷新率的帧率就浪费掉了。”“iOS设备一般的帧率是60fps。”

import Foundation
import UIKit


/// MARK - 协议
@objc public protocol FPSDelegate: class {
    
    /// 当前的刷新率
    @objc optional func fps(fps:FPS, currentFPS: Double)
}


/// MARK - “测量的单位为每秒显示的帧数（Frames Per Second，简称FPS）”
open class FPS: NSObject {
    
    /// 是否启用(默认为True)
    open var isEnable: Bool = true
    
    /// 更新时间
    open var updateInterval: Double = 1.0
    
    /// 回调
    open weak var delegate: FPSDelegate?
    
    /// 初始化
    public override init() {
        super.init()
        
        
        /// UI应用程序将会主动退出通知注册
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FPS.applicationWillResignActiveNotification),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: nil)
        
        /// UI应用程序活跃通知注册
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FPS.applicationDidBecomeActiveNotification),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    
    /// 打开FPS
    open func open() {
        guard self.isEnable == true else {
            return
        }
        self.displayLink.isPaused = false
    }
    
    /// 关闭FPS
    open func close() {
        guard self.isEnable == true else {
            return
        }
        
        self.displayLink.isPaused = true
    }
    
    
    /// MARK - UI应用程序将会主动退出
    @objc private func applicationWillResignActiveNotification() {
        
        guard self.isEnable == true else {
            return
        }
        
        self.displayLink.isPaused = true
    }
    
    /// MARK - UI应用程序活跃
    @objc private func applicationDidBecomeActiveNotification() {
        
        guard self.isEnable == true else {
            return
        }
        self.displayLink.isPaused = false
    }
    
    /// MARK - 显示链接处理
    @objc private func displayLinkHandler() {
        
        if self.lastTime == 0 {
            self.lastTime = self.displayLink.timestamp
            return
        }
        
        /// 记录的是displayLinkHandler()距离上次调用刷新了多少帧，如果界面不卡顿，帧率正常，一般这个值都是1
        self.count += self.displayLink.frameInterval
        
        /// 时间差
        let interval = self.displayLink.timestamp - self.lastTime
        
        /// 如果时间不足刷新时间的话，重复的计算直到为刷新的时间
        guard interval >= self.updateInterval else {
            return
        }
        
        /// 更新起始时间戳
        self.lastTime = self.displayLink.timestamp
        
        /// 计算xx时间内刷新了多少帧
        let fps = Double(self.count) / interval
        
        /// 重置
        self.count = 0
        
        /// 回调
        self.delegate?.fps?(fps: self, currentFPS: round(fps))
    }
    
    /// MARK - CADisplayLink 初始化
    private lazy var displayLink: CADisplayLink = { [unowned self] in
        
        /// CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器
        let new = CADisplayLink(target: self, selector: #selector(FPS.displayLinkHandler))
        new.isPaused = true
        new.add(to: RunLoop.main, forMode: .commonModes)
        return new
    }()
    
    /// 记录一定时间内总共刷新了多少帧
    private var count:Int = 0
    
    /// 最后记录的时间戳
    private var lastTime: CFTimeInterval = 0.0
}
