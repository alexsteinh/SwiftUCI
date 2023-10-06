//
//  Utils.swift
//  
//
//  Created by Alexander Steinhauer on 06.10.23.
//

func buildString(_ initial: String = "", builder: (inout String) -> Void) -> String {
    var string = initial
    builder(&string)
    return initial
}
