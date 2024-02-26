//
//  GameViewModel.swift
//  BlackJack
//
//  Created by Huseyin on 20/02/2024.
//

import Foundation

class GameViewModel {
    
    var dealersHand: [Card] = []
    var playersHand: [Card] = []
    
    var isDealerHandDisplayed = false
    
    var playersHandValue = 0
    var dealersHandValue = 0
    
    var didPlayerWin = false

    func resetTheGame() {
        didPlayerWin = false
        playersHandValue = 0
        dealersHandValue = 0
        dealersHand.removeAll()
        playersHand.removeAll()
        isDealerHandDisplayed = false
    }
    
    func newBet(completion: @escaping () -> Void) {
        
        APIService().getCard(numberOfCards: 4) { result in
            switch result {
            case .success(let cards):
                
                //Adding cards to the stack
                self.dealersHand.append(cards[0])
                self.dealersHand.append(cards[1])
                
                self.playersHand.append(cards[2])
                self.playersHand.append(cards[3])
                
                //Calculate the value of cards
                self.calculatePlayersHand()
                self.calculateDealersHand()
                
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func hit(completion: @escaping() -> Void) {
        APIService().getCard(numberOfCards: 1) { result in
            switch result {
            case .success(let cards):
                
                self.playersHand.append(cards[0])
                
                let value = Int(cards[0].value) ?? 10
                self.playersHandValue += value
                
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
        //Bu fonksiyon iyilestirilebilir belki idk?
    func calculateDealersHandValueAfterStandPressed() {
        dealersHandValue = 0
        
        for card in dealersHand {
            let cardValue = Int(card.value) ?? 10
            dealersHandValue += cardValue
        }
    }
    
    func getCardForDealer() {
        APIService().getCard(numberOfCards: 1) { result in
            switch result {
            case .success(let cards):
                let card = cards[0]
                
                self.dealersHand.append(card)
                   
            case.failure(_):
                print("e")
            }
        }
        
    }
    
    //MARK: - Calculation
    
    private func calculatePlayersHand() {
        for card in playersHand {
            let value = Int(card.value) ?? 10
            playersHandValue += value
        }
    }
    
    private func calculateDealersHand() {
        let value = Int(dealersHand[0].value) ?? 10
        dealersHandValue += value
    }
    
    
    //MARK: - Win or Lose
    func checkTheSituation() {
        
        if playersHandValue > 21 {
            didPlayerWin = false
        } else if dealersHandValue > 21 {
            didPlayerWin = true
        } else if dealersHandValue < 21 && dealersHandValue > playersHandValue {
            didPlayerWin = false
        } else if dealersHandValue < 21 && playersHandValue > dealersHandValue {
            didPlayerWin = true
        } else if dealersHandValue == playersHandValue {
            print("Beraberlik")
        }
    }
}
