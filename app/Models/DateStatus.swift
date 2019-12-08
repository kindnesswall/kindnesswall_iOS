//
//  DateStatus.swift
//  app
//
//  Created by AmirHossein on 2/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class DateStatus: Codable {
    var title: String?
    var id: Int?

    init(id: Int?, title: String?) {
        self.id=id
        self.title=title
    }

}
