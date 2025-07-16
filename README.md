# GoWithMe – Find Your Activity Buddy

**GoWithMe** is a full-stack cross-platform app that helps people find partners for sports and healthy lifestyle activities in their local area. The project was built during the **Flutter Summer Course** at Innopolis University.

---

## Team

| Name              | Role(s)                        | Responsibilities                                  |
|-------------------|-------------------------------|---------------------------------------------------|
| Lavrova Marina    | Frontend, Task Planning        | Flutter, UI, integration with backend, task board |
| Alexander Blinov  | Backend, DB            | Architecture, database, backend, API, design slides     |
| Leonid Merkulov   | DevOps, Tests, Docs, Slides    | CI/CD, Docker, tests, documentation, presentation |

---

## Implementation checklist

### Technical requirements (20 points)
#### Backend development (8 points)
- [ ] Go-based microservices architecture (minimum 3 services) (3 points)
- [ ] RESTful API with Swagger documentation (1 point)
- [ ] gRPC implementation for communication between microservices (1 point)
- [ ] PostgreSQL database with proper schema design (1 point)
- [ ] JWT-based authentication and authorization (1 point)
- [ ] Comprehensive unit and integration tests (1 point)

#### Frontend development (8 points)
- [ ] Flutter-based cross-platform application (mobile + web) (3 points)
- [ ] Responsive UI design with custom widgets (1 point)
- [ ] State management implementation (1 point)
- [ ] Offline data persistence (1 point)
- [ ] Unit and widget tests (1 point)
- [ ] Support light and dark mode (1 point)

#### DevOps & deployment (4 points)
- [ ] Docker compose for all services (1 point)
- [ ] CI/CD pipeline implementation (1 point)
- [ ] Environment configuration management using config files (1 point)
- [ ] GitHub pages for the project (1 point)

### Non-Technical Requirements (10 points)
#### Project management (4 points)
- [ ] GitHub organization with well-maintained repository (1 point)
- [ ] Regular commits and meaningful pull requests from all team members (1 point)
- [ ] Project board (GitHub Projects) with task tracking (1 point)
- [ ] Team member roles and responsibilities documentation (1 point)

#### Documentation (4 points)
- [ ] Project overview and setup instructions (1 point)
- [ ] Screenshots and GIFs of key features (1 point)
- [ ] API documentation (1 point)
- [ ] Architecture diagrams and explanations (1 point)

#### Code quality (2 points)
- [ ] Consistent code style and formatting during CI/CD pipeline (1 point)
- [ ] Code review participation and resolution (1 point)

### Bonus Features (up to 10 points)
- [ ] Localization for Russian (RU) and English (ENG) languages (2 points)
- [ ] Good UI/UX design (up to 3 points)
- [ ] Integration with external APIs (fitness trackers, health devices) (up to 5 points)
- [ ] Comprehensive error handling and user feedback (up to 2 points)
- [ ] Advanced animations and transitions (up to 3 points)
- [ ] Widget implementation for native mobile elements (up to 2 points)

**Total points implemented: XX/30 (excluding bonus points)**

> For each implemented feature, provide a brief description or link to the relevant implementation below the checklist.

---

## Project Overview

GoWithMe is designed to help users find activity partners for sports and healthy lifestyle events. The app supports user registration, profile management, activity search, and real-time results.

---

## Setup Instructions

### Prerequisites
- Docker & Docker Compose
- Flutter (3.22+)
- Go (1.22+)
- PostgreSQL

### Local launch

```sh
# Start all services with Docker Compose
docker compose up --build

# Run frontend locally
cd frontend
flutter pub get
flutter run -d chrome

# Run backend locally
cd backend
go run cmd/main.go
```

### Running tests

```sh
# Frontend
cd frontend
flutter test --coverage

# Backend
cd backend
go test ./...
```

---

## API Documentation


---

## Architecture


---

## Screenshots & GIFs

---

## Links

- **GitHub Organization:** [MAL-da-udal](https://github.com/MAL-da-udal)
- **Repository:** [GoWithMe](https://github.com/MAL-da-udal/GoWithMe)
- **GitHub Pages (Web Demo):** https://mal-da-udal.github.io/GoWithMe/
- **Presentation video:** [(add link)](https://drive.google.com/drive/folders/1j5W5sts8wRprbJZcj3uxYzcqmFJFDfAl?usp=sharing)
- **Project board:** https://github.com/orgs/MAL-da-udal/projects/5
