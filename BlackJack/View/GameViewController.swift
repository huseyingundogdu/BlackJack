//
//  GameViewController.swift
//  BlackJack
//
//  Created by Huseyin on 12/01/2024.
//

import UIKit

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var dealersHandStackView: UIStackView!
    @IBOutlet weak var handStackView: UIStackView!
    @IBOutlet weak var cardRemainingLabel: UILabel!
    @IBOutlet weak var dealersHandValueLabel: UILabel!
    @IBOutlet weak var yourHandValueLabel: UILabel!
    
    let gameVM = GameViewModel()
    
    var playerHand: [Card] = []
    var dealerHand: [Card] = []
    
    var playerHandValue = 0
    var dealerHandValue = 0
    
    var standPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        
        hitButton.isEnabled = true
        playButton.isEnabled = false
        standButton.isEnabled = true
        
        gameVM.newBet {
            DispatchQueue.main.async {
                self.dealerHand = self.gameVM.dealersHand
                self.playerHand = self.gameVM.playersHand
                
                self.updateDealersStackView()
                self.updatePlayersStackView()
            }
        }
    }
    
    
    private func updatePlayersStackView() {
        handStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for card in playerHand {
            let cardImageView = UIImageView()
            cardImageView.load(url: URL(string: card.image)!)
    
            addCardToStackView(deckName: "player", cardImageView)
        }
        
        yourHandValueLabel.text = "\(gameVM.playersHandValue)"
    }
    

    private func updateDealersStackView() {

        dealersHandStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, card) in dealerHand.enumerated() {
            let cardImageView = UIImageView()

            if standPressed {
                cardImageView.load(url: URL(string: card.image)!)
            } else if index == 0 {
                cardImageView.load(url: URL(string: card.image)!)
            } else {
                cardImageView.image = UIImage(named: "back")
            }
            
            addCardToStackView(deckName: "dealer", cardImageView)
        }
        
        dealersHandValueLabel.text = "\(gameVM.dealersHandValue)"
        
    }
    
    @IBAction func hitButtonPressed(_ sender: Any) {
        gameVM.hit {
            DispatchQueue.main.async {
                
                self.playerHand = self.gameVM.playersHand
                self.playerHandValue = self.gameVM.playersHandValue
                
                if self.playerHandValue > 21 {
                    self.showTheAlert(title: "Lose", message: "You lose.")
                }
                
                self.updatePlayersStackView()
                
            }
        }
    }
    
    @IBAction func standButtonPressed(_ sender: Any) {
        standPressed = true
        
        gameVM.calculateDealersHandValueAfterStandPressed()
        var dealersHandValue = gameVM.dealersHandValue
        
        updateDealersStackView()
        
        func getCardToDealer() {
            if dealersHandValue < 16 {
                gameVM.getCardForDealer {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        dealersHandValue = self.gameVM.dealersHandValue
                        self.dealerHand = self.gameVM.dealersHand
                        self.updateDealersStackView()
                        getCardToDealer()
                    }
                }
            } else {
                self.gameVM.checkTheSituation()
                
                if self.gameVM.didPlayerWin {
                    self.showTheAlert(title: "Win", message: "You win.")
                } else {
                    self.showTheAlert(title: "Lose", message: "You lose.")
                }
            }
        }
        getCardToDealer()
    }
    
    
    
    private func addCardToStackView(deckName: String, _ cardImageView: UIImageView) {
        cardImageView.contentMode = .scaleAspectFit
        
        if deckName == "player" {
            handStackView.addArrangedSubview(cardImageView)
            handStackView.spacing = -70
        } else if deckName == "dealer" {
            dealersHandStackView.addArrangedSubview(cardImageView)
            dealersHandStackView.spacing = -70
        }
    }
    
    
    private func showTheAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            self.gameVM.resetTheGame()
            
            self.playButton.isEnabled = true
            self.hitButton.isEnabled = false
            self.standButton.isEnabled = false
            
            self.dealerHand.removeAll()
            self.playerHand.removeAll()
            
            self.standPressed = false
            
            self.updateDealersStackView()
            self.updatePlayersStackView()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
