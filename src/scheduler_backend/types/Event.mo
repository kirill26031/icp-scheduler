import Time "mo:base/Time";
import Text "mo:base/Text";
import UUID "../types/UUID";

module {
    public type EventPriority = { #Low; #Medium; #High; #Critical;};
    public type EventFreq = { #Daily; #Weekly; };
    
    public class Event(
        _id: UUID.UUID,
        _name: Text,
        _description: ?Text,
        _priority: ?EventPriority,
        _isReoccurring: Bool,
        _freq: ?EventFreq,
        _eventGroupId: UUID.UUID,
        _startEventDate: ?Time.Time,
        _endEventDate: ?Time.Time
      ) {
        public let id: UUID.UUID = _id;
        public let name: Text = _name;
        public let description: ?Text = _description;
        public let priority: ?EventPriority = _priority;
        public let isReoccurring: Bool = _isReoccurring;
        public let freq: ?EventFreq = _freq;
        public let eventGroupId: UUID.UUID = _eventGroupId;
        public let startEventDate: ?Time.Time = _startEventDate;
        public let endEventDate: ?Time.Time = _endEventDate;
      };

      public class CreateEventDTO(
        _name: Text,
        _description: ?Text,
        _priority: ?EventPriority,
        _isReoccurring: Bool,
        _freq: ?EventFreq,
        _eventGroupId: UUID.UUID,
        _startEventDate: ?Time.Time,
        _endEventDate: ?Time.Time
      ) {
        public let name: Text = _name;
        public let description: ?Text = _description;
        public let priority: ?EventPriority = _priority;
        public let isReoccurring: Bool = _isReoccurring;
        public let freq: ?EventFreq = _freq;
        public let eventGroupId: UUID.UUID = _eventGroupId;
        public let startEventDate: ?Time.Time = _startEventDate;
        public let endEventDate: ?Time.Time = _endEventDate;
      };

      public func dtoToEvent(dto: CreateEventDTO, id: UUID.UUID) : Event {
        return Event(
          id,
          dto.name,
          dto.description,
          dto.priority,
          dto.isReoccurring,
          dto.freq,
          dto.eventGroupId,
          dto.startEventDate,
          dto.endEventDate
        );
      };

}