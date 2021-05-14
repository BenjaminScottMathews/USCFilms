//
//  SearchView.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/15/21.
//

import SwiftUI

struct SearchView: View
{
    @State private var searchText : String = ""
    
    @ObservedObject var searchResults: SearchList
    @ObservedObject var watchlist: WatchList
    
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                HStack
                {
                    SearchBar(list: searchResults, text: $searchText)
                }
                
                if (searchResults.noResults)
                {
                    Text("No Results")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .padding()
                }
                
                /* SEARCH RESULT DISPLAY */
                Group
                {
                    ScrollView
                    {
                        VStack (spacing: 20)
                        {
                            ForEach(searchResults.search)
                            {
                                result in
                                    
                                NavigationLink(destination: DetailView(detailStr: "/" + result.type + "/" + result.id, watchlist: watchlist))
                                {
                                    result.poster
                                        //.resizable()
                                        .cornerRadius(20)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width/1.1)
                                        .overlay(OLTitleView(title: result.title), alignment: .bottomLeading)
                                        .overlay(OLRatingView(rating: result.rating), alignment: .topTrailing)
                                        .overlay(OLTypeYearView(type: result.type, year: result.date), alignment: .topLeading)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Search")
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchResults: SearchList(), watchlist: WatchList())
    }
}

/* SERACH BAR WRAPPER */
struct SearchBar: UIViewRepresentable {

    @ObservedObject var list: SearchList
    @Binding var text: String
    //var placeholder: String
    
    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
        @ObservedObject var list: SearchList
        
        let debouncer = Debouncer(delay: 0.5)
        var value = 0

        init(text: Binding<String>, searchList: SearchList) {
            _text = text
            list = searchList
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            list.clearSearch()
            list.noResults = false
            if (searchText.count >= 3)
            {
                debouncer.run(action:
                                { Search().get_search(keyword: searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
                                {
                                    result in
                                    for r in result!
                                    {
                                        self.list.addToSearch(item: r)
                                    }
                                    
                                    if (self.list.search.count == 0)
                                    {
                                        self.list.noResults = true
                                    }
                                }
                                })
            }
            text = searchText
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
        {
           searchBar.setShowsCancelButton(true, animated: true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
        {
            text = ""
            list.clearSearch()
            list.noResults = false;
            searchBar.endEditing(true)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator
    {
        return Coordinator(text: $text, searchList: list)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search Movies, TVs..."
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
   
}


