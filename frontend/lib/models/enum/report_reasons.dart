enum ReportReasons {
  sexualContent('sexual_content'),
  violentContent('violent_repulsive_content'),
  hatefulContent('hateful_abusive_content'),
  harmfulContent('harmful_dangerous_content'),
  spam('spam_misleading'),
  childAbuse('child_abuse'),
  other('other');

  final String value;

  const ReportReasons(this.value);
}
