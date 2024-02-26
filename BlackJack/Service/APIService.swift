//
//  APIService.swift
//  BlackJack
//
//  Created by Huseyin on 20/02/2024.
//

import Foundation

class APIService {
    
    var deckId = "sl3h5nixvdlr"
    let urlString = "https://www.deckofcardsapi.com/api/deck/"
    
    func newDeck() {
    }
    
    func changeTheDeck() {
        let urlStr = urlString + "/new"
        
        let url = URL(string: urlStr)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
            } else if let data = data {
                let newDeck = try? JSONDecoder().decode(Deck.self, from: data)
                
                
                if let deckId = newDeck?.deck_id {
                    self.deckId = deckId
                }
                
            }
        }
    }
    
    //Su anda sadece bunu kullaniyorum
    func getCard(numberOfCards: Int, completion: @escaping (Result<[Card], Error>) -> Void) {
        //let url = URL(string: "https://www.deckofcardsapi.com/api/deck/tovc0ji7c5ao/draw/?count=\(numberOfCards)")!
        let urlStr = urlString + deckId + "/draw/?count=\(numberOfCards)"
        let url = URL(string: urlStr)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error)
            } else if let data = data {
                
                do {
                    
                    let deck = try JSONDecoder().decode(Deck.self, from: data)
                    
                    if let cards = deck.cards {
                        completion(.success(cards))
                    }
                    
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}
