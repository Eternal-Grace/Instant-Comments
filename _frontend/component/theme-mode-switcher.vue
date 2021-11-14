<template>
  <v-btn
    icon
    :aria-label="isNightMode ? 'dark' : 'light'"
    @click.stop="setNightMode(!isNightMode)"
  >
    <v-icon v-show="isNightMode">fas fa-moon fa-2x</v-icon>
    <v-icon v-show="!isNightMode">fas fa-sun fa-2x</v-icon>
  </v-btn>
</template>

<script type="text/ts" lang="ts">
import { Vue, Component, Action, Watch } from 'nuxt-property-decorator'

@Component({})
export default class ThemeModeSwitcher extends Vue {
  private themeTimerId: number | null = 0

  @Action('theme/setNightMode')
  private setNightMode!: (value: boolean) => void

  @Watch('isNightMode', { immediate: true, deep: true })
  private onChangedNightMode(value: boolean): void {
    if (process.browser) {
      this.$vuetify.theme.dark = value
    }
  }

  private beforeDestroy(): void {
    if (this.themeTimerId) {
      clearTimeout(this.themeTimerId)
    }
    this.themeTimerId = null
  }
}
</script>
