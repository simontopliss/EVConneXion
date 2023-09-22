//
//  LocationDetailsView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 27/07/2023.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {

    var chargeDevice: ChargeDevice

    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @Binding var getDirections: Bool

    @State private var lookAroundScene: MKLookAroundScene?

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    deviceName
                    location
                }
                Spacer()
                closeButton
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

            HStack(spacing: 12) {
                openInMapsButton
                getDirectionsButton
            }
            .padding(.horizontal)
        }
        // Both .onAppear and .onChange are required for this to work
        // correctly if the user selects another pin in the UI
        .onAppear {
            // print("DEBUG: Did call .onAppear")
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection) { _, _ in
            // print("DEBUG: Did call .onChange")
            fetchLookAroundPreview()
        }
    }
}

#Preview {
    LocationDetailsView(
        chargeDevice: ChargePointData.mockChargeDevice,
        mapSelection: .constant(nil),
        show: .constant(true),
        getDirections: .constant(true)
    )
}

extension LocationDetailsView {

    private func fetchLookAroundPreview() {
        if let mapSelection {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }

    var deviceName: some View {
        Text(chargeDevice.chargeDeviceName)
            .font(.title2)
            .fontWeight(.semibold)
    }

    var location: some View {
        Text(chargeDevice.chargeDeviceLocation.singleLineAddress)
            .font(.footnote)
            .foregroundStyle(.gray)
            .lineLimit(2)
            .padding(.trailing)
    }

    var closeButton: some View {
        Button {
            show.toggle()
            mapSelection = nil
        } label: {
            XmarkButtonView(foregroundColor: .gray)
        }
    }

    var openInMapsButton: some View {
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
    }

    var getDirectionsButton: some View {
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
}

