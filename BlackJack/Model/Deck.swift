//
//  Deck.swift
//  BlackJack
//
//  Created by Huseyin on 12/01/2024.
//

import Foundation


struct Deck: Decodable {
    let success: Bool
    let deck_id: String
    let cards: [Card]?
    let remaining: Int
    let shuffled: Bool?
}

struct Card: Decodable {
    let code: String
    let image: String
    let images: Images
    let value: String
    let suit: String
}

struct Images: Decodable {
    let svg: String
    let png: String
}
