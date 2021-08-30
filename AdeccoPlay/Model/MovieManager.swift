//
//  MovieManager.swift
//  AdeccoPlay
//
//  Created by Camilo Moreno on 28/08/21.
//

import Foundation


protocol MovieManagerDelegate{
    func didUpdateMovie(_ movieManager: MovieManager, movies: [MovieModel])
    func didFailWithError(error: Error)
}


struct MovieManager {
    
    //URL de la API de las peliculas más populares
    let movieURL = "https://api.themoviedb.org/3/movie/popular?api_key=14a61ff3663ade41ede0180dce244de8"
    
    var delegate: MovieManagerDelegate?
    
    func performRequest(){
        //1. Crear la URL
        if let url = URL(string: movieURL) {
            //2. Crear una URLSession
            let session = URLSession(configuration: .default)
            
            //3. Darle a la sesion una tarea
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let movie = parseJSON(movieData: safeData){
                        delegate?.didUpdateMovie(self, movies: movie)
                    }
                }
            }
            //4. Comenzar la tarea
            task.resume()
        }
    }
    
    func parseJSON(movieData: Data) -> [MovieModel]?{
        var movies: [MovieModel] = []
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            let numberOfMovies = decodedData.results.count
            for movie in 0..<numberOfMovies {
                let id = decodedData.results[movie].id
                let name = decodedData.results[movie].title
                let imageLink = decodedData.results[movie].poster_path
                let overview = decodedData.results[movie].overview
                let backdropImage = decodedData.results[movie].backdrop_path
                let newMovie = MovieModel(id: id, imageLink: imageLink, title: name, imageBackdrop: backdropImage, overview: overview)
                movies.append(newMovie)
            }
            return movies
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    

    
}

