//
//  formattests.swift
//  formattests
//
//  Created by Noah Kamara on 17.09.21.
//

import Foundation

class FormatTests {
    func test(param1 _: String, param2: Int, param3 _: URL, param4 _: String, param5 _: String, param6 _: String, param7 _: String) {
        let a = String(describing: param2)

        if true, false, false {
            print("FALSE")
        }

        test2(param1: "", param2: "", param3: "", param4: "", param5: "", param6: "", param7: "", param8: "", param9: "", param0: "")
    }

    func test2(
        param1 _: String,
        param2 _: String,
        param3 _: String,
        param4 _: String,
        param5 _: String,
        param6 _: String,
        param7 _: String,
        param8 _: String,
        param9 _: String,
        param0 _: String
    ) {}
}
