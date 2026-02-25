# Brewed App – Full Codebase Reference

This document lists every Swift file in the Brewed app with its path. Open these files in Xcode or your editor to see the full code.

---

## App Entry

**`Brewed/Brewed/BrewedApp.swift`** – App entry point, loading → auth → main flow, dark mode

---

## Models

**`Brewed/Brewed/Models/User.swift`** – User (id, username, displayName, profileImageURL, bio, friends, isVerified)

**`Brewed/Brewed/Models/Post.swift`** – Post and Comment (userId, coffeeShopId, imageURL, ratings, caption, likes, comments)

**`Brewed/Brewed/Models/CoffeeShop.swift`** – CoffeeShop (name, address, lat/long, ratings, description)

---

## View Models

**`Brewed/Brewed/ViewModels/AppData.swift`** – Current user, users, posts, coffee shops; addPost, toggleLike, addComment, addFriend, rateCoffeeShop, updateProfileImage

**`Brewed/Brewed/ViewModels/AuthManager.swift`** – isAuthenticated, hasAccount, isLoading; authenticate(), signOut()

**`Brewed/Brewed/ViewModels/LocationManager.swift`** – Device location, CLLocationManager delegate

---

## Design

**`Brewed/Brewed/Design/ColorScheme.swift`** – coffeeBrown, coffeeLight, coffeeCream, coffeeAccent

**`Brewed/Brewed/Design/LogoView.swift`** – Programmatic “B” + steam + “Brewed” + “TASTE. RATE. DISCOVER.”

**`Brewed/Brewed/Design/LogoImageView.swift`** – Uses “BrewedLogo” image or falls back to LogoView

---

## Views

**`Brewed/Brewed/Views/MainTabView.swift`** – Root: cream background, tab content (Feed/Discover/Post/Activity/Profile), BottomNavView, CreatePost sheet

**`Brewed/Brewed/Views/LoadingScreen.swift`** – Splash: centered “BrewedLogo” image, loading dots, animations

**`Brewed/Brewed/Views/AuthPage.swift`** – Sign in / Sign up, skip, account type (Personal/Business), terms

**`Brewed/Brewed/Views/BottomNavView.swift`** – Tab bar: Feed, Discover, elevated Post button, Activity, Profile

**`Brewed/Brewed/Views/FeedView.swift`** – Feed: centered logo header, PostCardView list, CommentRowView, CommentsView

**`Brewed/Brewed/Views/MapView.swift`** – Map: user location, nearby coffee shops, CoffeeShopDetailView sheet

**`Brewed/Brewed/Views/CoffeeShopDetailView.swift`** – Shop name, rating, address, map, recent posts, “Rate This Shop”

**`Brewed/Brewed/Views/ProfileView.swift`** – Profile photo (PhotosPicker), stats, friends, AddFriendView, Settings sheet, My Posts

**`Brewed/Brewed/Views/ActivityView.swift`** – Activity: create-account prompt or activity feed (ActivityItem, ActivityRowView)

**`Brewed/Brewed/Views/CreatePostView.swift`** – Create post: photo, coffee name, roaster, location, method, rating, tasting notes (FlowLayout), caption, partnership; or create-account prompt

**`Brewed/Brewed/Views/SettingsView.swift`** – Dark mode toggle, Edit Profile, Privacy, About, Sign Out

**`Brewed/Brewed/Views/AvatarView.swift`** – Reusable avatar: profile image or initials placeholder

**`Brewed/Brewed/ContentView.swift`** – Unused placeholder (“Hello, brewed!”)

---

## File Count

- **23** Swift files total  
- **1** app entry, **3** models, **3** view models, **3** design, **12** views, **1** placeholder

---

## Quick Navigation in Xcode

1. **BrewedApp.swift** – Start here for app flow.
2. **AppData.swift** – All main app state and actions.
3. **MainTabView.swift** – How tabs and sheets are wired.
4. **FeedView.swift** – Home feed and post cards.
5. **ColorScheme.swift** – App-wide colors.

To see the full code of any file, open it from the paths above in Xcode or your editor.
