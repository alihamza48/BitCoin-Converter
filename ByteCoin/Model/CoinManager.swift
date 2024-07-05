//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation


protocol CoinManagerDelegate {
    func didUpdateCoin(price: String , currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "89645810-2723-4410-9B3C-8FB726D65AD8"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

   
    
    
    func fetchPrice(currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

        performRequest(with: urlString, currency: currency)
    }
    
    func performRequest(with urlString: String , currency: String){
            //make url
            if let url = URL(string: urlString){
                // make session
                let session = URLSession(configuration: .default)
                // give sessio a task
                let task = session.dataTask(with: url) { data, response, error in
                    if error != nil{
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    
                    if let safeData = data{
                        if let coin = self.parseJSON(safeData){
                            let priceString = String(format: "%.1f" , coin)
                            self.delegate?.didUpdateCoin(price: priceString , currency: currency)
                        }
                        
                    }
                }
                // start the task
                task.resume()
                
            }
        }
    
    func parseJSON(_ coinData: Data) -> Double? {
           let decoder = JSONDecoder()
           do{
               let decodedData = try decoder.decode(CoinData.self, from: coinData)
               let lastPrice = decodedData.rate
        
               return lastPrice
               
           }catch{
               delegate?.didFailWithError(error: error)
               return nil
           }
           
       }
    
  
    
}
