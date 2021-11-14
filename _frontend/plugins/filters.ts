import Vue from 'vue'
import { Context } from '@nuxt/types'

export default (_ctx: Context) => {
  let stringToColour: any = null

  if (!('stringToColour' in (<any>Vue).options.filters)) {
    if (process.env.NODE_ENV !== 'production') {
      // eslint-disable-next-line no-console
      console.log('Plugin: filters.ts ~ stringToColour')
    }
    stringToColour = (text: string): string => {
      if (!text || !text.length) {
        return '#000'
      }
      let hash = 0
      for (let i = 0; i < text.length; i++) {
        hash = text.charCodeAt(i) + ((hash << 5) - hash)
      }
      let colour: string = '#'
      for (let i = 0; i < 3; i++) {
        const value = (hash >> (i * 8)) & 0xff
        colour += ('00' + value.toString(16)).substr(-2)
      }
      return colour
    }
  }

  let filters: any = {
    stringToColour,
  }

  for (const key of Object.keys(filters)) {
    if (filters[key] !== null) {
      Vue.filter(key, filters[key])
    }
  }

  stringToColour = null

  filters = null
}
