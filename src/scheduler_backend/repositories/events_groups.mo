import Map "mo:map/Map";
import Set "mo:map/Set";
import Time "mo:base/Time";
import Array "mo:base/Array";

import { hash } "../types/UUID";
import UUID "../types/UUID";
import EventGroup "../types/EventGroup";

persistent actor EventGroupsRepository {
    stable var eventsGroups = Map.new<UUID.UUID, EventGroup.EventGroup>();
    
    public query func getById(eventId: UUID.UUID) : async ?EventGroup.EventGroup {
        if (Map.has(eventsGroups, hash, eventId)) {
            return Map.get(eventsGroups, hash, eventId);
        }
        else return null;
    };

    public query func getAll() : async [EventGroup.EventGroup] {
        var chosenEvents: [EventGroup.EventGroup] = [];
        for ((id: UUID.UUID, event: EventGroup.EventGroup) in Map.entries(eventsGroups)) {
            chosenEvents := Array.append(chosenEvents, [event]);
        };
        return chosenEvents;
    };

    public query func getAllIds() : async [UUID.UUID] {
        var ids: [UUID.UUID] = [];
        for (id: UUID.UUID in Map.keys(eventsGroups)) {
            ids := Array.append(ids, [id]);
        };
        return ids;
    };

    public query func existsById(eventId: UUID.UUID) : async Bool {
        return Map.has(eventsGroups, hash, eventId);
    };


    public func deleteById(eventId: UUID.UUID) {
        Map.delete(eventsGroups, hash, eventId);
    };

    public func createFromDto(eventDto: EventGroup.CreateEventGroupDto): async EventGroup.EventGroup {
        let newId: UUID.UUID = await UUID.nextId();
        let eventGroup: EventGroup.EventGroup = EventGroup.dtoToEvent(eventDto, newId);
        Map.set(eventsGroups, hash, newId, eventGroup);
        return eventGroup;
    };
};