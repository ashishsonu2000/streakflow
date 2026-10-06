# StreakFlow Premium — Subscription Architecture

How the subscription list is maintained, how entitlement is decided, and how
features are unlocked per plan. For Play Console setup and the release test
checklist see [PREMIUM_SETUP.md](PREMIUM_SETUP.md).

---

## 1. Overview

- **Plans:** Free and Premium. Premium is one Google Play subscription,
  `streakflow_premium`, with two auto-renewing base plans: `monthly` and `yearly`.
- **Source of truth:** Google Play. The app keeps **no subscriber list**. Play
  knows which Google accounts own an active subscription; the app asks Play.
- **No backend, no user accounts.** Premium is tied to the Google account
  signed in to Play on the device, so it follows the user across reinstalls
  and devices with the same account.
- **On device** the app stores only one fact: "Play confirmed Premium at
  `<time>`" (no purchase tokens, order IDs or personal data).

```
┌──────────────┐  query / buy / acknowledge  ┌──────────────────────┐
│ Google Play  │◄───────────────────────────►│ PlayBillingGateway   │
│ (subscribers)│                             └──────────┬───────────┘
└──────────────┘                                        │ BillingPurchase
                                                        ▼
                                             ┌──────────────────────┐
                                             │ PremiumStoreNotifier │  only code that
                                             │  (premium_store.dart)│  grants / revokes
                                             └──────────┬───────────┘
                                   grant / revoke        │
                                                        ▼
            ┌────────────────────┐  read/write  ┌──────────────────────┐
            │ EntitlementCache   │◄────────────►│ entitlementProvider  │ free | premium
            │ (SharedPreferences)│              └──────────┬───────────┘
            └────────────────────┘                         ▼
                                             ┌──────────────────────┐
                                             │ featureAccessProvider│ FeatureAccess policy
                                             └──────────┬───────────┘
                         ┌──────────────┬───────────────┼───────────────┬──────────────┐
                         ▼              ▼               ▼               ▼              ▼
                    UI widgets     PremiumGate     HabitLimitGuard   Reminders       Ads
                   (lock/unlock)  (upgrade sheet)  (domain rule)    (resync)     (hidden)
```

---

## 2. Files

| Layer | File | Responsibility |
|---|---|---|
| Config | `lib/core/entitlements/premium_config.dart` | Free habit limit (20), reminders per habit (1 / 5), product & base plan IDs, offline grace (7 days), recheck interval (6 h), purchase result wait (4 s) |
| Catalogue | `lib/core/entitlements/premium_feature.dart` | `PremiumFeature` enum: every Premium capability with title + description (shown on paywall) |
| Policy | `lib/core/entitlements/feature_access.dart` | `FeatureAccess`: `canUse`, `activeHabitLimit`, `canAddActiveHabit`, `remindersPerHabit` |
| Cache | `lib/core/entitlements/entitlement_cache.dart` | `EntitlementRecord {productId, verifiedAt}` in SharedPreferences key `premium_entitlement_v1` |
| State | `lib/core/entitlements/entitlement_provider.dart` | `entitlementProvider` (free/premium), `featureAccessProvider` |
| Store interface | `lib/core/billing/billing_gateway.dart` | `BillingGateway`, `StorePlan`, `BillingPurchase`, `UnavailableBillingGateway` |
| Play implementation | `lib/core/billing/play_billing_gateway.dart` | `in_app_purchase` / Play Billing Library 8 mapping |
| Orchestrator | `lib/core/billing/premium_store.dart` | Purchase, pending, restore, reconcile, acknowledge |
| UI | `lib/features/premium/` | Paywall page, upsell sheet, `PremiumGate`, Settings tile |
| Lifecycle | `lib/shell/presentation/pages/main_shell.dart` | Calls `initialize()` on start and `onAppResumed()` on resume |

---

## 3. How the subscription list is maintained

### 3.1 Where subscribers live

Google Play maintains the subscriber list, billing, renewals, grace periods,
account holds, cancellations and refunds. Manage plans and prices in
Play Console → Monetize with Play → Products → Subscriptions. View
subscribers, orders and refunds in Play Console → Order management and
the subscription reports.

### 3.2 How the device learns its status

The device reconciles with Play (`_reconcileWithStore()`) at these moments:

