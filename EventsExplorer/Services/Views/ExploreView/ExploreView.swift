//
//  ExploreView.swift
//  EventsExplorer
//
//  Created by Vipal on 2026-09-27.
//

import SwiftUI
import MapKit
import CoreLocation

struct ExploreView: View {
    // Bound reference received cleanly from MainTabBarView
    @Bindable var viewModel: ExploreViewModel
    @State private var selectedDetailEvent: Event?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $viewModel.position, selection: $viewModel.tappedPinID) {
                    ForEach(viewModel.events) { event in
                        Annotation(
                            event.title,
                            coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
                        ) {
                            DetailedAnnotationPinView(
                                event: event,
                                userLocation: viewModel.currentUserLocation ?? CLLocation(latitude: 51.0474, longitude: -114.0597)
                            )
                            .frame(width: 60, height: 60)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedDetailEvent = event
                            }
                        }
                        .tag(event.id)
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                .ignoresSafeArea(edges: .top)

                // Only render carousel if events exist
                if !viewModel.events.isEmpty {
                    carouselOverlaySection
                }

                // Overlay Loading View when data is loading and no events are available yet
                if viewModel.isLoading && viewModel.events.isEmpty {
                    loadingOverlayView
                }
            }
            .navigationDestination(item: $selectedDetailEvent) { event in
                EventDetailView(event: event, onSaveToggle: {
                    viewModel.toggleFavourite(for: event)
                })
            }
        }
        .onChange(of: viewModel.scrolledID) { _, newScrollID in
            guard let validID = newScrollID else { return }
            withAnimation(.easeInOut) {
                viewModel.tappedPinID = validID
            }
            viewModel.processCarouselScroll(to: validID)
        }
        .onChange(of: viewModel.tappedPinID) { _, newPinID in
            guard let validPinID = newPinID else { return }
            if viewModel.scrolledID != validPinID {
                withAnimation(.easeInOut) {
                    viewModel.scrolledID = validPinID
                }
            }
        }
        .onAppear {
            viewModel.requestLocationAndLoadData()
        }
    }

    /// Semi-transparent loading card displayed over the center of the map
    private var loadingOverlayView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
                .tint(.primary)
            
            Text("Loading Events...")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        .frame(maxHeight: .infinity, alignment: .center)
    }

    private var carouselOverlaySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.events) { event in
                    CompactExploreCardView(
                        event: event,
                        selectedEvent: $selectedDetailEvent,
                        onToggleFavourite: { event in
                            viewModel.toggleFavourite(for: event)
                        }
                    )
                    .frame(width: 350)
                    .id(event.id)
                    .onTapGesture {
                        selectedDetailEvent = event
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .scrollTargetLayout()
        }
        .frame(height: 180)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $viewModel.scrolledID)
    }
}
