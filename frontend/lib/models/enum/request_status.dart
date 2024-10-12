/// This enum is used for both booking and reservation
enum RequestStatus {
  pending('pending'),
  confirmed('confirmed'),
  rejected('rejected'),
  finished('finished');

  final String value;

  const RequestStatus(this.value);
}