| Trigger | Where |
|---|---|
| App start (after reaching the main shell) | `MainShell` → `premiumStoreProvider.notifier.initialize()` |
| Opening the Premium page | `PremiumPage` → `initialize()` (runs once) |
| App returns to foreground, last successful check ≥ 6 h old | `MainShell` → `onAppResumed()` |
| Purchase sheet closed but no result within 4 s | `onAppResumed()` |
| User taps **Restore purchases** | `restore()` |
| Purchase error (e.g. "item already owned") | `_onPurchaseUpdates()` |

### 3.3 Reconciliation rules

`queryOwnedPurchases()` asks Play for purchases owned by this account:

| Play result | Action |
|---|---|
| Active `streakflow_premium` (purchased / restored) | **Grant**: write cache with `verifiedAt = now`, state = premium, acknowledge if needed |
| Only pending purchase | Stay Free, show "payment pending" |
| Query succeeded, no active purchase (expired, cancelled after period end, refunded) | **Revoke**: clear cache, state = free |
| Query failed (offline, Play error) → `null` | **No change**: keep cached entitlement |

### 3.4 Purchase flow

1. Paywall loads plans via `loadPlans()` (base offers only, localized Play prices).
2. `buy(plan)` launches the Play sheet; result arrives on `purchaseUpdates`.
3. `_onPurchaseUpdates` handles each status:
   - `purchased` / `restored` → grant, acknowledge, "Welcome to StreakFlow Premium!"
   - `pending` → never grants; message tells user Premium unlocks when Play confirms
   - `canceled` → button re-enabled, no message
   - `error` → re-checks Play first (may already own it), else "not charged" message
4. **Acknowledgement**: `_completeIfNeeded` acknowledges every completed
   purchase. Play auto-refunds purchases not acknowledged within 3 days. A failed
   acknowledge is retried at the next reconciliation.
5. A Play purchase is never treated as paid unless Play's own
   `purchaseState == PURCHASED` (guard in `PlayBillingGateway._toBilling`).

### 3.5 Offline behaviour

When the app starts, `EntitlementNotifier.build()` reads the cache. Premium is
active if `verifiedAt` is within the last **7 days** (`offlineGracePeriod`).
Clock tampering is limited: a `verifiedAt` more than one day in the future is
rejected. After 7 days without a successful Play check the user drops to Free
until the next successful check.

### 3.6 Lifecycle scenarios

| Scenario | Result |
|---|---|
| New purchase | Premium immediately |
| Reinstall / new phone, same Google account | Restored automatically on start (or Restore button) |
| User cancels in Play | Premium until the paid period ends, then revoked at next check |
| Renewal | Nothing to do; Play keeps reporting active |
| Payment failure (Play grace period / account hold) | Follows what Play reports as owned |
| Refund | Revoked at next successful check |
| Offline | Premium kept up to 7 days |
| App killed during purchase | Purchases rechecked on resume |

---

## 4. How features are unlocked per plan

### 4.1 Feature matrix

| Feature | Free | Premium | Enforced in |
|---|---|---|---|
| Habit tracking, streaks, calendar, dashboard, basic stats | ✅ | ✅ | — |
| Existing 12 achievements | ✅ | ✅ | — |
| Active habits | 20 | Unlimited | `HabitLimitGuard`, `PremiumGate.canAddActiveHabit` |
| Ads | Shown (when enabled) | None | `ad_providers.dart`, `ads_controller.dart` |
| Productivity score | — | ✅ | `statistics_page.dart` |
| Advanced insights | — | ✅ | `statistics_page.dart` |
| Weekly / monthly reports | — | ✅ | `statistics_page.dart` |
| Premium color themes | Classic only | ✅ | `app_color_theme.dart`, `appearance_bottom_sheet.dart` |
| Advanced achievements (5) | Visible, locked | ✅ | `achievements_provider.dart` |
| CSV export | — | ✅ | `backup_page.dart`, `backup_providers.dart` |
| Reminders per habit | 1 | 5 | `habit_reminder_tile.dart`, `notification_usecase_provider.dart`, `reminder_entitlement_sync.dart` |

### 4.2 The one rule

> UI, use cases and services **never** check the plan directly. They ask
> `FeatureAccess` (via `featureAccessProvider`) or `PremiumGate`.

Only the ads layer reads `entitlementProvider` directly, because "Premium =
no ads" is a store-level rule.

### 4.3 Three gating patterns

**a) Reactive UI: lock/unlock or hide.** `watch` rebuilds the widget the
moment the plan changes (purchase, restore, expiry):

