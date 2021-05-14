//
//  SearchList.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/16/21.
//

import Foundation

public class SearchList: ObservableObject
{
    @Published var search: [ASearch] = []
    @Published var noResults: Bool = false
    
    public func addToSearch (item: ASearch)
    {
        search.append(item)
    }
    
    public func clearSearch ()
    {
        search = []
    }
}
