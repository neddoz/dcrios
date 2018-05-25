//
//  RecoverWalletViewController.swift
//  Decred Wallet
//
//  Created by rails on 18/05/18.
//  Copyright © 2018 The Decred developers. All rights reserved.
//

import UIKit
import Wallet

class RecoverWalletViewController: UIViewController {
    
    @IBOutlet weak var txSeedCheckCombined: UITextView!
    @IBOutlet weak var tfSeedCheckWord: UITextField!
    @IBOutlet weak var txtInputView: UIView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var txtFieldContainer: UIView!

    var arrSeed = Array<String>()
    var seedWords : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAccessory()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txSeedCheckCombined.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    @IBAction func btnConfirmSeed(_ sender: Any) {
        self.view.endEditing(true)
        
        let flag =  AppContext.instance.walletManager?.verifySeed(txSeedCheckCombined.text)
        if(flag)! {
            self.performSegue(withIdentifier: "encryptWallet", sender: self)
        } else {
            self.showError(error: "Seed was not verifed!")
        }
        
    }
    
    func verifyWord() {
        if( tfSeedCheckWord.text!.length > 0 ) {
            arrSeed.append(tfSeedCheckWord.text!)
            seedWords = arrSeed.joined(separator: " ")
            txSeedCheckCombined.text = seedWords
            tfSeedCheckWord.text = ""
            btnClear.isHidden = false
        }
    }
    
    @IBAction func clearSeed(_ sender: Any) {
        txSeedCheckCombined.text = ""
        seedWords = ""
        arrSeed.removeAll()
        btnClear.isHidden = true
    }
    
    @IBAction func deleteLastSeed(sender: UIButton)
    {
        
        if(arrSeed.count > 0) {
            arrSeed.removeLast()
            seedWords = arrSeed.joined(separator: " ")
            print(seedWords)
            txSeedCheckCombined.text = seedWords
        }
        btnClear.isHidden = (arrSeed.count == 0)

    }
    
    // MARK: - Utility Methods
    func showError(error: String){
        let alert = UIAlertController(title: "Warning", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: {self.navigationController?.popToRootViewController(animated: true)})
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: {
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "encryptWallet" {
            let vc = segue.destination as! CreatePasswordViewController
            vc.seedToVerify = txSeedCheckCombined.text
        } else {
            
        }
        
    }
    
    // Input views
    func addAccessory() {
        
        tfSeedCheckWord.delegate = self
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        customView.addSubview(txtInputView)
        customView.backgroundColor = UIColor.red
        txSeedCheckCombined.inputAccessoryView = customView
        
        txtInputView.translatesAutoresizingMaskIntoConstraints = false
        customView.translatesAutoresizingMaskIntoConstraints = false
        txtFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        btnDelete.translatesAutoresizingMaskIntoConstraints = false
        tfSeedCheckWord.translatesAutoresizingMaskIntoConstraints = false
        
        // Input view constraints
        NSLayoutConstraint.activate([
            txtInputView.leadingAnchor.constraint(equalTo:
                customView.leadingAnchor, constant: 0),
            txtInputView.topAnchor.constraint(equalTo:
                customView.topAnchor, constant: 0),
            txtInputView.trailingAnchor.constraint(equalTo:
                customView.trailingAnchor, constant: 0),
            txtInputView.bottomAnchor.constraint(equalTo:
                customView.bottomAnchor, constant: 0),
            ])
        
        // Texfeild container constraints
        NSLayoutConstraint.activate([
            txtFieldContainer.leadingAnchor.constraint(equalTo:
                txtInputView.leadingAnchor, constant: 0),
            txtFieldContainer.heightAnchor.constraint(equalToConstant: 42),
            txtFieldContainer.trailingAnchor.constraint(equalTo:
                txtInputView.trailingAnchor, constant: 0),
            txtFieldContainer.bottomAnchor.constraint(equalTo:
                txtInputView.bottomAnchor, constant: 0)
            ])
        
        // Button clear constraints
        NSLayoutConstraint.activate([
            btnDelete.leadingAnchor.constraint(equalTo:
                txtInputView.leadingAnchor, constant: 10),
            btnDelete.heightAnchor.constraint(equalToConstant: 35),
            btnDelete.widthAnchor.constraint(equalToConstant: 118),
            btnDelete.topAnchor.constraint(equalTo:
                txtInputView.topAnchor, constant: 10)
            ])
        
        // Button confirm constraints
        NSLayoutConstraint.activate([
            btnConfirm.rightAnchor.constraint(equalTo:
                txtInputView.rightAnchor, constant: -10),
            btnConfirm.heightAnchor.constraint(equalToConstant: 35),
            btnConfirm.widthAnchor.constraint(equalToConstant: 118),
            btnConfirm.topAnchor.constraint(equalTo:
                txtInputView.topAnchor, constant: 10)
            ])
        
        // Text field  constraints
        NSLayoutConstraint.activate([
            tfSeedCheckWord.leadingAnchor.constraint(equalTo:
                txtFieldContainer.leadingAnchor, constant: 10),
            tfSeedCheckWord.rightAnchor.constraint(equalTo:
                txtFieldContainer.rightAnchor, constant: -10),
            tfSeedCheckWord.heightAnchor.constraint(equalToConstant: 30),
            tfSeedCheckWord.topAnchor.constraint(equalTo:
                txtFieldContainer.topAnchor, constant: 10)
            ])
    }
    func enableButton() {
        btnConfirm.isEnabled = true
        btnConfirm.alpha = 1.0
    }
}

// MARK: - TextView Delegate Methods

extension RecoverWalletViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        tfSeedCheckWord.becomeFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return false
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
}

extension RecoverWalletViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.verifyWord()
        if(arrSeed.count == 33) {
            self.enableButton()
        } else {
            btnConfirm.isEnabled = false
            if(arrSeed.count == 32) {
                tfSeedCheckWord.resignFirstResponder()
                textField.returnKeyType = UIReturnKeyType.done
                tfSeedCheckWord.becomeFirstResponder()
            } else {
                textField.returnKeyType = UIReturnKeyType.continue
            }
        }
        
        
        
        return true
    }
    
}


