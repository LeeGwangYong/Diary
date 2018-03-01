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
    let pulseLayer = CAShapeLayer()

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
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.4
        animation.duration = 0.8
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        self.pulseLayer.add(animation, forKey: "pulsing")
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
        let animationView: LOTAnimationView? = LOTAnimationView(name: "electric.json")
        animationView?.frame = self.view.frame
        animationView?.center = self.view.center
        animationView?.contentMode = .scaleAspectFill
        animationView?.loopAnimation = true
        view.addSubview(animationView!)
        animationView?.play()
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 20,
                                        startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        pulseLayer.path = circularPath.cgPath
        pulseLayer.fillColor = UIColor.white.cgColor
        pulseLayer.position = view.center
        pulseLayer.lineWidth = 7
        view.layer.addSublayer(pulseLayer)
        animatePulsatingLayer()
    }
}
