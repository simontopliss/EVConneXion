//
//  ViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 16/06/2023.
//

import Foundation

final class ViewModel: ObservableObject {

    // MARK: - PROPERTIES

    @Published var chargeDevices: [ChargeDevice] = []
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published private(set) var isLoading = false
    @Published var hasError = false

    private let baseURL = "http://chargepoints.dft.gov.uk/api/retrieve/"

    @MainActor
    func fetchChargeDevices(for: String) {
//        Endpoint.R
    }
}
