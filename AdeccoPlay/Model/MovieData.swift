//
//  MovieData.swift
//  AdeccoPlay
//
//  Created by Camilo Moreno on 28/08/21.
//

import Foundation


//Estructuras para obtener los datos de la API

struct MovieData: Decodable {
 
    let results: [ResultMovie]
    
}

struct ResultMovie: Decodable{
    let id: Int
    let poster_path: String
    let title: String
    let overview: String
    let backdrop_path: String
}
