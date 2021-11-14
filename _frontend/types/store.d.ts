// import { PaginationType } from '~/types/index'

export interface RootState {}

export interface ChatroomState {
  id: string | null
}

export interface ThemeState {
  nightMode: boolean
  scheme: string
}

export interface LangState {
  language: string | null
}
