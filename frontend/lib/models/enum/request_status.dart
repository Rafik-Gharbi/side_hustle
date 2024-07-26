/// This enum is used for both booking and reservation
enum RequestStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  rejected('Rejected'),
  finished('Finished');

  final String value;

  const RequestStatus(this.value);
}
