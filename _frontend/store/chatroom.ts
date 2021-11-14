import { ActionTree, GetterTree, MutationTree, Plugin } from 'vuex/types'
import { RootState, ChatroomState } from '~/types/store'

export const state = (): ChatroomState => ({
  id: null
})

// export type RootState = ReturnType<typeof state>

export const getters: GetterTree<ChatroomState, RootState> = {
  getId: (state) => state.id
}

export const mutations: MutationTree<ChatroomState> = {
  SET_ID: (state, value: string) => {
    state.id = value
  }
}

export const actions: ActionTree<ChatroomState, RootState> = {
  setId({ commit }, value: string): void {
    commit('SET_ID', value)
  }
}

export const plugins: Plugin<ChatroomState>[] = []
