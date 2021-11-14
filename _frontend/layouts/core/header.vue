<template>
  <v-app-bar :color="customThemeColor" dense app>
    <v-app-bar-title>
      {{ $t('site_name') }}
    </v-app-bar-title>
    <v-spacer />
    <theme-mode-switcher />
    <language-switcher />
  </v-app-bar>
</template>

<script type="text/ts" lang="ts">
import { Vue, Component, State, Action } from 'nuxt-property-decorator'
import ThemeModeSwitcher from '~/component/theme-mode-switcher.vue'
import LanguageSwitcher from '~/component/language-switcher.vue'

@Component({
  components: {
    ThemeModeSwitcher,
    LanguageSwitcher
  }
})
export default class CoreHeader extends Vue {
  public readonly isNightMode!: boolean

  @State('drawerLeft')
  private readonly drawerLeft!: boolean

  @Action('setDrawerLeft')
  private setDrawerLeft!: (value: boolean) => void

  private get customThemeColor(): string {
    return this.isNightMode ? 'rgba(0,0,0,0.77)' : 'rgba(255,255,255,0.77)'
  }
}
</script>
