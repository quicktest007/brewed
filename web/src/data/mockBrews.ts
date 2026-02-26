export interface Brew {
  id: string
  userName: string
  userAvatar?: string
  placeName: string | null
  placeNeighborhood?: string
  placeCity?: string
  rating: number
  coffeeType: string
  tastingNotes: string[]
  caption: string
  photo?: string
  timestamp: string // ISO date or relative
}

export const mockBrews: Brew[] = [
  {
    id: '1',
    userName: 'Alex',
    userAvatar: 'https://i.pravatar.cc/100?img=12',
    placeName: 'Sightglass Coffee',
    placeNeighborhood: 'Mission',
    placeCity: 'San Francisco',
    rating: 4.5,
    coffeeType: 'Latte',
    tastingNotes: ['Chocolate', 'Nutty', 'Smooth'],
    caption: 'Perfect morning ritual. Single-origin Ethiopian.',
    photo: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600',
    timestamp: '2h ago',
  },
  {
    id: '2',
    userName: 'Jordan',
    userAvatar: 'https://i.pravatar.cc/100?img=33',
    placeName: 'Ritual Coffee Roasters',
    placeNeighborhood: 'Mission',
    placeCity: 'San Francisco',
    rating: 4.8,
    coffeeType: 'Flat White',
    tastingNotes: ['Floral', 'Citrus', 'Bright'],
    caption: 'Killer flat white. Vibes immaculate.',
    photo: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600',
    timestamp: '5h ago',
  },
  {
    id: '3',
    userName: 'Sam',
    userAvatar: 'https://i.pravatar.cc/100?img=68',
    placeName: null,
    placeNeighborhood: undefined,
    placeCity: undefined,
    rating: 5,
    coffeeType: 'Pour Over',
    tastingNotes: ['Berry', 'Bright'],
    caption: 'Homemade Yirgacheffe. Worth the wait.',
    photo: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600',
    timestamp: 'Yesterday',
  },
  {
    id: '4',
    userName: 'Morgan',
    userAvatar: 'https://i.pravatar.cc/100?img=45',
    placeName: 'Blue Bottle Coffee',
    placeNeighborhood: 'SOMA',
    placeCity: 'San Francisco',
    rating: 4.2,
    coffeeType: 'Cappuccino',
    tastingNotes: ['Nutty', 'Creamy'],
    caption: 'Classic done right. Always consistent.',
    photo: 'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=600',
    timestamp: '1d ago',
  },
]

export const mockPlaces = [
  { id: '1', name: 'Sightglass Coffee', neighborhood: 'Mission', city: 'San Francisco', lat: 37.7599, lng: -122.4214 },
  { id: '2', name: 'Ritual Coffee Roasters', neighborhood: 'Mission', city: 'San Francisco', lat: 37.7605, lng: -122.4210 },
  { id: '3', name: 'Blue Bottle Coffee', neighborhood: 'SOMA', city: 'San Francisco', lat: 37.7850, lng: -122.4035 },
  { id: '4', name: 'Four Barrel Coffee', neighborhood: 'Mission', city: 'San Francisco', lat: 37.7630, lng: -122.4215 },
]

export const coffeeTypes = [
  'Espresso', 'Ristretto', 'Lungo', 'Doppio', 'Americano',
  'Latte', 'Cappuccino', 'Flat White', 'Cortado', 'Macchiato',
  'Mocha', 'White Mocha', 'Affogato', 'Vienna Coffee',
  'Pour Over', 'Drip', 'Cold Brew', 'Frappuccino',
]

export const tastingNotes = [
  'Chocolate', 'Caramel', 'Nutty', 'Citrus', 'Floral',
  'Berry', 'Smooth', 'Bright', 'Earthy', 'Sweet',
]
