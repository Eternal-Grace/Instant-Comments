<template>
  <v-app>
    <core-header />
    <core-content />
    <core-footer />
  </v-app>
</template>

<script type="text/ts" lang="ts">
import { Vue, Component } from 'nuxt-property-decorator'
import { MetaInfo } from 'vue-meta/types'
import CoreHeader from '~/layouts/core/header.vue'
import CoreContent from '~/layouts/core/content.vue'
import CoreFooter from '~/layouts/core/footer.vue'
import Global from '~/mixins/global'

Vue.mixin(Global)

@Component({
  components: {
    CoreHeader,
    CoreContent,
    CoreFooter
  },
  head(this: Default): MetaInfo {
    return this.$nuxtI18nHead()
  }
})
export default class Default extends Vue {
  //
}
</script>

<style type="text/scss" lang="scss">
.pointer {
  cursor: pointer !important;
}
.full-height {
  height: 100% !important;
}
.full-width {
  width: 100% !important;
}
</style>
