# Dynamic Real Estate "Editorial Blueprint" Listing App - UI & State Implementation Plan

This implementation plan details the architecture, UI layout, and Riverpod state management strategy to build the first high-fidelity feature of the real estate listing and valuation data capture tool. 

The application utilizes a **feature-based folder structure** and **Riverpod** state management to support a linear, responsive 6-step architectural journey. It will run in a mobile-first responsive layout with clean, editorial styling (Inter typography, tight tracking, bottom-border input fields, and easily-swappable color palettes for any real estate brand, defaults to Crimson red).

---

## User Review Required

> [!IMPORTANT]
> **Key Design Decisions:**
> 1. **Linear and Room-by-Room Flow Integration**: Clicking on any Room Card in Step 4 (e.g. "Bedroom 1") will open the detailed **Room Configuration Screen** (Screen 4.2). Completing or modifying any details in Screen 4.2 will change its state from **PENDING** to **COMPLETE**, and saving it will return the user to the list in Screen 4.1.
> 2. **State Persistence**: A single unified Riverpod state provider will manage the wizard progress, entered text fields, selected chips, room lists, and individual room details. This ensures complete data integrity across all screens.
> 3. **Dynamic Branding & Themes**: Rather than hardcoding Keller Williams crimson branding, all colors, fonts, and assets will be loaded from a centralized `themes.dart`. This lets the application easily adapt to any other real estate brand's design system.
> 4. **Shared Componentry**: A dedicated reusable widgets folder is included to extract core UI elements (e.g. custom wizard buttons, cards, selector chips, and text inputs) for consistency and clean architecture.

---

## Proposed Changes

We will create a new Flutter application in `C:\Users\dylan\.gemini\antigravity\scratch\realestate_app` and structure it with a clean **feature-based Riverpod architecture** and **reusable core components**.

### 1. Core Project Configuration

#### [NEW] [pubspec.yaml](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/pubspec.yaml)
- Add required dependencies:
  - `flutter_riverpod` (State management)
  - `google_fonts` (For high-end typography like Inter)
  - `cupertino_icons` (For premium, clean modern iconography)

---

### 2. Core Foundation & Shared Components
Common folder structures for themes and reusable components:

#### [NEW] [themes.dart](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/core/theme/themes.dart)
- Defines dynamic, professional color palettes for multiple real estate brands.
- Houses primary action color configurations (e.g. Crimson red, dark grey, slate), background grays (Zinc/Stone), semantic tags (green for Complete, orange for Pending).
- Provides text styles (Inter, precise weights/tracking) and container styles (border radius, custom dotted borders).

#### [NEW] [Reusable Widgets Folder](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/core/widgets/)
Includes:
- `custom_card.dart`: Reusable card containers with clean thin borders and soft background shading.
- `custom_chip.dart`: Fully theme-aware selection chips (both horizontal wraps and lists).
- `custom_button.dart`: Signature buttons (e.g. large red "Next" with arrow chevron, grey "Save Draft", and simple text buttons).
- `custom_text_input.dart`: High-end text input with light bottom-border-only or rounded card borders as per the PRD specification.

---

### 3. Feature Structure (Property Wizard)
The listing wizard feature will be organized under `lib/features/property_wizard/`:

```
lib/
  main.dart
  core/
    theme/
      themes.dart             (Shared theme system)
    widgets/                  (Shared reusable widgets)
      custom_card.dart
      custom_chip.dart
      custom_button.dart
      custom_text_input.dart
  features/
    property_wizard/
      data/
        models/
          room_model.dart          (Individual room configuration)
          property_state_model.dart (Whole wizard state)
      presentation/
        controllers/
          property_controller.dart  (Riverpod Notifier for wizard state)
        views/
          property_wizard_shell.dart (Main layout wrapper with generic header/footers)
          property_type_step.dart    (Step 1: Property Type & Subtypes)
          address_step.dart          (Step 2: Autocomplete & Details)
          building_info_step.dart    (Step 3: Physical Specs & Structural selectors)
          property_features_step.dart (Step 4.1: Room Inventory list & extras)
          room_details_step.dart     (Step 4.2: Room Identity, Emoji rating, features list, notes)
```

#### [NEW] [room_model.dart](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/features/property_wizard/data/models/room_model.dart)
Defines properties for each room in Step 4:
- `id`: unique identifier
- `name`: user-defined name (e.g. "Master Bedroom")
- `type`: Category (Bedroom, Living, Bathroom, etc.)
- `description`: subtitle (e.g. "Master Suite")
- `isComplete`: bool tracking standard/pending status
- `conditionRating`: level 1 to 4 rating (optional)
- `features`: list of selected amenities (e.g. "Ceiling Fan", "Balcony")
- `notes`: free text notes

