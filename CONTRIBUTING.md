# Contributing to Fetosense Web Flutter

Welcome! 🎉 Thank you for considering contributing to **fetosense-web-flutter**, the web version of the Fetosense platform. Your contributions—whether in the form of code, ideas, or bug reports—are greatly appreciated!

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Ways to Contribute](#ways-to-contribute)
  - [Reporting Issues](#reporting-issues)
  - [Submitting Pull Requests](#submitting-pull-requests)
- [Code Style Guidelines](#code-style-guidelines)
- [Commit Message Format](#commit-message-format)
- [Testing Guidelines](#testing-guidelines)
- [Help & Questions](#help--questions)

---

## 📜 Code of Conduct

Please read our [Code of Conduct](https://github.com/CareNX-Innovations-Pvt-Ltd/fetosense-web-flutter/blob/main/CODE_OF_CONDUCT.md) to ensure a respectful environment for everyone.

---

## Getting Started

1. **Fork** the repository.
2. **Clone** your fork:
   ```bash
   git clone https://github.com/<your-username>/fetosense-web-flutter.git
   cd fetosense-web-flutter
   ```
3. **Install Flutter SDK** and dependencies:
   ```bash
   flutter doctor
   flutter pub get
   ```
4. **Run the app in browser:**
   ```bash
   flutter run -d chrome
   ```

---

##Ways to Contribute

### 🐞 Reporting Issues

Have you encountered a bug or want to request a feature?

- Create a [new issue](https://github.com/CareNX-Innovations-Pvt-Ltd/fetosense-web-flutter/issues/new)
- Include:
  - Clear steps to reproduce
  - Expected and actual results
  - Screenshots or logs (if available)
  - Environment info (Flutter version, browser, OS)

### 🔧 Submitting Pull Requests

1. **Create a feature branch** from `main`:
   ```bash
   git checkout -b my-feature
   ```

2. **Write clear, clean code**
   - Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
   - Use Cubit/Bloc for state management where required
   - Keep logic out of UI files where possible

3. **Run checks:**
   ```bash
   flutter format .
   flutter analyze
   flutter test
   ```

4. **Push and open a PR**:
   - Explain the purpose of your changes
   - Link to related issues (`Closes #issue-id`)
   - Add screenshots or GIFs if UI is affected

---

## 🧹 Code Style Guidelines

- Format your code with `flutter format .`
- Follow naming conventions (`*_view.dart`, `*_cubit.dart`, etc.)
- Prefer smaller widgets and clean build methods
- Organize test files in `test/` with matching structure

---

##Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format:

```
<type>(<scope>): <description>
```

Examples:
- `feat(login): implement email sign in`
- `fix(report): resolve PDF layout overflow`
- `chore: bump Flutter SDK version`

Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`

---

## 🧪 Testing Guidelines

- Add unit/widget tests for new logic/UI
- Use `mocktail` or `mockito` for mocking dependencies
- Run all tests before submitting:
  ```bash
  flutter test
  ```

---

## Help & Questions

Need support or want to discuss something?

- Join or start a [discussion](https://github.com/CareNX-Innovations-Pvt-Ltd/fetosense-web-flutter/discussions)
- Tag a maintainer in issues or pull requests

---

Thanks for helping improve Fetosense Web Flutter! 💙
