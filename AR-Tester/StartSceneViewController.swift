//
//  StartSceneViewController.swift
//  AR-Tester
//
//  Created by Peter Savchenko on 03/09/2017.
//  Copyright © 2017 Peter Savchenko. All rights reserved.
//

import UIKit

class StartSceneViewController: UIViewController {
    @IBOutlet var activeField: UITextField!
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            scrollView.configure(with: .defaultConfiguration)
        }
    }

  @IBOutlet var bottomConstraint: NSLayoutConstraint!

  @IBAction func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  override func viewDidLoad() {
        super.viewDidLoad()
        activeField.delegate = self
        keyboardDelegate = self
    }

    override func viewDidLayoutSubviews() {
        // Add border bottom to text field
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red: 0.31, green: 0.53, blue: 0.86, alpha: 1.0).cgColor
        // border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: activeField.frame.size.height - width,
                              width: activeField.frame.size.width, height: activeField.frame.size.height)

        border.borderWidth = width
        activeField.layer.addSublayer(border)
        activeField.layer.masksToBounds = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goCameraSegue" {
            if let cameraController = segue.destination as? CameraController {
                cameraController.enteredURL = activeField.text!
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "goCameraSegue", sender: self)
        return false
    }
}

extension StartSceneViewController: KeyboardHandlerDelegate {
    func keyboardStateChanged(input: UIView?, state: KeyboardState, info: KeyboardInfo) {
        var indicatorInsets = scrollView.scrollIndicatorInsets

        switch state {
        case .frameChanged, .opened:
            let scrollViewBottomInset = info.endFrame.height
            scrollView.contentInset.bottom = scrollViewBottomInset
            indicatorInsets.bottom = info.endFrame.height
        case .hidden:
            let point = CGPoint(x: 0, y: 0)
            scrollView.setContentOffset(point, animated: true)
            indicatorInsets.bottom = 0
        }
    }
}
