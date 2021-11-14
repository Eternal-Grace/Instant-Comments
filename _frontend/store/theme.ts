import { GetterTree, ActionTree, MutationTree, Plugin } from 'vuex/types'
import { RootState, ThemeState } from '~/types/store'

export const state = (): ThemeState => ({
  nightMode: true,
  scheme: 'light'
})

// export type RootState = ReturnType<typeof state>

export const getters: GetterTree<ThemeState, RootState> = {
  isNightMode: (state) => state.nightMode,
  getScheme: (state) => state.scheme
}

export const mutations: MutationTree<ThemeState> = {
  SET_NIGHT_MODE: (state, value: boolean) => {
    state.nightMode = value
    state.scheme = value ? 'dark' : 'light'
  }
}

export const actions: ActionTree<ThemeState, RootState> = {
  setNightMode({ commit }, value: boolean): void {
    commit('SET_NIGHT_MODE', value)
  }
}

export const plugins: Plugin<ThemeState>[] = []
