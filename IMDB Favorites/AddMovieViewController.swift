//
//  SecondViewController.swift
//  IMDB Favorites
//
//  Created by Olav on 03/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddMovieViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet var movieResult: UITableView!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var movies : [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Movie title..."
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // End first responders on touches (remove keyboard)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let title = movies[indexPath.row].title
        let year = movies[indexPath.row].year
        cell.textLabel?.text = "\(title) (\(year))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test: \(indexPath.row)")
    }
    
    func updateSearchResults(for searchController: UISearchController){}
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let title = searchController.searchBar.text {
            movies = parseJSON(title: title)
        }
        tableView.reloadData()
    }
    
    func parseJSON(title: String) -> [Movie] {
        let t = title.replacingOccurrences(of: " ", with: "+")
        return parseJSON(url: "http://www.omdbapi.com/?s=\(t)&y=&plot=short&r=json")
    }
    
    func parseJSON(url: String) -> [Movie] {
        movies = [Movie]()
        do {
            guard let path = URL(string: url) else {
                return movies
            }
            var imdbId : String
            
            var jsonData = try Data(contentsOf: path)
            var readableJSON = JSON(data: jsonData)["Search"]
            
            // Replace elements with more data from api
            for (index, jsonMovie) in readableJSON {
                imdbId = jsonMovie["imdbId"].stringValue
                guard let path = URL(string: "http://www.omdbapi.com/?i=\(imdbId)") else {
                    return movies
                }
                try jsonData = Data(contentsOf: path)
                readableJSON[index] = JSON(data: jsonData)
            }
            
            movies = jsonToMovies(readableJSON: readableJSON)
        } catch {
            // TODO: Error handling
            print("Some JSON error occurred")
        }
        
        return movies
    }
    
    func jsonToMovies(readableJSON: JSON) -> Array<Movie> {
        var movies = [Movie]()
        if let jsonArray = readableJSON.array {
            for jsonMovie in jsonArray {
                movies.append(jsonToMovie(readableJSON: jsonMovie))
            }
        }
        return movies
    }
    
    
    func jsonToMovie(readableJSON: JSON) -> Movie {
        let imdbId = readableJSON["imdbId"].stringValue
        let title = readableJSON["Title"].stringValue
        let year = readableJSON["Year"].intValue
        let rating = readableJSON["imdbRating"].doubleValue
        let runtime = readableJSON["runtime"].stringValue
        return Movie(imdbId: imdbId, title: title, year: year, rating: rating, runtime: runtime)
    }
    
}
