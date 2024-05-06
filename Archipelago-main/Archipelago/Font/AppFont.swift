//
//  AppFont.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/30/22.
//

import Foundation
import UIKit

enum AppFont {
     static let font = "Archipelagoad-Regular"
}

func changeToAppFont(forButton button: UIButton) {
    let myFont = UIFont(name: AppFont.font, size: button.titleLabel?.font.pointSize ?? 12)
    button.setAttributedTitle(NSAttributedString(string: button.titleLabel?.text ?? "", attributes: [NSAttributedString.Key.font : (myFont ?? .systemFont(ofSize: 12)), NSAttributedString.Key.foregroundColor : UIColor.white]), for: .normal)
}

func changeToAppFont(forLabel label: UILabel) {
    label.font = UIFont(name: AppFont.font, size: label.font.pointSize)
    label.textColor = UIColor.white
}

func changeToAppFont(forTextView myTextView: UITextView) {
    let myFont = UIFont(name: AppFont.font, size: myTextView.font?.pointSize ?? 12)
    myTextView.font = myFont
}
