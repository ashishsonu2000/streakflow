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

## 7. Submit together with the app version

The first subscriptions must be reviewed together with an app version, in
**one** draft submission. The version page has no **In-App Purchases and
Subscriptions** section any more; each item is added with its own **Add for
Review** button. The order matters:

1. **Version first**: on the **1.0** version page, with the build selected,
   **Add for Review**. This creates the draft.
2. **Group**: Monetization → Subscriptions → **StreakFlow Premium** →
   **Add for Review**.
3. **Premium Monthly** → **Add for Review**.
4. **Premium Yearly** → **Add for Review**.

Whenever a pop-up asks which submission to use, pick the existing draft.
Open the draft (**App Review** in the sidebar, or the banner at the top),
check it lists **4 items** (version, group, 2 subscriptions), then
**Submit for Review**.

Errors seen (2026-10-28) and what they meant:

| Error | Cause / fix |
|---|---|
| "Your auto-renewable subscription must be submitted with its subscription group." | Each subscription was in its own draft. Delete the extra drafts and redo the order above. |
| "New subscription groups must be submitted with an auto-renewable subscription from within that group." | The group was in the draft but no subscription. Add both subscriptions. |
| "…must be submitted with its subscription group. To submit your items for review, add an app version for the selected platform." | No draft held the version (it was still in review). Remove the version from review, then start again with the version first. |
| No **Add for Review** button on a subscription | Status is **Missing Metadata**: fill in localization, review screenshot or price, **Save**. Also check the group's own App Store Localization. |

### Changing the build after submitting

**Remove from Review** on the version also takes the subscriptions out of the
submission (2026-10-28, swapping build 20 for 21: the resubmitted version went
in alone, as "1 item"). After swapping the build, rebuild the draft with the
order above and check it shows **4 items** before **Submit for Review**. If a
version was already submitted alone, remove it from review and redo the draft;
a submission that is Waiting for Review can't take more items.

Until the first version is approved, don't edit the version or the
subscriptions while they are in review: any change pulls them out of the
queue.

## Review screenshot

- Use an exact **iPhone screenshot size**, e.g. **1179×2556** (the size a
  standard iPhone 14 Pro / 15 / 16 takes, and the size the version's
  screenshot slot accepts; see [APP_STORE_SCREENSHOTS.md](APP_STORE_SCREENSHOTS.md)).
  A 1024×1024 square failed with "The dimensions of one or more screenshots
  are wrong" (2026-10-28), whatever the help text says. JPEG or PNG. Only
  Apple's reviewer sees it; both products can use the same one.
- The **1024×1024** spec ("72 dpi, RGB, flattened and no rounded corners")
  belongs to the optional **promotional image**, not the review screenshot.
  Leave it empty, or use artwork that differs from the app icon (e.g. the
  Premium medal on the paywall gradient).
- Copy it from the iPhone **without WhatsApp** (AirDrop, iCloud Photos, or USB
  with the Windows Photos app). Messaging apps shrink it, e.g. to 591×1280,
  which is too narrow.
- Best screen: the Premium page scrolled to the **Monthly/Yearly plans with
  prices and the Subscribe button**. Prices appear only once the products
  exist and the Paid Apps agreement is Active; until then upload the feature
  list and replace it later.
