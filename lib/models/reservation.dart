enum ReservationStatus { confirmed, cancelled, completed }

class TableReservation {
  final String id;
  final DateTime date;
  final String timeSlot;
  final int partySize;
  final String seatingPreference;
  final String specialRequest;
  final ReservationStatus status;

  TableReservation({
    required this.id,
    required this.date,
    required this.timeSlot,
    required this.partySize,
    required this.seatingPreference,
    this.specialRequest = '',
    this.status = ReservationStatus.confirmed,
  });
}
