import { ActionTree, GetterTree, MutationTree, Plugin } from 'vuex/types'
import { RootState } from '~/types/store'

export const state = (): RootState => ({})

// export type RootState = ReturnType<typeof state>

export const getters: GetterTree<RootState, RootState> = {}

export const mutations: MutationTree<RootState> = {}

export const actions: ActionTree<RootState, RootState> = {
  // eslint-disable-next-line require-await
  nuxtServerInit(_ctx, { _req }) {
    if (process.env.NODE_ENV !== 'production') {
      // eslint-disable-next-line no-console
      console.log('NUXT STORE INIT SERVER')
    }
  },
  nuxtClientInit(_ctx): void {
    if (process.env.NODE_ENV !== 'production') {
      // eslint-disable-next-line no-console
      console.log('NUXT STORE INIT CLIENT')
    }
  }
}

export const plugins: Plugin<RootState>[] = []
