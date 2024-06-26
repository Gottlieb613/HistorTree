//
//  ViewController.swift
//  Onitama
//
//  Created by Charlie Gottlieb on 6/6/24.
//


//NEXT TODO:
// 'Restart' button
// Move to other git.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var colorBar: UIView!
    @IBOutlet weak var card0: UIImageView!
    @IBOutlet weak var card1: UIImageView!
    @IBOutlet weak var card3: UIImageView!
    @IBOutlet weak var card4: UIImageView!
    @IBOutlet weak var topNext: UIImageView!
    @IBOutlet weak var bottomNext: UIImageView!
    
    var p0Score = 0
    var p1Score = 0
    
    var selectedItem: BoardItem = BoardItem(indexPath: IndexPath.init(item: 5, section: 5), tile: Tile.Empty, sensei: false)
    var selectedItemRow = -1
    var selectedItemCol = -1
    var (selectedCard, cardList) = makeCardList()
    var selectedCardNum = 0
    var legalTiles: [(Int, Int)] = []
    
//    @IBOutlet weak var card0: UIButton!
//    @IBOutlet weak var card1: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetBoard()
        setCellWidthHeight()
        
        refreshImages()
        
        card0.isUserInteractionEnabled = true
        card1.isUserInteractionEnabled = true
        card3.isUserInteractionEnabled = true
        card4.isUserInteractionEnabled = true
        
        let card0TapGesture = UITapGestureRecognizer(target: self, action: #selector(card0Tapped))
        let card1TapGesture = UITapGestureRecognizer(target: self, action: #selector(card1Tapped))
        let card3TapGesture = UITapGestureRecognizer(target: self, action: #selector(card3Tapped))
        let card4TapGesture = UITapGestureRecognizer(target: self, action: #selector(card4Tapped))
        card0.addGestureRecognizer(card0TapGesture)
        card1.addGestureRecognizer(card1TapGesture)
        card3.addGestureRecognizer(card3TapGesture)
        card4.addGestureRecognizer(card4TapGesture)
        
        highlightSelectedCard()
    }
    
    func setCellWidthHeight() {
        let width = collectionView.frame.size.width / 6
        let height = collectionView.frame.size.height / 5
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func numberOfSections(in cv: UICollectionView) -> Int {
        return board.count
    }
    
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return board[section].count
    }
    
  // ---- COLLECTION VIEW ----

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "idCell", for: indexPath) as! BoardCell
        
        let boardItem = getBoardItem(indexPath)
        drawCell(cell: cell, boardItem: boardItem, row: indexPath.section, col: indexPath.item)
        
        return cell
    }
    
    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.section
        let col = indexPath.item
        let boardItem = board[row][col]
        
        if (boardItem.tile == currentTurnTile()) {
            print("Piece at r\(row) c\(col)")
            selectedItem = boardItem
            selectedItemRow = row
            selectedItemCol = col
            
            setLegalTiles()
            
        } else {
            if let cell = collectionView.cellForItem(at: boardItem.indexPath) as? BoardCell { // selected spot
                if legalTiles.contains(where: { $0 == (row, col) }) {
                    //--move is legal
                    print("Place: r\(row) c\(col)")
                    
                    // Check win
                    if board[row][col].senseiTile() ||
                        (selectedItem.senseiTile() && col == 2 && ((row == 0 && selectedItem.p0Tile()) || (row == 4 && selectedItem.p1Tile())) ) {
                        
                        //still want to move piece so looks good
                        placePiece(cell: cell, piece: selectedItem, origRow: selectedItemRow, origCol: selectedItemCol, newRow: row, newCol: col)
        
                        let oldCell = collectionView.cellForItem(at: selectedItem.indexPath) as! BoardCell
                        
                        oldCell.image.tintColor = UIColor.white
                        oldCell.image.image = UIImage(systemName: "circle.fill")
                        
                        if p0Turn() {
                            p0Score += 1
                        } else {
                            p1Score += 1
                        }
                        
                        resultAlert(currentTurnVictoryMessage())
                        
                    // No win
                    } else {
                        placePiece(cell: cell, piece: selectedItem, origRow: selectedItemRow, origCol: selectedItemCol, newRow: row, newCol: col)
        
                        let oldCell = collectionView.cellForItem(at: selectedItem.indexPath) as! BoardCell
                        
                        oldCell.image.tintColor = UIColor.white
                        oldCell.image.image = UIImage(systemName: "circle.fill")
                        
                        swapCards(cardList: &cardList, selection: selectedCardNum)
                        toggleTurn(colorBar)
                        
                        selectedCardNum = p0Turn() ? 0 : 4
                        selectedCard = cardList[selectedCardNum]
                        
                        selectedItemRow = -1
                        selectedItemCol = -1
                        legalTiles = []
                    }
                }
            }
        }
        collectionView.reloadData()
        refreshImages()
    }
    
    func drawCell(cell: BoardCell, boardItem: BoardItem, row: Int, col: Int) {
        cell.image.tintColor = boardItem.tileColor()
        cell.image.image = boardItem.sensei ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle.fill")
        
        if (row == selectedItemRow && col == selectedItemCol) {
            cell.backgroundColor = .systemRed
            
        } else if legalTiles.contains(where: { $0 == (row, col) }) {
            cell.backgroundColor = .systemOrange
            
        } else {
            cell.backgroundColor = .clear
        }
        
    }
    
  // ---- CARD BUTTONS -----
    
    @objc func card0Tapped() {
        // Handle tap action here
        if p0Turn() {
            selectedCard = cardList[0]
            selectedCardNum = 0
            print("card0: \(selectedCard)")
        }
        highlightSelectedCard()
        setLegalTiles()
        collectionView.reloadData()
    }
    
    @objc func card1Tapped() {
        // Handle tap action here
        if p0Turn() {
            selectedCard = cardList[1]
            selectedCardNum = 1
            print("card1: \(selectedCard)")
        }
        highlightSelectedCard()
        setLegalTiles()
        collectionView.reloadData()
    }
    
    @objc func card3Tapped() {
        // Handle tap action here
        if !p0Turn() {
            selectedCard = cardList[3]
            selectedCardNum = 3
            print("card3: \(selectedCard)")
        }
        highlightSelectedCard()
        setLegalTiles()
        collectionView.reloadData()
    }
    
    @objc func card4Tapped() {
        // Handle tap action here
        if !p0Turn() {
            selectedCard = cardList[4]
            selectedCardNum = 4
            print("card4: \(selectedCard)")
            refreshImages()
        }
        highlightSelectedCard()
        setLegalTiles()
        collectionView.reloadData()
    }
    
    
    func resultAlert(_ title: String) {
        let message = "\nPlayer 0: \(p0Score)\n\nPlayer1: \(p1Score)"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: {
            [self] (_) in
            resetBoard()
            self.resetCells()
            resetCards()
            toggleTurn(colorBar) // losing player should start next game
        }))
        self.present(ac, animated: true)
    }
    
    func resetCells() {
        for row in 0...4 {
            for col in 0...4 {
                let boardItem = board[row][col]
                if let cell = collectionView.cellForItem(at: boardItem.indexPath) as? BoardCell {
                    drawCell(cell: cell, boardItem: boardItem, row: -1, col: -1)
                }
            }
        }
        selectedItemRow = -1
        selectedItemCol = -1
    }
    
    
    func refreshImages() {
//        card0.setImage(UIImage(named: "\(cardList[0])"), for: .normal)
//        card1.setImage(UIImage(named: "\(cardList[1])"), for: .normal)
        
        card0.image = UIImage(named: "\(cardList[0])")
        card1.image = UIImage(named: "\(cardList[1])")
        card3.image = UIImage(named: "\(cardList[3])")
        card3.transform = CGAffineTransform(rotationAngle: .pi)
        card4.image = UIImage(named: "\(cardList[4])")
        card4.transform = CGAffineTransform(rotationAngle: .pi)
        
        if (p0Turn()) {
            bottomNext.image = UIImage(named: "\(cardList[2])")
            topNext.image = UIImage(systemName: ".rectangle")
            topNext.tintColor = .black
        } else  {
            topNext.image = UIImage(named: "\(cardList[2])")
            bottomNext.image = UIImage(systemName: ".rectangle")
            bottomNext.tintColor = .black
            topNext.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        highlightSelectedCard()
    }
    
    func setLegalTiles() {
        if selectedItemRow != -1 && selectedItemCol != -1 {
            legalTiles = selectedCard.getLegalTiles(board, pieceRow: selectedItemRow, pieceCol: selectedItemCol)
        }
    }
    
    func highlightSelectedCard() {
        switch selectedCardNum {
            case 0:
                card0.backgroundColor = .systemTeal
                card1.backgroundColor = .clear
                card3.backgroundColor = .clear
                card4.backgroundColor = .clear
            case 1:
                card0.backgroundColor = .clear
                card1.backgroundColor = .systemTeal
                card3.backgroundColor = .clear
                card4.backgroundColor = .clear
            case 3:
                card0.backgroundColor = .clear
                card1.backgroundColor = .clear
                card3.backgroundColor = .systemTeal
                card4.backgroundColor = .clear
            case 4:
                card0.backgroundColor = .clear
                card1.backgroundColor = .clear
                card3.backgroundColor = .clear
                card4.backgroundColor = .systemTeal
            default:
                card0.backgroundColor = .clear
                card1.backgroundColor = .clear
                card3.backgroundColor = .clear
                card4.backgroundColor = .clear
        }
    }
    
    func resetCards() {
        legalTiles = []
        (selectedCard, cardList) = makeCardList()
        refreshImages()
    }

}

