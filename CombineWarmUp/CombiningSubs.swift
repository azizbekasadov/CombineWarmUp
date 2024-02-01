//
//  CombiningSubs.swift
//  CombineWarmUp
//
//  Created by Azizbek Asadov on 01/02/24.
//

import Foundation
import Combine

let meals: Publishers.Sequence<[String?], Never> = ["A", "B", "C", nil].publisher
let people: Publishers.Sequence<[String?], Never> = ["Austria", "Germany", "Switzerland", "Uzbekistan"].publisher

let sub1 = people
    .zip(meals)
    .filter { $0 != nil && $1 != nil }
    .sink { completion in
        print("Subscriotion: \(completion)")
    } receiveValue: { person, meal in
        print("\(String(describing: person)) enjoys \(meals)")
    }


enum PersonError: Error {
    case emptyData
}

extension PersonError {
    var errorDescription: String {
        switch self {
        case .emptyData:
            return "No data found"
        }
    }
}

func validate(person: String?, meal: String?) throws -> String {
    guard let person = person, let meal = meal else {
        throw PersonError.emptyData
    }
    
    return "\(person) enjoys \(meal)"
}

let sub2 = people
    .zip(meals)
    .tryMap { try validate(person: $0, meal: $1) }
    .sink { completion in
        print("Subscription: \(completion)")
        switch completion {
        case .finished:
            print("Finished Execution")
        case .failure(let error as PersonError):
            print("Error: \(error.errorDescription)")
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    } receiveValue: { message in
        print(message)
    }

