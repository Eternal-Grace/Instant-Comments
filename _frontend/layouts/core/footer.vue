<template>
  <v-footer app>
    <v-spacer />
    <span>&copy; 2020-{{ currentYear }}</span>
  </v-footer>
</template>

<script type="text/ts" lang="ts">
import { Vue, Component } from 'nuxt-property-decorator'

@Component({})
export default class CoreFooter extends Vue {
  private currentYear: number | null = new Date().getFullYear()

  private beforeDestroy(): void {
    this.currentYear = null
  }
}
</script>
