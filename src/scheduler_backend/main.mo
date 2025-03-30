import Event "types/Event";
import Array "mo:base/Array";
import Utils "utils";
import UUID "types/UUID";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

actor Main {
  let utils = Utils.Utils();

  public func getAllEventsInRange(year: Nat, month: Nat) : async [Event.Event] {
    if (year < 2000 or month > 12) {
      return [];
    } else {
      let (startDate, endDate) = utils.getMonthStartEnd(year, month);
      Debug.print(Int.toText(startDate));
      Debug.print(Int.toText(endDate));
      let EventGroupsRepo = actor("be2us-64aaa-aaaaa-qaabq-cai"): actor {
        getAllIds: query () -> async [UUID.UUID];
      };
      let allEventGroupIds: [UUID.UUID] = await EventGroupsRepo.getAllIds();
      Debug.print(allEventGroupIds[0]);
      let EventsRepo = actor("br5f7-7uaaa-aaaaa-qaaca-cai"): actor {
        eventsInRangeAndInGroups: query (startDate: Time.Time, endDate: Time.Time, groupIds: [UUID.UUID]) -> async [Event.Event];
      };
      let events: [Event.Event] = await EventsRepo.eventsInRangeAndInGroups(startDate, endDate, allEventGroupIds);
      Debug.print(Int.toText(Array.size<Event.Event>(events)));
      return events;
    }
  };

  public func test(year: Nat, month: Nat, day: Nat) : async Time.Time {
    let utils = Utils.Utils();
    return utils.toNanoTimestamp(year, month, day);
  }
};
