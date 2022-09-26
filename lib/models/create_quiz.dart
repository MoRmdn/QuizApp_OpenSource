class QuizCreate {
  String Q = '';
  String correctAnswer = '';
  String illustration = '';
  String a2 = '';
  String a3 = '';
  String a4 = '';
}

Map<String, String> domainID = {
  'Domain 1': 'tI57CeInJ9rLcVyjZ7n2',
  'Domain 2': 'cd7dsGRndq6Rc79UxYQ4',
  'Domain 3': 'oPmmq8T3wGA7EIFdTF7C',
  'Domain 4': 'JK3oQ3OhUmofQVJVeT0q',
  'Domain 5': '0qfVbITEnsdYVmfqW8Gy',
  'Domain 6': 'MTyIfV13IsDF6fKTMJT5',
  'Domain 7': '5Tf0x1f6OFyPQ8RSoNBn',
  'Domain 8': 'pJFxtYVZQqF3nlyeeOW9',
  'Domain 9': 'OnooM0VqKvc7uwSZnP8u',
};
List<String> domainName = [
  'Advanced Sciences and Math',
  'Safety Management Systems',
  'Ergonomics',
  'Fire Prevention and Protection',
  'Emergency Response Management (ERM)',
  'Industrial Hygiene and Occupational Health',
  'Environmental Management',
  'Training, Education, and Communication',
  'Law and Ethics',
];
Map<String, String> domainNameForPath = {
  'Advanced Sciences and Math': 'Domain 1',
  'Safety Management Systems': 'Domain 2',
  'Ergonomics': 'Domain 3',
  'Fire Prevention and Protection': 'Domain 4',
  'Emergency Response Management (ERM)': 'Domain 5',
  'Industrial Hygiene and Occupational Health': 'Domain 6',
  'Environmental Management': 'Domain 7',
  'Training, Education, and Communication': 'Domain 8',
  'Law and Ethics': 'Domain 9',
};
List<Map<String, String>> domainNamesForUser = [
  {'Domain 1': 'Advanced Sciences and Math'},
  {'Domain 2': 'Safety Management Systems'},
  {'Domain 3': 'Ergonomics'},
  {'Domain 4': 'Fire Prevention and Protection'},
  {'Domain 5': 'Emergency Response Management (ERM)'},
  {'Domain 6': 'Industrial Hygiene and Occupational Health'},
  {'Domain 7': 'Environmental Management'},
  {'Domain 8': 'Training, Education, and Communication'},
  {'Domain 9': 'Law and Ethics'},
];

Map<String, String> domainsPhoto = {
  'Domain 1': 'assets/images/math.jpg',
  'Domain 2': 'assets/images/safety.jpg',
  'Domain 3': 'assets/images/domain3.jpg',
  'Domain 4': 'assets/images/fire2.jpeg',
  'Domain 5': 'assets/images/emergency.jpeg',
  'Domain 6': 'assets/images/domain6.jpeg',
  'Domain 7': 'assets/images/domain7.jpeg',
  'Domain 8': 'assets/images/training.jpeg',
  'Domain 9': 'assets/images/ethics.jpeg',
};
