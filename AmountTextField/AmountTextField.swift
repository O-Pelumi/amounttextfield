//
//  AmountField.swift
//  AmountField
//
//  Created by Oluwapelumi on 3/21/20.
//  Copyright © 2020 Oluwapelumi. All rights reserved.
//

import UIKit
import AudioToolbox

class AmountTextField: UITextField {
    
    private var formatter = NumberFormatter()
    
    var decimalAmount: Decimal {
        get {
            Decimal(UInt64(self.text ?? "0") ?? 0)
        }
    }
    
    var formattedAmount: String {
        get {
            var amount =  decimalAmount
            
            if formatter.alwaysShowsDecimalSeparator {
                if formatter.minimumFractionDigits == 2 || formatter.minimumFractionDigits == 0 {
                    amount = amount / 100.0
                } else if formatter.minimumFractionDigits > 0 {
                    amount = amount / pow(10.0, formatter.minimumFractionDigits)
                }
            }
            return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "0.00"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultConfiguration()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        defaultConfiguration()
    }
    
    func defaultConfiguration() {
        self.keyboardType = .numberPad

        self.delegate = self;
        
        formatter.groupingSize = 3;
        formatter.groupingSeparator = ",";
        formatter.usesGroupingSeparator = true;
        
        formatter.alwaysShowsDecimalSeparator = true;
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 2;
        formatter.decimalSeparator = ".";
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect()
    }
    
    override func drawText(in rect: CGRect) {
        var insetRect = rect
        if let font = self.defaultTextAttributes[.font] as? UIFont {
            insetRect = rect.insetBy(dx: 0, dy: (rect.size.height - font.lineHeight) * 0.5)
        }
        formattedAmount.draw(in: insetRect, withAttributes: self.defaultTextAttributes)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

}

extension AmountTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if !(range.location < 12 || string.isEmpty) {
            AudioServicesPlaySystemSound(SystemSoundID(1107))
            return false
        } else if (self.text?.isEmpty ?? true) && string == "0" {
            return false
        }
        
        return true
    }
}
