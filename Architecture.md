# Database Schema & Technical Architecture

## 1. Database: Firestore (NoSQL)

### Collection: `users`
- `uid`: String (Unique ID)
- `email`: String
- `preferences`: Object { notifications: Boolean, currency: String }

### Collection: `inventory`
- `id`: String
- `owner_id`: String (links to user)
- `name`: String
- `category`: String (Kitchen | Medicine | Groceries)
- `barcode`: String
- `mrp_stored`: Float
- `quantity`: Float
- `unit`: String (kg, ltr, pcs)
- `storage_location`: String
- `batches`: Array of Objects:
    - `expiry_date`: Timestamp
    - `purchased_date`: Timestamp
    - `billed_price`: Float

### Collection: `bills`
- `id`: String
- `user_id`: String
- `date`: Timestamp
- `store_name`: String
- `total_amount`: Float
- `image_url`: String (Firebase Storage path)
- `items_detected`: Array [ { name: String, price: Float } ]

## 2. Logic Flow: Shopping Alert
1. User enters "Shopping Mode".
2. User scans Barcode `890123456`.
3. Query `inventory` where `barcode == '890123456'`.
4. If `result.quantity > 0`:
    - Display Alert: "In Stock: ${result.quantity} ${result.unit}".
5. Else:
    - Add to "To Buy" list.

## 4. Global Expansion & Monetization

### A. Localization Engine
- **Geo-IP Detection:** Detect user country to switch between service providers (e.g., Blinkit in India, Walmart in USA).
- **Currency Support:** Automatic conversion and formatting based on local locale.

### B. Global Price Comparison (GPC) Module
- **Sources:**
    - **Online APIs:** RapidAPI, Amazon Associates API, Grocery Data APIs.
    - **Local Apps:** Integration with Blinkit, Zepto, Instamart (via EarnKaro/Coupon Aggregators for India; Direct for Global).
    - **Offline:** Crowdsourced pricing from user bill scans.
- **Affiliate Manager:**
    - Logic to append `affiliate_id` or `coupon_link` to every "Buy Now" or "Refill" link.
    - Integration with third-party aggregators (e.g., EarnKaro API) for India.
    - Tracking of click-through rates (CTR) for revenue analysis.

### C. Medicine 'Smart-Refill' Logic
- **Dosage Profile:** User sets `frequency` (e.g., 2/day) and `start_count` (e.g., 30).
- **Background Worker:** A daily cron-job (WorkManager on Android) that decrements `current_count` by `frequency`.
- **Refill Trigger:** `if (current_count <= 4) -> Send Notification`.
- **Manual Override:** "I forgot to take my medicine" button adds the dosage back to the count.

## 5. Deployment & Responsiveness
- **Framework:** Flutter (Material 3).
- **Adaptive Layout:** Use `LayoutBuilder` to switch between Mobile (Portrait) and Tablet/Foldable (Landscape/Multi-pane) views.
- **Target:** Android SDK 21+ (95% of active devices).
