class Review {
  late String review;

  Map<String, dynamic> toJsonString() {
    return {
      "review": review,
    };
  }
}
