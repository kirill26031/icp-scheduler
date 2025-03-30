import Map "mo:map/Map";
import Set "mo:map/Set";
import Time "mo:base/Time";
import Array "mo:base/Array";

import { hash } "../types/UUID";
import Event "../types/Event";
import UUID "../types/UUID";

persistent actor EventsRepository {
    stable var events = Map.new<UUID.UUID, Event.Event>();
    
    public query func getById(eventId: UUID.UUID) : async ?Event.Event {
        if (Map.has(events, hash, eventId)) {
            return Map.get(events, hash, eventId);
        }
        else return null;
    };

    public query func getAll() : async [Event.Event] {
        var chosenEvents: [Event.Event] = [];
        for ((id: UUID.UUID, event: Event.Event) in Map.entries(events)) {
            chosenEvents := Array.append(chosenEvents, [event]);
        };
        return chosenEvents;
    };

    public query func existsById(eventId: UUID.UUID) : async Bool {
        return Map.has(events, hash, eventId);
    };

    public query func eventsInRangeAndInGroups(startDate: Time.Time, endDate: Time.Time, groupIds: [UUID.UUID]) : async [Event.Event] {
        var chosenEvents: [Event.Event] = [];
        for ((id: UUID.UUID, event: Event.Event) in Map.entries(events)) {
            if (Array.find(groupIds: [UUID.UUID],func(groupId: UUID.UUID): Bool {groupId == event.eventGroupId}) != null and
                ( event.startEventDate < endDate and event.endEventDate > startDate)
            ) {
                chosenEvents := Array.append(chosenEvents, [event]);
            }
        };
        return chosenEvents;
    };


    public func deleteById(eventId: UUID.UUID) {
        Map.delete(events, hash, eventId);
    };

    public func deleteByEventGroupId(eventGroupId: UUID.UUID) {
        let eventIdsToDelete = Set.new<UUID.UUID>();
        for ((key: UUID.UUID, value: Event.Event) in Map.entries(events)) {
            if (value.eventGroupId == eventGroupId) {
                Set.add(eventIdsToDelete, hash, key);
            }
        };
        for (eventId in Set.keys(eventIdsToDelete)) {
            Map.delete(events, hash, eventId);
        }
    };

    public func createFromDto(eventDto: Event.CreateEventDTO): async Event.Event {
        let newId: UUID.UUID = await UUID.nextId();
        let event: Event.Event = Event.dtoToEvent(eventDto, newId);
        Map.set(events, hash, newId, event);
        return event;
    };
};