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
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
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
        UIApplication.shared.statusBarStyle = .lightContent
        self.view.createGradientLayer()
        let animationView: LOTAnimationView? = LOTAnimationView(name: "electric.json")
        animationView?.frame = self.view.frame
        animationView?.center = self.view.center
        animationView?.contentMode = .scaleAspectFill
        animationView?.loopAnimation = true
        self.view.addSubview(animationView!)
        animationView?.play()
        
        imageView.center = self.view.center
        imageView.image = #imageLiteral(resourceName: "innerCircle")
        self.view.addSubview(imageView)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse],
                                   animations: {
                                    self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
}
