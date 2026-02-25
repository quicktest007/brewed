import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useState,
  type ReactNode,
} from 'react'
import { mockBrews } from '../data/mockBrews'
import type { Brew } from '../data/mockBrews'

const STORAGE_KEY = 'brewed-user-brews'

function loadUserBrews(): Brew[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (!raw) return []
    const parsed = JSON.parse(raw)
    return Array.isArray(parsed) ? parsed : []
  } catch {
    return []
  }
}

function saveUserBrews(brews: Brew[]) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(brews))
}

type BrewStoreValue = {
  brews: Brew[]
  addBrew: (brew: Omit<Brew, 'id' | 'userName'>) => void
  clearUserBrews: () => void
}

const BrewStoreContext = createContext<BrewStoreValue | null>(null)

export function BrewStoreProvider({ children }: { children: ReactNode }) {
  const [userBrews, setUserBrews] = useState<Brew[]>(() => loadUserBrews())

  useEffect(() => {
    saveUserBrews(userBrews)
  }, [userBrews])

  const addBrew = useCallback((brew: Omit<Brew, 'id' | 'userName'>) => {
    const newBrew: Brew = {
      ...brew,
      id: `user-${Date.now()}`,
      userName: 'You',
    }
    setUserBrews((prev) => [newBrew, ...prev])
  }, [])

  const clearUserBrews = useCallback(() => {
    setUserBrews([])
  }, [])

  const brews = [...userBrews, ...mockBrews]

  return (
    <BrewStoreContext.Provider value={{ brews, addBrew, clearUserBrews }}>
      {children}
    </BrewStoreContext.Provider>
  )
}

export function useBrewStore() {
  const ctx = useContext(BrewStoreContext)
  if (!ctx) throw new Error('useBrewStore must be used within BrewStoreProvider')
  return ctx
}
