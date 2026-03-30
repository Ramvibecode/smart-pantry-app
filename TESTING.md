# How to Test SmartPantry

As we develop the app, you can test it in three different ways:

## 1. Logic & Feature Testing (Immediate)
I have created a **"Guardian Simulator"** script. You can run this right now if you have the Dart SDK installed to see how the "Stock Alert" logic works.
- **File:** `test/guardian_logic_test.dart`
- **What it tests:** Scanning an item at the store, checking home stock, and triggering the alert.

## 2. Generate Your Own APK (Automated Build)
Since I am an AI and cannot send a large binary file directly through chat, I have set up an **Automated Build System** for you.
- **How to get the APK:**
    1. Create a new repository on **GitHub**.
    2. Upload all the files from this project (including the `.github` folder).
    3. Go to the **"Actions"** tab in your GitHub repository.
    4. You will see a workflow named **"Build Android APK"** running.
    5. Once it finishes (about 2 minutes), click on the run and download the **`app-release.apk`** from the **Artifacts** section at the bottom.
    6. Transfer it to your phone and install!

## 3. Website & Marketing Review (Web)
I have built a modern **Landing Page**. You can open this file in any web browser to see how the app will be marketed.
- **File:** `LandingPage.html`
- **What it tests:** Marketing hook, feature explanation, and mobile-responsiveness.

---

# Frequently Asked Questions

### 1. How will the Medicine Refill work?
**No manual daily entry.**
- **Setup:** Scan the medicine. Enter "1 pill, 2 times a day." Total: 30 pills.
- **Automation:** Every 24 hours, the app's background worker (WorkManager) subtracts 2 from the count.
- **Alert:** When the count hits 4, the app notifies you: *"Only 2 days left! Should I reorder from Amazon/Blinkit?"*
- **Adjustment:** If you skip a dose, you just tap the "Skipped Today" button on the dashboard to keep the count accurate.

### 2. Global Price Comparison & Affiliates
**How we earn money:**
We will use **Deep-linking** and **Affiliate IDs**.
- When the app suggests a "Refill," it won't just say "Buy Milk." It will say "Buy Milk on **Amazon** (\$4.99) or **Blinkit** (\$5.10)."
- When the user clicks, they are taken to the store app with **your affiliate code** attached.
- You earn a commission (typically 1% to 8%) on the total purchase value.

### 3. Will it work in all countries?
**Yes.** The app uses **Geo-IP detection** to switch its price-fetching engine.
- If in **India**: Connects to APIs for Blinkit/Zepto/Instamart.
- If in **USA**: Connects to APIs for Walmart/Amazon/Target.
- If in **UK**: Connects to Tesco/Sainsbury APIs.
