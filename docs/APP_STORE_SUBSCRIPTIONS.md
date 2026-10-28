# App Store Subscriptions — StreakFlow Premium (iOS)

Setting up StreakFlow Premium in App Store Connect. The product IDs must
match `PremiumConfig.appStoreMonthlyProductId` / `appStoreYearlyProductId`
(`lib/core/entitlements/premium_config.dart`). Background:
[IOS_LAUNCH.md](IOS_LAUNCH.md), [CODEMAGIC_IOS_SETUP.md](CODEMAGIC_IOS_SETUP.md)
step 12.

The App Store has no base plans: each duration is its own auto-renewable
subscription, and both go in **one** subscription group so a user can hold
only one of them.

## 1. Create the group

1. <https://appstoreconnect.apple.com> → **Apps** → **StreakFlow**.
2. Left sidebar → **Monetization** → **Subscriptions**.
3. Next to **Subscription Groups** → **Create** (or **+**).
4. Reference Name: `StreakFlow Premium` (only you see it) → **Create**.

## 2. Monthly subscription

1. Inside the group → **Create** next to **Subscriptions**:
   - Reference Name: `Premium Monthly`
   - Product ID: `streakflow_premium_monthly` — exactly this. **It can't be
     changed or ever reused.**
2. **Create**; the product page opens.
3. **Subscription Duration**: **1 Month**.
4. **Availability**: all countries (or the same as the app).
5. **Subscription Prices** → **Add Subscription Price**:
   - Country: India (INR); pick the price point closest to Google Play's
     ₹100 (usually ₹99).
   - **Next** → Apple fills in the other countries → keep or adjust →
     **Confirm**.
6. **App Store Localization** → **+** → English (U.S.):
   - Display Name (max 30): `Premium Monthly`
   - Description (max 55): `Unlimited habits, insights, reports and themes`
7. **Review Information**:
   - Screenshot: the Premium screen (see [Review screenshot](#review-screenshot)).
   - Review Notes (optional): `Unlocks StreakFlow Premium features. Settings → Premium.`
8. **Save**.

## 3. Yearly subscription

Back in the group, repeat step 2 with:

| Field | Value |
|---|---|
| Reference Name | `Premium Yearly` |
| Product ID | `streakflow_premium_yearly` |
| Duration | **1 Year** |
| Price | closest to Google Play's ₹600 (e.g. ₹599) |
| Display Name | `Premium Yearly` |
| Description | `Unlimited habits, insights, reports and themes` |

## 4. Group settings

1. **Subscription levels**: drag **Premium Yearly** above **Premium Monthly**
   (Yearly = Level 1). Monthly → Yearly is then an upgrade (takes effect
   immediately); Yearly → Monthly a downgrade (takes effect at the next
   renewal).
2. Group **App Store Localization** (required, easy to miss): **+** →
   English (U.S.) → Subscription Group Display Name `StreakFlow Premium`, App
   Name Display Options **Use App Name** → **Save**.

## 5. Leave off

- **Introductory / promotional offers**: off. V1 sells the standard price
  only, as on Android.
- **Family Sharing**: off. **Once turned on, it can't be turned off.**

## 6. Check

- Both products show **Ready to Submit**. **Missing Metadata** → open the
  product and fill in what it flags (usually localization, review screenshot
  or price).
- **Business → Agreements**: the **Paid Apps** agreement must be **Active**
  (tax and bank details filled in). Until then purchases don't work in
  Sandbox or TestFlight.
- New products can take up to about an hour to appear in the app.

## 7. Attach to the app version

The first subscriptions must be reviewed together with an app version: on
the **1.0** version page, after selecting the build, **In-App Purchases and
Subscriptions** → **+** → add both products.

## Review screenshot

- Use an exact **iPhone screenshot size**: **1290×2796** (6.9"), or
  1242×2688 (6.5") if that is refused. Other sizes, including a 1024×1024
  square, fail with "The dimensions of one or more screenshots are wrong"
  (seen 2026-10-28), whatever the help text says. JPEG or PNG. Only Apple's
  reviewer sees it; both products can use the same one.
- A screenshot from a standard iPhone (1179×2556) or a shrunk copy has nearly
  the same proportions, so it can be resized to 1290×2796 without visible
  stretching.
- Copy it from the iPhone **without WhatsApp** (AirDrop, iCloud Photos, or USB
  with the Windows Photos app). Messaging apps shrink it, e.g. to 591×1280,
  which is too narrow.
- Best screen: the Premium page scrolled to the **Monthly/Yearly plans with
  prices and the Subscribe button**. Prices appear only once the products
  exist and the Paid Apps agreement is Active; until then upload the feature
  list and replace it later.
