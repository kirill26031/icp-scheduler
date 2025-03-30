import Time "mo:base/Time";
import Iter "mo:base/Iter";

class Utils() {
    public func getMonthStartEnd(year: Nat, month: Nat) : (Time.Time, Time.Time) {
        let startTimestamp = toNanoTimestamp(year, month, 1);
        let endTimestamp = toNanoTimestamp(year, month, lastDayOfMonth(year, month));

        return (startTimestamp, endTimestamp);
    };

    /// Returns the last day of the month, considering leap years.
    func lastDayOfMonth(year: Nat, month: Nat) : Nat {
        switch (month) {
            case (1 or 3 or 5 or 7 or 8 or 10 or 12) { 31 };
            case (4 or 6 or 9 or 11) { 30 };
            case 2 { if (isLeapYear(year)) { 29 } else { 28 } };
            case _ { 30 };
        }
    };

    /// Checks if a year is a leap year
    func isLeapYear(year: Nat) : Bool {
        return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0);
    };

    /// Converts (year, month, day) into **nanoseconds** since UNIX epoch (1970-01-01T00:00:00Z)
    public func toNanoTimestamp(year: Nat, month: Nat, day: Nat) : Time.Time {
        var totalDays: Nat = 0;

        // Add full years since 1970
        for (y in Iter.range(1970, year - 1)) {
            totalDays += if (isLeapYear(y)) { 366 } else { 365 };
        };

        // Add full months since January of the current year
        for (m in Iter.range(1, month - 1)) {
            totalDays += lastDayOfMonth(year, m);
        };

        // Add days in the current month
        totalDays += day - 1; // Subtract 1 because days start at 0 in UNIX time

        let secondsSinceEpoch = totalDays * 86400; // Convert days to seconds
        return secondsSinceEpoch * 1_000_000_000; // Convert seconds to nanoseconds
    };
};