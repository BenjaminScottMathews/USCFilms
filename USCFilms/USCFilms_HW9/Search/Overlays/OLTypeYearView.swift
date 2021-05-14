//
//  OLTypeYearView.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/16/21.
//

import SwiftUI

struct OLTypeYearView: View
{
    var type: String
    var year: String
    
    var body: some View
    {
        Text(type.uppercased() + "(" + year + ")")
            .foregroundColor(.white)
            .fontWeight(.bold)
            .font(.system(size: 18))
            .padding()
    }
}

struct OLTypeYearView_Previews: PreviewProvider {
    static var previews: some View {
        OLTypeYearView(type: "Movie", year: "3035")
    }
}
