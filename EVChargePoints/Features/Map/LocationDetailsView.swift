//
//  LocationDetailsView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 27/07/2023.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {

    @EnvironmentObject private var vm: ChargePointViewModel

    @Binding var mapSelection: MKMapItem?
    var chargeDevice: ChargeDevice
    @Binding var show: Bool
    @Binding var getDirections: Bool

    @State private var lookAroundScene: MKLookAroundScene?

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(chargeDevice.chargeDeviceName)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(chargeDevice.chargeDeviceLocation.singleLineAddress)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }

                Spacer()

                Button {
                    show.toggle()
                    mapSelection = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            .padding(.top, 24)
            .padding(.horizontal)

            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }

            HStack(spacing: 20) {
                Button {
                    if let mapSelection {
                        mapSelection.openInMaps()
                    }
                } label: {
                    Text("Open in Maps")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }

                Button {
                    getDirections = true
                    show = false
                } label: {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }

            }
            .padding(.horizontal)
        }
        // Both .onAppear and .onChange are required for this to work
        // correctly if the user selects another pin in the UI
        .onAppear {
            print("DEBUG: Did call .onAppear")
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { _, _ in
            print("DEBUG: Did call .onChange")
            fetchLookAroundPreview()
        }
    }
}

extension LocationDetailsView {
    func fetchLookAroundPreview() {
        if let mapSelection {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
}

#Preview {
    LocationDetailsView(
        mapSelection: .constant(nil),
        chargeDevice: ChargePointData.mockChargeDevice,
        show: .constant(true),
        getDirections: .constant(true)
    )
    .environmentObject(ChargePointViewModel())
}
