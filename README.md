<p align="center">
  <br />
  <h1 align="center">🌱 Rifq (رِفق)</h1>
  <p align="center">
    <strong>Compassionate, coordinated caregiving for your elderly loved ones.</strong>
  </p>
  <p align="center">
    <a href="https://flutter.dev">
      <img src="https://img.shields.io/badge/Flutter-3.13%2B-02569B?logo=flutter&logoColor=white" alt="Flutter" />
    </a>
    <a href="https://dart.dev">
      <img src="https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart&logoColor=white" alt="Dart" />
    </a>
    <a href="https://supabase.com">
      <img src="https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white" alt="Supabase" />
    </a>
    <a href="https://azure.microsoft.com/en-us/products/ai-services/openai-service">
      <img src="https://img.shields.io/badge/AI-Azure%20OpenAI-0078D4?logo=microsoftazure&logoColor=white" alt="Azure OpenAI" />
    </a>
    <a href="https://m3.material.io">
      <img src="https://img.shields.io/badge/UI-Material%203-7D5260?logo=materialdesign&logoColor=white" alt="Material 3" />
    </a>
    <a href="https://github.com">
      <img src="https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white" alt="Android" />
    </a>
  </p>
</p>

---

## 📖 Overview

**Rifq** (derived from the Arabic *رِفق*, meaning *gentleness, compassion, and tender care*) is a Flutter-based mobile application designed to simplify care coordination among family members caring for elderly relatives. 

Caring for an aging parent or loved one often involves multiple siblings and family members juggling shifts, medication schedules, and clinical appointments. **Rifq** eliminates communication gaps, prevents missed doses, and ensures continuous, 24/7 care through seamless scheduling, real-time activity logs, and an intelligent context-aware healthcare assistant named **Sanad (سَنَد)**.

---

## ✨ Key Features

### 🏠 1. Care Overview & Live Activity Feed
- **At-a-Glance Status:** Instantly see who is receiving care (e.g., *Robert Johnson*) and which family caregiver is currently on duty.
- **Chronological Timeline:** Live stream of daily events including blood pressure readings, blood glucose checks, meals, afternoon walks, and completed medication rounds.

### 📅 2. 24/7 Care Schedule & Shift Swapping
- **Interactive Calendar:** Intuitive weekly strip calendar with day selection and dot coverage indicators.
- **Round-the-Clock Shifts:** Distinct shifts (Morning, Afternoon, Night) displaying caregiver name, relationship, duty summary, and direct contact action.
- **Emergency Shift Swap:** Caregivers can request shift exchanges or coverage requests with relatives directly in-app, notifying family members instantly.

### 💊 3. Medication & Appointment Management
- **Segmented Tasks:** Filter between **All**, **Pills**, and **Visits** via Material 3 segmented controls.
- **Pill Tracker:** Dosage specifications, tablet quantities, scheduled intake times, and accountability confirmation (who marked the pill as taken).
- **Medical Visits:** Scheduled appointments with specialist doctors, clinic dates, times, and handled confirmations.
- **Quick-Add Dialogs:** Beautiful, responsive Material 3 dialogs with inline validation to record new prescriptions and appointments.

### 🤖 4. "Sanad" (سَنَد) AI Healthcare Assistant
- **Context-Grounded Assistance:** Powered by **Azure OpenAI** (`gpt-4.1-mini`), Sanad is equipped with the patient's actual medication list and scheduled doctor appointments.
- **Safe & Hallucination-Resistant:** Constrained to provide helpful information exclusively based on verified patient records and medication schedules.

---

## 🛠️ Architecture & Tech Stack

```
Rifq
├── 🎨 Presentation Layer (Screens & Widgets)
│    ├── HomeScreen (Dashboard & Activity Feed)
│    ├── ScheduleScreen (Calendar & Shift Management)
│    ├── TasksScreen (Pills, Visits, Filterable Tasks)
│    └── AssistantScreen (Sanad AI Chat Interface)
│
├── 🧠 Business Logic & State
│    ├── PillService (Medication management & tracking)
│    ├── VisitService (Appointment scheduling & logging)
│    └── AiService (Azure OpenAI integration via ai_sdk_dart)
│
└── ☁️ Infrastructure & Backend
     ├── Supabase Flutter (Cloud database & real-time sync)
     ├── Flutter Dotenv (Secure configuration management)
     └── GitHub Actions CI/CD (Automated tests & APK build workflows)
```

