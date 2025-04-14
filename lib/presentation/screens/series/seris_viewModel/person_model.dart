class PersonSearchResponse {
  final List<Person> results;

  PersonSearchResponse({required this.results});

  factory PersonSearchResponse.fromJson(Map<String, dynamic> json) {
    return PersonSearchResponse(
      results: (json['results'] as List)
          .map((item) => Person.fromJson(item))
          .toList(),
    );
  }
}

class Person {
  final String name;
  final String? profilePath;

  Person({required this.name, this.profilePath});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] ?? '',
      profilePath: json['profile_path'],
    );
  }
}
