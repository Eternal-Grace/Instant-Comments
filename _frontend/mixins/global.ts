import { Vue, Component, Getter } from 'nuxt-property-decorator'

const imgAvatar: string = require('~/assets/images/placeholders/profile-avatar.png?webp')
const imgBanner: string = require('~/assets/images/placeholders/profile-banner.png?webp')
const imgFlagUk: string = require('~/assets/images/icons/lang/uk.png?webp')
const imgFlagFr: string = require('~/assets/images/icons/lang/fr.png?webp')

@Component({})
export default class Global extends Vue {

  // Global Images / Or Preview Images
  public get previewAvatar(): string { return imgAvatar || '' }
  public get previewBanner(): string { return imgBanner || '' }
  public get previewFlagUk(): string { return imgFlagUk || '' }
  public get previewFlagFr(): string { return imgFlagFr || '' }

  public languageList: Array<{ code: string; img: string; text: string }> | null = [
    { code: 'en', img: this.previewFlagUk, text: 'English' },
    { code: 'fr', img: this.previewFlagFr, text: 'Français' },
  ]

  @Getter('theme/isNightMode')
  public readonly isNightMode!: boolean

  public get themeColor(): string {
    return this.isNightMode ? 'rgba(0,0,0,0.42)' : 'rgba(255,255,255,0.42)'
  }

  public get themeClass(): string {
    return this.isNightMode ? 'nh-theme--dark' : 'nh-theme--light'
  }

  public beforeDestroy(): void {
    this.languageList = null
  }
}