| Technology | Purpose |
|---|---|
| **[Flutter](https://flutter.dev/)** | Cross-platform framework with Material Design 3 |
| **[Supabase](https://supabase.com/)** | Cloud database, authentication, and data synchronization |
| **[Azure OpenAI](https://azure.microsoft.com/)** | High-performance LLM backing the Sanad AI assistant |
| **[ai_sdk_dart](https://pub.dev/packages/ai_sdk_dart)** | Unified AI provider abstraction for Dart |
| **[flutter_dotenv](https://pub.dev/packages/flutter_dotenv)** | Environment variable loading for API keys & endpoints |
| **[Google Fonts](https://pub.dev/packages/google_fonts)** | Modern, readable typography |

---

## 📂 Project Structure

```bash
rifq/
├── android/                   # Native Android configuration (Kotlin DSL, Java 17)
├── lib/
│   ├── main.dart              # Application entrypoint & bottom navigation
│   ├── models/                # Data structures
│   │   ├── care_shift_model.dart # Shift models & statuses
│   │   ├── pill_model.dart       # Medication & dosage definitions
│   │   └── visit_model.dart      # Doctor appointments & clinical visits
│   ├── screens/               # Main UI views
│   │   ├── home_screen.dart      # Care overview & activity timeline
│   │   ├── schedule_screen.dart  # Calendar & caregiver shift roster
│   │   ├── tasks_screen.dart     # Medication & appointment checklist
│   │   ├── assistant_screen.dart # "Sanad" AI conversation screen
│   │   ├── add_pill_screen.dart  # Form dialog for adding medications
│   │   └── add_visit_screen.dart # Form dialog for adding doctor visits
│   ├── services/              # Data services & external integrations
│   │   ├── ai_service.dart       # Azure OpenAI communication service
│   │   ├── pill_service.dart     # Medication state provider
│   │   └── visit_service.dart    # Medical visit state provider
│   └── widgets/               # Reusable UI components
│       ├── care_shift_card.dart  # Shift details card with caregiver avatar
│       ├── shift_swap_dialog.dart# Shift exchange request modal
│       ├── pill_widget.dart      # Interactive pill confirmation card
│       └── visit_widget.dart     # Interactive visit confirmation card
├── test/
│   └── tasks_dialog_test.dart # Widget & form interaction tests
└── pubspec.yaml               # Project dependencies and asset definitions
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your development machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.13.3` or higher)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) with Android SDK & JDK 17
- A [Supabase](https://supabase.com/) project
- An [Azure OpenAI](https://azure.microsoft.com/) resource deployment

### 1. Clone the Repository

```bash
git clone https://github.com/TeamRifq/Rifq.git
cd Rifq/rifq
```

### 2. Configure Environment Variables

Create a `.env` file in the `rifq/` directory:

```bash
touch .env
```

Add your credentials to `.env`:

```ini
# Azure OpenAI Credentials
AZURE_AI_ENDPOINT=https://<your-resource-name>.services.ai.azure.com/openai/v1/responses
AZURE_AI_API_KEY=your_azure_openai_api_key
AZURE_AI_MODEL=gpt-4.1-mini

# Supabase Credentials
SUPABASE_URL=https://<your-project-ref>.supabase.co/
SUPABASE_ANON_KEY=your_supabase_anon_key
```

> ⚠️ **Note:** Never commit the `.env` file containing production secrets to public version control. It is already added to `.gitignore`.

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the Application

```bash
flutter run
```

---

## 🧪 Testing

Run automated widget and unit tests with:

```bash
flutter test
```

To run a specific test suite:

```bash
flutter test test/tasks_dialog_test.dart
```

---

## 🔄 CI/CD Workflows

The repository uses **GitHub Actions** for continuous integration and release delivery:

| Workflow | Trigger | Description |
|---|---|---|
| **[Flutter Build](.github/workflows/build.yml)** | `push` to `main` | Validates dependencies and verifies that the release APK compiles cleanly without errors. |
| **[Publish](.github/workflows/publish.yml)** | `workflow_dispatch` (Manual) | Builds the production release APK with GitHub Secrets injected into `.env` and publishes the downloadable artifact (`app-release.apk`). |

### Setting Up GitHub Actions Secrets

To run the `publish` workflow, add the following secrets under **Repository Settings ➔ Secrets and variables ➔ Actions**:
- `AZURE_AI_ENDPOINT`
- `AZURE_AI_API_KEY`
- `AZURE_AI_MODEL`
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

---

## 🗺️ Roadmap

- [ ] Push notifications & reminders for medication schedules.
- [ ] Emergency SOS one-tap contact trigger for caregivers.
- [ ] Vital sign tracking (blood pressure, glucose, heart rate charts).
- [ ] Multilingual localization (Arabic & English).
- [ ] Multi-patient support for families caring for both parents.

---

## 🤝 Contributing

Contributions, feedback, and suggestions are welcome!

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/CareFeature`).
3. Commit your changes (`git commit -m "feat: add vital signs chart"`).
4. Push to the branch (`git push origin feature/CareFeature`).
5. Open a Pull Request.

---

<h1 align="center">Made in Tuwaiq Academy with ❤️</h1>
