//
//  Person.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/14/21.
//

import Foundation
import Kingfisher

public class Person : Identifiable
{
    var name: String
    var pic: RemoteImage
    
    init()
    {
        name = ""
        pic = RemoteImage(url: "https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg")
    }
    
    init(newName: String, newPic: RemoteImage)
    {
        name = newName
        pic = newPic 
    }
}
