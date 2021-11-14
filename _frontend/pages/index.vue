<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="10" md="10">
      <v-card class="mt-4 d-flex justify-center">
        <chatroom />
      </v-card>
    </v-col>
  </v-row>
</template>

<script type="text/ts" lang="ts">
import { Vue, Component } from 'nuxt-property-decorator'
import { MetaInfo } from 'vue-meta/types'
import Chatroom from '~/component/chatroom.vue'

@Component({
  components: {
    Chatroom
  },
  nuxtI18n: {},
  head(this: Index): MetaInfo {
    return {}
  }
})
export default class Index extends Vue {

  private mounted(): void {
    //
  }

  private beforeDestroy(): void {
    //
  }
}
</script>

<style type="text/scss" lang="scss" scoped>
//
</style>
