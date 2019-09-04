//
//  ViewController.swift
//  CurrencyLayeriOS
//
//  Created by murakami Taichi on 2019/09/04.
//  Copyright © 2019 murakammm. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var amountInputField: UITextField!
    @IBOutlet weak var currencyCollectionView: UICollectionView!

    var viewModel: MainViewModel?
    let disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    
    private func setupUI() {
        let nib = UINib(nibName: "CurrencyCell", bundle: .main)
        currencyCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        currencyCollectionView.delegate = self
        
        amountInputField.delegate = self
    }
    
    private func bindUI() {
        let text = amountInputField.rx.text.orEmpty.asDriver()
        let vm = MainViewModel.init(input: text,
                                    service: CurrencyService.init(list: ListRepository(api: MockListAPI()),
                                                                  live: LiveRepository(api: MockLiveAPI())))
        
        vm.exchange.bind(to: currencyCollectionView.rx.items(cellIdentifier: "cell", cellType: CurrencyCell.self)) { index, exchange, cell in
            cell.set(exchange: exchange)
            cell.isUserInteractionEnabled = false
        }.disposed(by: disposeBag)
        
        vm.quotes.subscribe(onNext: { arrry in
            print(arrry)
        }).disposed(by: disposeBag)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 8
        
        let current = textField.text! as NSString
        let new = current.replacingCharacters(in: range, with: string) as NSString
        
        return new.length <= maxLength
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let divied3 = currencyCollectionView.frame.width / 3 - 16
        return CGSize(width: divied3, height: CurrencyCell.cellLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