```dart
final unlocked = ref
    .watch(featureAccessProvider)
    .canUse(PremiumFeature.premiumThemes);
```

**b) Action gate: show the upgrade sheet** before a Premium action:

```dart
if (!await PremiumGate.canUse(context, ref, PremiumFeature.csvExport)) {
  return;
}
// proceed with export
```

For habits: `PremiumGate.canAddActiveHabit(context, ref)`.

**c) Domain enforcement**, so the rule holds even if a UI path forgets to gate:

```dart
await ref.read(habitLimitGuardProvider).ensureCanAddActiveHabit();
// throws HabitLimitReachedException at the Free limit
```

`HabitLimitGuard` covers create, duplicate, onboarding suggestions and
unarchive. Editing, completing, archiving and deleting are never limited;
habits already above the limit are never locked.

### 4.4 Effects when the plan changes

- **Ads:** `ads_controller.dart` listens to `entitlementProvider`. Premium skips
  the ad SDK; dropping to Free makes ads available again.
- **Reminders:** `reminderEntitlementSyncProvider` reschedules when
  `remindersPerHabit` changes. On Free only the primary reminder is
  scheduled; extra times are **kept** in `HabitEntity.additionalReminderMinutes`
  and resume when Premium returns.
- **Themes:** a Premium theme falls back to Classic on Free.
- **Data is never deleted** on downgrade.

---

## 5. Adding a new Premium feature

1. Add an entry to `PremiumFeature` (title + description appear on the paywall).
2. If it has a numeric limit, add constants to `PremiumConfig` and a getter on
   `FeatureAccess` (follow `remindersPerHabit`).
3. Gate the UI with `ref.watch(featureAccessProvider)` and/or `PremiumGate.canUse`.
4. If it protects data or a limit, enforce it in the use case/service too
   (inject `FeatureAccess Function()` like `HabitLimitGuard`).
5. Decide downgrade behaviour: keep data, stop using it, resume on upgrade.
6. Add the row to the matrix in §4.1 and in `PREMIUM_SETUP.md`.
7. Tests: `test/core/entitlements/entitlements_test.dart` plus the feature's tests.

### Changing limits or plans

- Free habit limit / reminder counts → `PremiumConfig` only.
- New base plan (e.g. `quarterly`) → create + activate in Play Console;
  add an ID to `PremiumConfig` and ordering/title to `PlayBillingMapping`.
  Plans are loaded from Play, so prices never live in code.
- Free trial / intro offer → currently excluded (`offerId != null` is skipped
  in `loadPlans`); supporting offers needs a change there and on the paywall.

---

## 6. Development & testing

**Debug-only overrides** (ignored in release builds):

- `--dart-define=DEV_ENTITLEMENT=premium`
- Settings → Testing → Ads Test → **Simulate premium**

**Unit tests:**

| Test | Covers |
|---|---|
| `test/core/entitlements/entitlements_test.dart` | `FeatureAccess`, cache validity, grant/revoke |
| `test/core/billing/premium_store_test.dart` | Purchase, pending, cancel, error, restore, reconcile, resume (fake gateway) |
| `test/core/billing/play_billing_mapping_test.dart` | Plan titles, ordering, period labels |
| `test/features/premium/premium_page_test.dart` | Paywall UI states |
| `test/features/habits/domain/services/habit_limit_guard_test.dart` | Habit limit |

**Real purchases:** license-tester account, app installed from a Play testing
track (not sideloaded), and a release build smoke-tested first. Full checklist
in `PREMIUM_SETUP.md` §4.

---

## 7. Known limitations & roadmap

| Limitation | Impact | Future fix |
|---|---|---|
| No server-side receipt verification | A rooted/patched device could fake Premium (local features only) | Backend verifies purchase tokens with the Google Play Developer API |
| No Real-time Developer Notifications | Cancellations/refunds noticed only at next device check (≤ 6 h while open, or next start) | Pub/Sub RTDN → backend |
| Android only | iOS uses `UnavailableBillingGateway` | App Store subscriptions via a second `BillingGateway` implementation |
| No trials/intro offers | Base plans only | Extend `loadPlans` + paywall |

**When Sync (Premium-only) is built** after launch, the server becomes the
source of truth for server features: the app sends the purchase token, the
backend verifies it with Play, stores the subscription state per user,
updates it from RTDN, and checks it before serving Sync. On-device gating
(§4) remains for local features.
