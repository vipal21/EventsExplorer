//
//  EventServiceProtocol.swift
//  EventsExplorer
//
//  Created by Vipal on 2026-09-27.
//

protocol EventServiceProtocol: Sendable {
    func fetchEvents() async throws -> [Event]
}

final class OnlineEventService: EventServiceProtocol {
    private let client: APIClient
    // Replace with your real API endpoint when ready
    private let urlString = "https://jsonplaceholder.typicode.com/photos"
    // Inject our generic engine
    init(
        client: APIClient = APIClient(),
    ) {
        self.client = client
    }
    func fetchEvents() async throws -> [Event] {
        print("🌐 Calling Event API...")
        let apiEvents = try await client.fetch([Event].self, from: urlString)
        print("✅ API event response count: \(apiEvents.count)")
        // Map the incoming network array to preserve what the user already favourite locally
        let apiEventsPreservingFavorites = apiEvents.map { networkEvent in
            Event(
                id: networkEvent.id,
                title: networkEvent.title,
                venue: networkEvent.venue,
                venueImage: networkEvent.venueImage,
                eventDescription: networkEvent.eventDescription,
                eventImages: networkEvent.eventImages,
                date: networkEvent.date,
                startTime: networkEvent.startTime,
                endTime: networkEvent.endTime,
                latitude: networkEvent.latitude,
                longitude: networkEvent.longitude,
                isFavourite: true
            )
        }
        // Sort arrays safely for direct equivalence checks
        let sortedAPIEvents = apiEventsPreservingFavorites.sorted { $0.id < $1.id }
            return sortedAPIEvents

    }
}
