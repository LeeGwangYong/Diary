//
//  CompletionViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 23..
//  Copyright © 2018년 이광용. All rights reserved.
//
import UIKit
import Lottie

class CompletionViewController: UIViewController {

/*
     이전 ViewController에서 delegate = self를 통해 자신을 넘겨야함.
*/

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    var titleString: String?
    var subTitleText: String?
    var delegate: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subTitleLabel.text = ""
        if let title = self.titleString {
            self.titleLabel.text = title
        }
        if let subTitle = self.subTitleText {
            self.subTitleLabel.text = subTitle
        }
        
        let animationView: LOTAnimationView? = LOTAnimationView(name: "electric.json")
        animationView?.frame = self.view.frame
        animationView?.center = self.view.center
        animationView?.contentMode = .scaleAspectFill
        animationView?.loopAnimation = true
        view.addSubview(animationView!)
        animationView?.play()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: true, completion: {
                self.delegate?.customSegue()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.createGradientLayer()
    }
}
