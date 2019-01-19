//
//  ViewController.swift
//  DecodablePractice
//
//  Created by Stephen Dowless on 1/17/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit

struct Pokemon: Decodable {
    let name: String?
    let imageUrl: String?
    let description: String?
    let height: Int?
    let weight: Int?
    let attack: Int?
    let type: String?
    let evolutionChain: [EvolutionChain]?
}

struct EvolutionChain: Decodable {
    let id: String?
    let name: String?
}

class ViewController: UIViewController {
    
    let base_url = "https://pokedex-bb36f.firebaseio.com/pokemon.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    func fetchData() {
        guard let url = URL(string: base_url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fetch data with error: ", error)
                return
            }
            
            guard let data = data?.parseData(removeString: "null,") else { return }
            
            do {
                let pokemon = try JSONDecoder().decode([Pokemon].self, from: data)
                print(pokemon[0].evolutionChain)
            } catch let error {
                print("Failed to create json with error: ", error.localizedDescription)
            }
            
        }.resume()
    }
}

extension Data {
    func parseData(removeString string: String) -> Data? {
        let dataAsString = String(data: self, encoding: .utf8)
        let parsedDataString = dataAsString?.replacingOccurrences(of: string, with: "")
        guard let data = parsedDataString?.data(using: .utf8) else { return nil }
        return data
    }
}

