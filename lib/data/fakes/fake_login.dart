class FakeUser {
  final String email;
  final String password;

  const FakeUser({
    required this.email,
    required this.password,
  });
}


const List<FakeUser> _fakeUsers = [
  FakeUser(
    email: 'example@sabanciuniv.edu',
    password: '123456789',
  ),
];


bool fakeLogin(String email, String password) {
  for (final user in _fakeUsers) {
    if (user.email == email && user.password == password) {
      return true;
    }
  }
  return false;
}
