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
    @IBOutlet private weak var amountInputField: UITextField!
    @IBOutlet private weak var currencyCollectionView: UICollectionView!
    @IBOutlet private weak var sourceCurrencyField: UITextField!
    
    let currencyPickerView: UIPickerView = UIPickerView()
    
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
        
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(closeKeyBoard))
        toolbar.items = [space, doneBtn]
        toolbar.sizeToFit()
        amountInputField.inputAccessoryView = toolbar
        amountInputField.delegate = self
        
        sourceCurrencyField.inputView = currencyPickerView
        sourceCurrencyField.inputAccessoryView = toolbar
    }
    
    @objc
    private func closeKeyBoard() {
        self.view.endEditing(true)
    }
    
    private func bindUI() {
        let amount = amountInputField.rx.text.orEmpty.asDriver()
        let currency = currencyPickerView.rx.modelSelected(String.self).map { arr in
            arr.first ?? ""
        }.startWith("USD").asDriver(onErrorJustReturn: "USD")
        sourceCurrencyField.text = "USD"

        let vm = MainViewModel(input: (amount: amount, currency: currency),
                               service: CurrencyService(list: ListRepository(api: CurrencyListAPI(),
                                                                             cache: LocalCache(UserDefaults.standard)),
                                                        live: LiveRepository(api: CurrencyLiveAPI(),
                                                                             cache: LocalCache(UserDefaults.standard))))
        
        vm.exchange.bind(to: currencyCollectionView.rx.items(cellIdentifier: "cell", cellType: CurrencyCell.self)) { _, exchange, cell in
            cell.set(exchange: exchange)
            cell.isUserInteractionEnabled = false
            print(exchange)
        }
        .disposed(by: disposeBag)
        
        vm.quotes.bind(to: currencyPickerView.rx.itemTitles) { $1 }.disposed(by: disposeBag)
        currencyPickerView.rx.modelSelected(String.self)
            .subscribe { str in
                print(str)
                self.sourceCurrencyField.text = str.element?.first
            }
            .disposed(by: disposeBag)
        
        vm.error.subscribe(onNext: { err in
            self.showError(error: err)
        })
        .disposed(by: disposeBag)
    }
    
    private func showError(error: APIError) {
        let alert = UIAlertController(title: "エラー", message: error.message(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
