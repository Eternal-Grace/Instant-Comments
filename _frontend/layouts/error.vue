<template>
  <v-app dark>
    <h1 v-if="error.statusCode === 404">
      {{ $t('page.error.404') }}
    </h1>
    <h1 v-else>
      {{ $t('page.error.other') }}
    </h1>
    <v-btn to="/"> Back to: Home page </v-btn>
  </v-app>
</template>

<script type="text/ts" lang="ts">
import { Vue, Component, Prop } from 'nuxt-property-decorator'
import { MetaInfo } from 'vue-meta/types'

@Component({
  components: {},
  head(this: Error): MetaInfo {
    const error: { statusCode: number } | undefined | null = this.error
    return {
      title:
        error && error.statusCode === 404
          ? this.$t('page.error.404').toString()
          : this.$t('page.error.other').toString()
    }
  },
  layout: 'empty'
})
export default class Error extends Vue {
  @Prop({ type: Object, default: null })
  private readonly error: { statusCode: number } | undefined | null
}
</script>
