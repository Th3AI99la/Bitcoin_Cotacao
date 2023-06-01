import SwiftUI

struct ContentView: View {
    
    // MARK: VAR`S
    @State private var currentDate = Date()
    @State private var currencyData: CurrencyData?
    
    
    var body: some View {
        VStack {
            Text("Search Coin")
            
            
            // MARK: LIST
            
            List {
                Section(footer: Text("\(currentDate)")) {
                    if let data = currencyData {
                        
                        
                        HStack {
                            Image("bit")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                            Text("1 BTC = \(data.bitcoin.value, specifier: "%.2f")")
                        }
                        
                        
                        HStack {
                            Image("dolar")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                            Text("1 BTC = DÓLAR: \(data.dollar.value, specifier: "%.2f")")
                        }
                        
                        HStack {
                            
                            Image("real")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                            Text("1 BTC = REAL: \(data.real.value, specifier: "%.2f")")
                        }
                        
                        HStack {
                            Image("eth")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                            Text("1 BTC = ETH: \(data.ethereum.value, specifier: "%.2f")")
                        }
                        
                        HStack {
                            Image("euro")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                            Text("1 BTC = EURO: \(data.euro.value, specifier: "%.2f")")
                        }
                    } else {
                        Text("Carregando cotações...")
                    }
                }
            }
        }
        .onAppear {
            startTimer()
            fetchDataFromAPI()
        }
        
    }// BODY
    
    // MARK: FUNÇOES
    
    // MARK: HORA
    func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            DispatchQueue.main.async {
                currentDate = Date()
            }
        }
    }
    
    // MARK: API
    
    func fetchDataFromAPI() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=BRL,USD,EUR,ETH") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode([String: [String: Double]].self, from: data)
                
                if let bitcoinData = apiResponse["bitcoin"] {
                    let currencyData = CurrencyData(
                        bitcoin: Currency(name: "Bitcoin", value: bitcoinData["brl"] ?? 0.0),
                        real: Currency(name: "Real", value: bitcoinData["brl"] ?? 0.0),
                        dollar: Currency(name: "Dollar", value: bitcoinData["usd"] ?? 0.0),
                        euro: Currency(name: "Euro", value: bitcoinData["eur"] ?? 0.0),
                        ethereum: Currency(name: "Ethereum", value: bitcoinData["eth"] ?? 0.0)
                    )
                    
                    DispatchQueue.main.async {
                        self.currencyData = currencyData
                    }
                }
            } catch {
                print("Error decoding API response: \(error)")
            }
        }
        
        task.resume()
    }

    
}




// MARK: STRUCT

struct CurrencyData {
    let bitcoin: Currency
    let real: Currency
    let dollar: Currency
    let euro: Currency
    let ethereum: Currency
}

struct Currency {
    let name: String
    let value: Double
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
