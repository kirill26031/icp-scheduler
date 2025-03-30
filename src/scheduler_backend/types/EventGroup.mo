import UUID "../types/UUID";

module {
    public class EventGroup(
        _id: UUID.UUID,
        _name: Text,
        _description: ?Text,
        _ownerUserId: UUID.UUID
    ) {
        public let id: UUID.UUID = _id;
        public let name: Text = _name;
        public let description: ?Text = _description;
        public let ownerUserId: UUID.UUID = _ownerUserId;
    };

    public class CreateEventGroupDto(
        _name: Text,
        _description: ?Text,
        _ownerUserId: UUID.UUID
    ) {
        public let name: Text = _name;
        public let description: ?Text = _description;
        public let ownerUserId: UUID.UUID = _ownerUserId;
    };

    public func dtoToEvent(dto: CreateEventGroupDto, id: UUID.UUID) : EventGroup {
        return EventGroup(
          id,
          dto.name,
          dto.description,
          dto.ownerUserId
        );
      };
}