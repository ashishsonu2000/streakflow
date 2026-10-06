# StreakFlow Premium — Developer & Play Console Guide

Free + StreakFlow Premium, sold as a Google Play subscription
(`in_app_purchase` 3.3.1 / `in_app_purchase_android` 0.5.3, Google Play
Billing Library 8). No external payment gateway, no backend.

For how entitlement and feature gating work internally, see
[SUBSCRIPTION_ARCHITECTURE.md](SUBSCRIPTION_ARCHITECTURE.md).

---

## 1. Architecture

```
lib/core/entitlements/
  premium_config.dart        freeHabitLimit (20), product & base plan IDs, offline grace (7 days)
  premium_feature.dart       catalogue of Premium features (titles shown on the paywall)
  feature_access.dart        the policy: canUse(feature), canAddActiveHabit(count)
  entitlement_cache.dart     last Play-verified entitlement (SharedPreferences, no tokens)
  entitlement_provider.dart  entitlementProvider (free/premium) + featureAccessProvider
lib/core/billing/
  billing_gateway.dart       store interface (+ UnavailableBillingGateway)
  play_billing_gateway.dart  Google Play implementation (Android)
  premium_store.dart         purchase / pending / restore / reconcile / acknowledge
lib/features/premium/        paywall page, upgrade sheet, PremiumGate, Settings tile
```

**Rules**

- Only `PremiumStoreNotifier` grants or revokes Premium, and only from
  Google Play purchase data. There is no other path to Premium in a
  release build.
- `purchased`/`restored` → grant + acknowledge. `pending` → never grants.
- Startup and "Restore purchases" query Play: active subscription →
  grant; definitely none → revoke (expired/cancelled/refunded);
  query failed (offline) → keep the cached entitlement for up to 7 days.
- UI never checks the tier directly: it asks `featureAccessProvider`
  or `PremiumGate`.
- The Free habit limit is enforced in the domain (`HabitLimitGuard`) on
  create, duplicate, onboarding suggestions and unarchive. Existing
  habits are never locked; editing/completing/archiving/deleting are
  never limited.

## 2. Feature matrix

| Feature | Free | Premium |
|---|---|---|
| Habit tracking, streaks, calendar, reminders, dashboard | ✅ | ✅ |
| All existing statistics & basic insights | ✅ | ✅ |
| Existing 12 achievements | ✅ | ✅ |
| Active habits | 20 | Unlimited |
| Ads | Banners (when ads enabled) | None |
| Productivity score | — | ✅ Statistics |
| Advanced insights | — | ✅ Statistics |
| Weekly / monthly reports (share) | — | ✅ Statistics |
| Color themes (Ocean, Forest, Sunset, Berry, Midnight) | Classic only | ✅ Settings → Appearance |
| Advanced achievements (5) | Visible, locked | ✅ |
| CSV export | — | ✅ Settings → Backup & Restore |
| Reminders per habit | 1 | Up to 5 (Habit → Edit → "Add reminder time") |

## Multiple reminders (Premium)

- Stored in `HabitEntity.additionalReminderMinutes` (minutes since
  midnight). Additive Isar field: data from older versions loads with an
  empty list — verified by `test/features/habits/data/schema_upgrade_test.dart`,
  which writes with the previous schema (from git history) and reopens
  with the current one.
- The original reminder keeps its notification ID (slot 0); extra slots
  use stable FNV-1a IDs; every reminder carries the payload
  `habit:<id>` so all of a habit's reminders can be cancelled.
- Free: only the primary reminder is scheduled; extra times are kept and
  resume when Premium returns (`reminderEntitlementSyncProvider`).
- Archive / delete cancel a habit's reminders; restore and undo-delete
  reschedule them.
- `reminderScheduleVersion` (SharedPreferences) triggers a one-time
  reschedule of all reminders after an update that changes scheduling.

## 3. Google Play Console setup

1. **Payments profile**: Play Console → Settings → Payments profile →
   create / link a merchant account (needed before selling).
2. **Upload a build with the billing permission** (this build) to
   Internal or Closed testing. Products can only be created once Play
   has seen `com.android.vending.BILLING` in an uploaded bundle.
3. **Create the subscription**: Monetize with Play → Products →
   Subscriptions → Create subscription
   - Product ID: `streakflow_premium` (must match `PremiumConfig`)
   - Name: StreakFlow Premium
4. **Add base plans** (auto-renewing):
   - `monthly` — billing period 1 month
   - `yearly` — billing period 1 year
   Set prices (Play converts per country), then **Activate** each base plan.
   Offers (free trials, intro prices) are optional; this release shows
   base plans only.
5. **License testing**: Settings → License testing → add tester Gmail
   accounts, response "RESPOND_NORMALLY". Test subscriptions renew
   every few minutes and cost nothing.
6. **Testers install from the Play testing track** (not a sideloaded
   debug APK) and must be signed in to Play with a license-tester
   account.
7. **Store listing / policy**:
   - App content → Ads: keep in sync with AdMob status.
   - Data safety: purchase history is processed by Google Play; the app
     stores only "Premium verified at <time>" locally.
   - The paywall already states price, period, auto-renewal and how to
     cancel.

## 4. Testing checklist (license tester, Play-installed build)

**Last run: 2026-10-06**, release APK 1.0.0+12 sideloaded on the
Pixel_API_35 emulator, signed in with a license-tester account (real Play
test purchases, no charge). No crashes; 145 Premium-related unit tests pass.

- [x] Premium page shows Monthly and Yearly with Play prices
  — Monthly ₹100.00, Yearly ₹600.00
- [x] Subscribe → Play sheet → success → Premium unlocks, ads disappear
  — "Welcome to StreakFlow Premium!"; Settings tile "Active"; 21st habit
  and CSV export unlocked. Ad removal not checked visually on the emulator.
- [ ] Slow test card ("approves after a few minutes") → "Payment pending", no Premium until approved
  — **Not tested**: Play offered only "always approves", "always
  declines" and "approves then charges back" cards. Covered by
  `premium_store_test.dart` only.
- [x] Declined test card → error message, stays Free
  — Play showed "Declined by always denied test instrument"; app stayed
  Free and Subscribe re-enabled.
- [x] Uninstall/reinstall → Premium restored automatically on start
- [ ] Restore purchases on a second device (same account)
  — **Not tested** (one emulator). Restore button verified on the same
  device: Free → "No active … subscription was found"; Premium →
  "has been restored".
- [x] Cancel in Play → after the (test) period ends, next start → Free
  — Cancelled via "Manage subscription in Google Play"; Free on the next
  start ~1.5 min after the 5-min test period ended; CSV locked again.
- [x] Airplane mode with Premium → stays Premium (≤7 days)
  — Cold start offline stayed Premium. (Restore also succeeds offline:
  Play answers from its on-device cache.)
- [x] Free: 21st active habit (limit `PremiumConfig.freeHabitLimit` = 20) → upgrade sheet; unarchive at limit → upgrade sheet
  — 21st habit blocked via Duplicate and the + button. Unarchive at the
  limit not exercised.

Also verified: dismissing the Play sheet without paying re-enables
Subscribe with no error; CSV export shows the upsell on Free.

Still to run on a real phone with the Play-installed build: slow/pending
card (if offered), second-device restore, unarchive at the limit, ads
disappearing after purchase.

## 5. Development helpers (debug builds only)

- Settings → Testing → Ads Test → **Simulate premium**
- `--dart-define=DEV_ENTITLEMENT=premium`
- Emulators without a signed-in Play account report "Google Play Billing
  is not available on this device" — expected.
