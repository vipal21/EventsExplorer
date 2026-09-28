//
//  EventEntity+CoreDataProperties.swift
//  EventsExplorer
//
//  Created by Vipal on 2026-09-27.
//
//

public import Foundation
public import CoreData


public typealias EventEntityCoreDataPropertiesSet = NSSet

extension EventEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventEntity> {
        return NSFetchRequest<EventEntity>(entityName: "EventEntity")
    }

    @NSManaged nonisolated public var date: String?
    @NSManaged nonisolated public var endTime: String?
    @NSManaged nonisolated public var eventImages: String?
    @NSManaged nonisolated public var eventDescription: String?
    @NSManaged nonisolated public var startTime: String?
    @NSManaged nonisolated public var longitude: Double
    @NSManaged nonisolated public var latitude: Double
    @NSManaged nonisolated public var isFavourite: Bool
    @NSManaged nonisolated public var id: Int64
    @NSManaged nonisolated public var venue: String?
    @NSManaged nonisolated public var title: String?
    @NSManaged nonisolated public var venueImage: String?

}

extension EventEntity : Identifiable {

}
