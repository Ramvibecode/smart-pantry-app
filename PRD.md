# Product Requirements Document: SmartPantry (Working Name)

## 1. Core Concept
A proactive inventory and budget management app that prevents over-buying and audits grocery bills against advertised MRPs.

## 2. Target Audience
- Frugal shoppers looking to save money.
- Large households/Moms managing multiple categories (Kitchen, Medicine, Groceries).
- Users who forget what they already have at home.

## 3. Key Features
### A. Hybrid Inventory System
- **Categories:** Kitchen (Food), Medicine (Health), Groceries (Household).
- **Batch Tracking:** If you buy milk on Monday and Wednesday, track them as two separate expiry dates.
- **Storage Locations:** Detailed mapping (e.g., "Fridge -> Drawer 2").

### B. Proactive Shopping Mode (The "Guardian")
- **Scanning Alert:** When a user scans an item at the store, the app checks the current stock.
- **Trigger:** If `Stock > 0`, show a popup: "Wait! You have 2 units at home. Still want to buy?"

### C. Bill Auditing (OCR)
- **Scan Receipt:** Extract store name, item names, and prices.
- **Price Audit:** Compare `Billed Price` from receipt with `Stored MRP` from the barcode database.
- **Discrepancy Report:** Highlight items where the store charged more than the expected price.

### D. Expiry Management
- High-priority notifications for medicines.
- "Eat me first" suggestions for food near expiry.

## 4. Technical Constraints (Android Focus)
- **Framework:** Flutter (Recommended for fast Android UI).
- **Scanning:** Google ML Kit (On-device, free).
- **Backend:** Firebase (Auth, Firestore, Storage).
