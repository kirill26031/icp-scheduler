import { thash } "mo:map/Map";
import Text "mo:base/Text";
// import Nat "mo:base/Nat";

import Source "mo:uuid/async/SourceV4";
import UUID_ "mo:uuid/UUID";


module {
    public type UUID = Text;

    public let hash = thash;

    public func nextId() : async UUID {
        let g = Source.Source();
        return UUID_.toText(await g.new());
    };
}