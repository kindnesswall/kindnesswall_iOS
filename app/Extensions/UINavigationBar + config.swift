//
//  UINavigationBar + config.swift
//  app
//
//  Created by AmirHossein on 3/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setDefaultStyle() {
        self.tintColor=AppColor.Tint
        self.titleTextAttributes=[NSAttributedString.Key.font: AppFont.get(.iranSansBold, size: 17), NSAttributedString.Key.foregroundColor: AppColor.Tint]

    }
}
