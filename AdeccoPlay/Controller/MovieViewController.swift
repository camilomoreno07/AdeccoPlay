//
//  ViewController.swift
//  AdeccoPlay
//
//  Created by Camilo Moreno on 28/08/21.
//

import UIKit


class MovieViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieManager = MovieManager()
    
    var movies = [MovieModel]()
    
    var overview: String = ""
    var backdropImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (view.frame.size.width - 10) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 200)
        collectionView.dataSource = self
        collectionView.delegate = self
        movieManager.delegate = self
        movieManager.performRequest()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    //Metodo que envia la información al SummaryViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSummary"{
            let destinationVC = segue.destination as! SummaryViewController
            destinationVC.overview = overview
            destinationVC.imageLink = backdropImage
        }
    }

    
}

//MARK: - UIImageView
extension UIImageView{
    func load(url: URL){
        
        DispatchQueue.global().async {[weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    func downloadedFrom(link:String){
        guard let url = URL(string: link)else {return}
        load(url: url)
    }
}


//MARK: - UICollectionViewDataSource
extension MovieViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        let defaultLink = "https://image.tmdb.org/t/p/w500/"
        let completeLink = defaultLink + movies[indexPath.row].imageLink
        cell.imageView.downloadedFrom(link: completeLink)
        return cell
    }
}

//MARK: - MovieManagerDelegate
extension MovieViewController: MovieManagerDelegate{
    
    func didUpdateMovie(_ movieManager: MovieManager, movies: [MovieModel]) {
        self.movies = movies
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - UICollectionViewDelegate
extension MovieViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        overview = movies[indexPath.row].overview
        backdropImage = movies[indexPath.row].imageBackdrop
        
        self.performSegue(withIdentifier: "goToSummary", sender: self)
        
        
    }
    
}
