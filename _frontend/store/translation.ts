import { ActionTree, GetterTree, MutationTree, Plugin } from 'vuex/types'
import { RootState, LangState } from '~/types/store'

export const state = (): LangState => ({
  language: null
})

// export type RootState = ReturnType<typeof state>

export const getters: GetterTree<LangState, RootState> = {
  getLanguage: (state) => state.language
}

export const mutations: MutationTree<LangState> = {
  SET_LANGUAGE: (state, value: string) => {
    state.language = value
  }
}

export const actions: ActionTree<LangState, RootState> = {
  setLanguage({ commit }, value: string): void {
    commit('SET_LANGUAGE', value)
  }
}

export const plugins: Plugin<LangState>[] = []
