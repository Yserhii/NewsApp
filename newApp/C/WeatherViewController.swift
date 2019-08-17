//
//  WeatherViewController.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/12/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var teperature: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var wind_kph: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var backgraundimage: UIImageView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    func getWeather() {
        self.city.text = allInfoWeather?["location"]["name"].string ?? ""
        self.condition.text = allInfoWeather?["current"]["condition"]["text"].string ?? ""
        self.teperature.text = "\(allInfoWeather?["current"]["temp_c"].int ?? 0)º"
        self.feelsLike.text = "Feels like \(allInfoWeather?["current"]["feelslike_c"].int ?? 0)º"
        self.wind_kph.text = "Wind speed \(allInfoWeather?["current"]["wind_kph"].int ?? 0)km/h"
        self.humidity.text = "Humidity \(allInfoWeather?["current"]["humidity"].int ?? 0)"
        if allInfoWeather?["current"]["is_day"].int ?? 0 == 1 {
            self.backgraundimage.image = UIImage(imageLiteralResourceName: "day")
            self.view.backgroundColor = #colorLiteral(red: 0.3420918882, green: 0.5821729898, blue: 0.7652515769, alpha: 1)
        } else {
            self.backgraundimage.image = UIImage(imageLiteralResourceName: "nigth")
            self.view.backgroundColor = #colorLiteral(red: 0.2572125793, green: 0.4238344729, blue: 0.4471823573, alpha: 1)
        }
        if let weatherImageBackground = URL(string: "https:" + "\(allInfoWeather?["current"]["condition"]["icon"].string ?? "")") {
            if let weatherImage = try? Data(contentsOf: weatherImageBackground) {
                self.weatherImage.image = UIImage(data: weatherImage)!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? WeatherOptionCell
        cell?.day.text = getDayNameBy(stringDate: allInfoWeather?["forecast"]["forecastday"][indexPath.row]["date"].string ?? "")
        cell?.inDay.text = "\(allInfoWeather?["forecast"]["forecastday"][indexPath.row]["day"]["maxtemp_c"].int ?? 0)"
        cell?.inEvning.text = "\(allInfoWeather?["forecast"]["forecastday"][indexPath.row]["day"]["mintemp_c"].int ?? 0)"
        if let weatherImageBackground = URL(string: "https:" + "\(allInfoWeather?["forecast"]["forecastday"][0]["day"]["condition"]["icon"].string ?? "")") {
            if let weatherImage = try? Data(contentsOf: weatherImageBackground) {
               cell?.imageWeather.image = UIImage(data: weatherImage)!
            }
        }
        cell?.selectionStyle = .none
        
        
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        view.backgroundColor = .darkGray
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        getWeather()
    }
    
}

extension WeatherViewController {
    func getDayNameBy(stringDate: String) -> String
    {
        let df  = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEEE"
        return df.string(from: date);
    }
}

