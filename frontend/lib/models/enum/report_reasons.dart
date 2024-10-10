enum ReportReasons {
  sexualContent('Sexual Content'),
  violentContent('Violent or Repulsive Content'),
  hatefulContent('Hateful or Abusive Content'),
  harmfulContent('Harmful or Dangerous Content'),
  spam('Spam or Misleading'),
  childAbuse('Child Abuse'),
  other('Other');

  final String value;

  const ReportReasons(this.value);
}
