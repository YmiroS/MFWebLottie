//
//  ViewController.swift
//  MFWebLottie
//
//  Created by 杨烁 on 2018/11/28.
//  Copyright © 2018 杨烁. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aview.frame = CGRect.init(x: 0, y: 0, width: 375, height: 200)
        self.view.addSubview(aview)
    }
    
    lazy var aview:MFWebLOTAnimationView = {
       let view = MFWebLOTAnimationView.init(fileName: "zucistar_data",
                                             mfWebLottieRefreshCached: true)
        view.play()
        view.loopAnimation = true
        return view
    }()
    
}

