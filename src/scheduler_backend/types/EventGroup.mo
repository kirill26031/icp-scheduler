import UUID "../types/UUID";

module {
    public class EventGroup(
        _id: UUID.UUID,
        _name: Text,
        _description: ?Text,
        _ownerUserId: UUID.UUID
    ) {
        public var id: UUID.UUID = _id;
        public var name: Text = _name;
        public var description: ?Text = _description;
    }
}