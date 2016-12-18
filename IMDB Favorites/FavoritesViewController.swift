//
//  FirstViewController.swift
//  IMDB Favorites
//
//  Created by Olav on 03/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import UIKit
import CoreData
import SugarRecord

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var headerView: UIView!
    var averageLabel: UILabel!
    
    var movies = [Movie]()
    
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
        
        // Add custom tableview for average imdb score
        headerView = UIView()
        averageLabel = UILabel()
        headerView.addSubview(averageLabel)
        self.tableView.tableHeaderView = headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = movies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "\(movie.title) (\(movie.year))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowMovieSegue", sender: movies[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! MovieDetailViewController
        guest.movie = (sender as! Movie)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movies = try! db.fetch(FetchRequest<Movie>())
        
        // Set the average imdb rating
        setAverageScore()
        headerView.sizeToFit()
        self.tableView.tableHeaderView?.sizeToFit()
        
        // If there are no favorites, add info how to add movies
        if movies.count == 0 {
            
            // Create an UILabel for showing info on no results
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No movie favorite yet. \n\n1. Go to search \n2. Enter a title and click search. \n3. Click a movie to add it. \n4. Click it again to remove it."
            noDataLabel.textColor = UIColor.blue
            
            // Make label multiline and automatically wrap by word
            noDataLabel.textAlignment = NSTextAlignment.left
            noDataLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            noDataLabel.numberOfLines = 0
            
            // Set the label to the background view
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = .none
            tableView.separatorStyle = .singleLine
        }
        
        tableView.reloadData()
    }
    
    // Set the average imdb rating
    func setAverageScore() {
        let avgString = "Gjennomsnitt i IMDB: "
        let sum = movies.reduce(0.0) {$0 + ($1.rating)}
        if sum == 0 {
            averageLabel.text = "\(avgString)-"
        } else {
            let average = sum / Double(movies.count)
            averageLabel.text = "\(avgString)\(average)"
        }
        averageLabel.sizeToFit()
    }

}