#### [NEW] [property_state_model.dart](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/features/property_wizard/data/models/property_state_model.dart)
Defines the overall state of the wizard:
- `currentStep`: integer from 1 to 6
- `propertyType`: enum/string (House, Townhouse, Apartment, etc.)
- `propertySubtype`: string (Free Standing, Cluster, etc.)
- `address`: verified details (street, suburb, city, state, postal code)
- `complexName`: string
- `erfPlotNumber`: string
- `erfSize`, `floorArea`, `constructionYear`, `maxHeight`, `zoning`: numeric and text technical specs
- `facingDirection`, `architecturalStyle`, `roofConfiguration`, `wallExterior`: chip selections
- `rooms`: list of `RoomModel` instances
- `outdoorExtras`: list of selected outdoor amenities (e.g. "Swimming Pool")
- `selectedRoomId`: ID of the room currently being edited in Screen 4.2 (if any)

#### [NEW] [property_controller.dart](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/features/property_wizard/presentation/controllers/property_controller.dart)
Riverpod `Notifier` implementation:
- `nextStep()` / `prevStep()` logic
- `selectPropertyType(type)` / `selectSubtype(subtype)`
- `updateAddress(...)`
- `updateTechnicalSpecs(...)`
- `toggleOutdoorExtra(...)`
- `addCustomRoom(name, type)`
- `selectRoomForEditing(roomId)`
- `updateRoomDetails(roomId, rating, features, notes)`
- `addCustomFeatureToRoom(roomId, feature)`
- `removeFeatureFromRoom(roomId, feature)`

---

### 4. Presentation Layer & Premium Screens

#### [NEW] [property_wizard_shell.dart](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/features/property_wizard/presentation/views/property_wizard_shell.dart)
- Displays the standard **Top Bar**: back button, custom title, and the dynamic logo placeholder (configured by the active theme).
- Controls transition animations between step screens.
- Displays the **Standardized Bottom Progress Navigation** (e.g., "Step X of 6", "Save Draft", and the primary theme-colored "Next" button) that adapts dynamically depending on the current step.

#### [NEW] [property_type_step.dart](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/features/property_wizard/presentation/views/property_type_step.dart)
- Grid layout showing compact cards for House, Townhouse, Apartment, Vacant Land, and Plot.
- Selected cards display a theme-driven border, custom icon, and bold typography.
- Horizontal wrap of "Refine the subtype" chips with custom rounded styling.

#### [NEW] [address_step.dart](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/features/property_wizard/presentation/views/address_step.dart)
- Search text field mimicking real-time Google Maps address lookup.
- Sleek modern "Verified Address Details" and "Additional Identifiers" cards with high-contrast text and labels.

#### [NEW] [building_info_step.dart](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/features/property_wizard/presentation/views/building_info_step.dart)
- Numeric inputs for Erf Size, Floor Area, Construction Year, Max Height, and Zoning.
- Premium visual selectors (Facing Direction, Architectural Style, Roof, Wall Materials) displayed as interactive custom chip wraps.

#### [NEW] [property_features_step.dart](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/features/property_wizard/presentation/views/property_features_step.dart)
- Screen 4.1: Grouped rooms list categorized by Bedrooms, Living & Dining, Bathrooms & Powder.
- Status indicator tags: **COMPLETE** (green) and **PENDING** (orange).
- Dashed-border interactive buttons to "+ Add Room" or "+ Add Outdoor/Extra Item".
- Navigation handler to transition to the room-by-room view (Screen 4.2) when clicking any room card.

#### [NEW] [room_details_step.dart](file:///C:/Users/dylan/.gemini/antigravity/scratch/realestate_app/lib/features/property_wizard/presentation/views/room_details_step.dart)
- Screen 4.2: Edit panel for a single room.
- Includes a gorgeous editorial graphic container illustrating the premium listing style.
- Interactive emoji-based 4-level "Room Condition Rating".
- List of custom amenities with close buttons and a dotted button to add custom items.
- Elegant multi-line Text Area for captured architectural nuances and notes.

---

## Verification Plan

### Automated and Build Verification
We will verify that:
1. The project initializes successfully and all required packages resolve.
2. The project compiles without warnings or errors:
   ```powershell
   flutter analyze
   ```
3. Run the development build of the application locally to inspect formatting, margins, states, and smooth navigation animations.

### Manual UX Checklist
- [ ] Verify brand theme consistency (Inter font, active primary brand color, theme-aware selected cards).
- [ ] Confirm step transition animations operate correctly and progress states update.
- [ ] Confirm that clicking a room in Step 4 opens the correct details screen.
- [ ] Verify that rating a room or editing its features changes its status to **COMPLETE** in the main list.
- [ ] Confirm adding a custom room and adding custom features works flawlessly.

