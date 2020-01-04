//
//  SearchTextField.swift
//  Doushi
//
//  Created by Suraj Sau on 04/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    
    override var textInputMode: UITextInputMode? {
        for textInputMethod in UITextInputMode.activeInputModes {
            if textInputMethod.primaryLanguage!.contains("ja-JP") {
                return textInputMethod
            }
        }
        
        return super.textInputMode
    }

}
