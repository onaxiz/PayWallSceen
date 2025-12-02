## SubscriptionTestApp

SwiftUI showcase приложения с онбордингом → paywall → основным экраном, построенное полностью на кастомной дизайн‑системе с градиентным фоном и стеклянными карточками.

### Превью

<div align="center">
  <img src="Screenshots/Simulator Screenshot - iPhone 16 - 2025-12-02 at 06.59.16.png" width="240" alt="Onboarding screen" />
  <img src="Screenshots/Simulator Screenshot - iPhone 16 - 2025-12-02 at 06.59.32.png" width="240" alt="Paywall screen" />
  <img src="Screenshots/Simulator Screenshot - iPhone 16 - 2025-12-02 at 06.59.55.png" width="240" alt="Main screen" />
  <img src="Screenshots/Simulator Screenshot - iPhone 16 - 2025-12-02 at 07.00.02.png" width="240" alt="Main recommendations" />
</div>

### Особенности

- Строгая типографика (`AppTypography`) и единая палитра/материалы (`AppTheme`) для всего приложения.
- Онбординг c TabView, кастомными индикаторами и стеклянными карточками.
- Paywall с сегментированным выбором плана, стабильным макетом и анимированными CTA‑кнопками.
- Главный экран с карточками рекомендаций, статусом подписки и debug‑кнопкой.
- Лёгкая замена мок‑логики: `AppStateViewModel` управляет потоком и хранит состояние подписки через `SubscriptionStorage`.

### Архитектура

```
SubscriptionTestApp/
├── SubscriptionTestAppApp.swift        # Точка входа, инжектит AppStateViewModel
├── ViewModel/AppStateViewModel.swift   # Логика потока и подписки
├── Services/SubscriptionStorage.swift  # Простейшее хранилище (UserDefaults)
├── View/OnboardingView.swift           # Стек экранов онбординга
├── View/PaywallView.swift              # Экран подписки с планами и CTA
├── View/ModelView.swift                # Основной экран
├── View/RootView.swift                 # Переключает состояния флоу
└── View/DesignSystem.swift             # Палитра, стеклянные карточки, типографика
```

### Запуск

1. Требования: Xcode 16.4+, iOS 18 SDK.
2. `open SubscriptionTestApp.xcodeproj`.
3. Выберите схему **SubscriptionTestApp** и запустите на симуляторе/устройстве.
4. Пройдите онбординг, "купите" план (покупка эмулируется) и попадите на главный экран.

### Идеи для развития

- Подключить StoreKit 2 и заменить мок‑оплату.
- Добавить дополнительные планы, бейджи промо и локализацию.
- Вынести типографику/палитру в отдельный Swift Package и переиспользовать в других проектах.
