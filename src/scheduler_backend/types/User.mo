import UUID "../types/UUID";

module {
    public class EventGroup(
        _id: UUID.UUID,
        _username: Text
    ) {
        public var id: UUID.UUID = _id;
        public var username: Text = _username;
    }
}