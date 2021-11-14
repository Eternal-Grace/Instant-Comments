// import { NuxtAxiosInstance } from '@nuxtjs/axios'
import Echo from 'laravel-echo'
import 'nuxt-socket-io/io/types.d'

declare module 'vue/types/vue' {
  interface Vue {
    $echo: Echo
  }
}
/*
interface FormType {
  type: string
  name: string
  min: null | number
  max: null | number
  disabled?: boolean
  required?: boolean
}

export interface PaginationType {
  count: number
  currentStack: number
  data: Array<any>
  lastStack: number
  perStack: number
  total: number
}

export interface ImageType {
  type: string
  path: string
}

export interface UserType {
  id?: number
  username?: string
  slug?: string
  images?: Array<ImageType>
  email?: string
}

export interface CommentType {
  id: number
  order: number
  parent: number
  user: UserType
  contentType: string
  contentId: number
  status: string
  statusMessage: string | null
  message: string
  replies: Array<CommentType>
  created: number
  updated: number
}

declare module 'vue/types/vue' {
  interface Vue {
    // $auth: Auth
    // $echo: Echo
  }
}

declare module 'vuex/types/index' {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars,no-unused-vars
  interface Store<S> {
    // $auth: Auth
  }
}

declare module '@nuxt/types' {
  interface Context {
    // $axios: NuxtAxiosInstance
    // $echo: Echo
  }
}

export interface ImageType {
  type: string
  path: string
}






*/
