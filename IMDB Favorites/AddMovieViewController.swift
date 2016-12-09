//
//  SecondViewController.swift
//  IMDB Favorites
//
//  Created by Olav on 03/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import SugarRecord

class AddMovieViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet var movieResult: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var movieSearch : [JSON] = []
    var movieEntities : [Movie] = []
    
    let MOVIE_ID = "imdbID"
    let MOVIE_TITLE = "Title"
    let MOVIE_YEAR = "Year"
    let MOVIE_RATING = "imdbRating"
    let MOVIE_RUNTIME = "Runtime"
    
    lazy var db: CoreDataDefaultStorage = {
        let store = CoreDataStore.named("movie_favorites")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Movie title..."
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieEntities = try! db.fetch(FetchRequest<Movie>())
        tableView.reloadData()
        self.definesPresentationContext = true
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
        return movieSearch.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieJSON = movieSearch[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "\(movieJSON[MOVIE_TITLE]) (\(movieJSON[MOVIE_YEAR]))"
        
        if containsMovieByJSON(movieJSON: movieJSON) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movieSearch[indexPath.row]
        saveOrRemoveMovie(movieJSON: selectedMovie)
        tableView.reloadData()
    }
    
    func saveOrRemoveMovie(movieJSON: JSON) {
        if let movie = getMovieByJSON(movieJSON: movieJSON) {
            deleteMovie(imdbId: movie.id)
        } else {
            let title = movieJSON[MOVIE_ID].stringValue
            let movieJSON = parseJSON(title: title, type: "i")[0]
            saveMovie(readableJSON: movieJSON)
        }
        
        movieEntities = try! db.fetch(FetchRequest<Movie>())
    }
    
    func getMovieByJSON(movieJSON: JSON) -> Movie? {
        for movie in movieEntities {
            if movie.id == movieJSON[MOVIE_ID].string {
                return movie
            }
        }
        return nil
    }
    
    func containsMovieByJSON(movieJSON: JSON) -> Bool {
        return getMovieByJSON(movieJSON: movieJSON) != nil
    }
    
    func saveMovie(readableJSON: JSON) {
        do {
            try db.operation { (context, save) throws -> Void in
                let movie: Movie = try context.create()
                movie.id = readableJSON[self.MOVIE_ID].stringValue
                movie.title = readableJSON[self.MOVIE_TITLE].stringValue
                movie.year = readableJSON[self.MOVIE_YEAR].int16Value	
                movie.rating = readableJSON[self.MOVIE_RATING].doubleValue
                movie.runtime = readableJSON[self.MOVIE_RUNTIME].string!
                movie.seen = nil
                save()
                //self.movieEntities.append(movie)
            }
        }
        catch {
            // TODO: Error handling
        }
    }
    
    func deleteMovie(imdbId: String) {
        do {
            try db.operation { (context, save) throws in
                let movie: Movie? = try context.request(Movie.self).filtered(with: "id", equalTo: imdbId).fetch().first
                if let movie = movie {
                    try context.remove([movie])
                    save()
                    //self.movieEntities.remove(at: self.movieEntities.index(of: movie)!)
                }
            }
        } catch {
            // TODO: Error handling
        }
    }
    
    func updateSearchResults(for searchController: UISearchController){}
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let title = searchController.searchBar.text {
            movieSearch = parseJSON(title: title, type: "s")
        }
        tableView.reloadData()
    }
    
    func parseJSON(title: String, type: String) -> [JSON] {
        let t = title.replacingOccurrences(of: " ", with: "+")
        let json = parseJSON(url: "http://www.omdbapi.com/?\(type)=\(t)&y=&plot=short&r=json")
        if type == "s" {
            return json["Search"].arrayValue
        } else {
            return [json]
        }
    }
    
    func parseJSON(url: String) -> JSON {
        do {
            guard let path = URL(string: url) else {
                return [JSON.null]
            }
            
            let jsonData = try Data(contentsOf: path)
            let readableJSON = JSON(data: jsonData)
            
            return readableJSON
            
            /*
             // Replace elements with more data from api
             var imdbId : String
            for (index, jsonMovie) in readableJSON {
                imdbId = jsonMovie[MOVIE_ID].stringValue
                guard let path = URL(string: "http://www.omdbapi.com/?i=\(imdbId)") else {
                    return movies
                }
                try jsonData = Data(contentsOf: path)
                readableJSON[index] = JSON(data: jsonData)
            }
            
            movies = jsonToMovies(readableJSON: readableJSON)
 
            */
        } catch {
            // TODO: Error handling
            print("Some JSON error occurred")
        }
        
        return [JSON.null]
    }
    
}
