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
        cell.textLabel?.text = movies[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test: \(indexPath.row)")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let title = searchController.searchBar.text {
            movies = parseJSON(title: title)
        }
        tableView.reloadData()
    }
    
    func parseJSON(title: String) -> [Movie] {
        return parseJSON(url: "http://www.omdbapi.com/?s=\(title)&y=&plot=short&r=json")
    }
    
    func parseJSON(url: String) -> [Movie] {
        do {
            var path = URL(string: url)!
            var imdbId : String
            
            var jsonData = try Data(contentsOf: path)
            var readableJSON = JSON(data: jsonData)["Search"]
            
            // Replace elements with more data from api
            for (index, jsonMovie) in readableJSON {
                imdbId = jsonMovie["imdbId"].stringValue
                path = URL(string: "http://www.omdbapi.com/?i=\(imdbId)")!
                try jsonData = Data(contentsOf: path)
                readableJSON[index] = JSON(data: jsonData)
            }
            
            return jsonToMovies(readableJSON: readableJSON)
        } catch {
            // TODO: Error handling
            print("Some JSON error occurred")
            return [Movie]()
        }
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
