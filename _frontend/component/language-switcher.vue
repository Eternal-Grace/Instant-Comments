<template>
  <v-menu
    open-on-hover
    bottom
    offset-y
  >
    <template #activator="{ on, attrs }">
      <v-avatar v-bind="attrs" size="42" v-on="on">
        <v-icon>fas fa-language</v-icon>
      </v-avatar>
    </template>

    <v-list>
      <v-list-item
        v-for="(lang, index) in languageList"
        :key="index"
        class="pointer"
        @click.stop="changeLang(lang.code)"
      >
        <v-list-item-title>
          {{ lang.text }}
        </v-list-item-title>
      </v-list-item>
    </v-list>
  </v-menu>
  <!--
  <v-btn-toggle v-model="langCode" tile group @change="changeLang">
    <v-btn width="30" value="en">en</v-btn>
    <v-btn width="30" value="fr">fr</v-btn>
  </v-btn-toggle>
  -->
</template>

<script type="text/ts" lang="ts">
import { Vue, Component, Action, Watch, Getter } from 'nuxt-property-decorator'

@Component({})
export default class LanguageSwitcher extends Vue {
  public languageList!: Array<{ code: string; img: string; text: string }>

  private langCode: string | null = null

  @Getter('translation/getLanguage')
  private readonly getLanguage!: string

  @Action('translation/setLanguage')
  private setLanguage!: (value: string) => void

  @Watch('getLanguage', { immediate: true, deep: true })
  private onChangedLanguage(langCode: string): void {
    if (langCode) {
      this.$vuetify.lang.current = langCode
      this.$router.push(this.switchLocalePath(langCode))
    }
  }

  private changeLang(langCode: string) {
    this.setLanguage(langCode)
  }

  private beforeDestroy(): void {
    this.langCode = null
  }
}
</script>
