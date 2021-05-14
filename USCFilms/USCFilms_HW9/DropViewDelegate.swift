//
//  DropViewDelegate.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/13/21.
//

import SwiftUI

struct DropViewDelegate: DropDelegate
{
    var med: Media
    var mediaData: WatchList
    
    func performDrop(info: DropInfo) -> Bool
    {
        mediaData.currentDrag = nil
        mediaData.alterDefaults()
        return true
    }
    
    func dropEntered(info: DropInfo)
    {
        if mediaData.currentDrag == nil
        {
            mediaData.currentDrag = med
            
        }
        
        let fromIndex = mediaData.watchlist.firstIndex { (med) -> Bool in
            return med.id == mediaData.currentDrag?.id
        } ?? 0
        
        let toIndex = mediaData.watchlist.firstIndex { (med) -> Bool in
            return med.id == self.med.id
        } ?? 0
        
        if fromIndex != toIndex
        {
            withAnimation(.default)
            {
                let fromMed = mediaData.watchlist[fromIndex]
                mediaData.watchlist[fromIndex] = mediaData.watchlist[toIndex]
                mediaData.watchlist[toIndex] = fromMed
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal?
    {
        return DropProposal(operation: .move)
    }
    
}
