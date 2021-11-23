//
//  LaunchViewController.swift
//  Git client
//
//  Created by Ruslan Bagautdinov on 22.11.2021.
//

import UIKit
import Lottie


final class LottieViewController: UIViewController {

    @IBOutlet private weak var lottieConstraint: NSLayoutConstraint!
    @IBOutlet private weak var logoConstraint: NSLayoutConstraint!
    @IBOutlet private weak var gitView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lottieMove()
        logoMove()
        lottieAnime()
    }
}

private extension LottieViewController {
    //MARK: - Lottie moving
    func lottieMove() {
        UIView.animate(
            withDuration: 3,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 4,
            options: [],
            animations: { [weak self] in
                self?.lottieConstraint.constant = 140
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    func lottieAnime() {
        gitView.animation = Animation.named("gitlogo")
        gitView.play(fromProgress: 0,
                     toProgress: 2,
                     loopMode: .repeat(2.0),
                     completion: { (finished) in
            if finished {
                self.moveToAuth()
            } else {
                print("Animation cancelled")
            }
        })
    }
    
    //MARK: - Logo moving
    func logoMove() {
        UIView.animate(
            withDuration: 3,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 4,
            options: [],
            animations: { [weak self] in
                self?.logoConstraint.constant = 340
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    //MARK: Move to Auth
    func moveToAuth() {
        let authVC = self.storyboard?.instantiateViewController(withIdentifier: "authVC") as! AuthViewController
        authVC.modalPresentationStyle = .fullScreen
        self.present(authVC, animated: true)
    }
}
