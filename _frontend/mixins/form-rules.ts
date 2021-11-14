import { Vue, Component } from 'nuxt-property-decorator'
import { TranslateResult } from 'vue-i18n/types'

@Component({})
export default class FormRules extends Vue {
  private modelData: any = { token: '' }
  private errors: any = {}

  private formRules(
    name: string,
    min: number | null = null,
    max: number | null = null,
    required: boolean = true
  ): Array<any> | null {
    const data: Array<any> = []

    let trueName: string = name
    if (name.includes('.')) {
      trueName = name.split('.')[0]
    }

    const field: TranslateResult | null = this.$t('form.field.' + trueName)

    if (!!this.errors && Object.keys(this.errors).length) {
      for (const [key, value] of Object.entries(this.errors)) {
        if (key === name && !!value) {
          if (typeof value === 'object' && !!value) {
            const v = Object.values(value)
            data.push((_v: string) => v[0])
          } else {
            data.push((_v: string | undefined) => value)
          }
          break
        }
      }
    }

    data.push(
      (v: string) =>
        (required ? !!v && !!v.length : !v) ||
        (!!v && !!v.length) ||
        this.$t('form.validation.required', { field })
    )

    // Validation Rule: Min
    if (min) {
      data.push(
        (v: string) =>
          !v ||
          (!!v && v.length >= min) ||
          this.$t('form.validation.min', { field, min })
      )
    }

    // Validation Rule: Max
    if (max) {
      data.push(
        (v: string) =>
          !v ||
          (!!v && v.length <= max) ||
          this.$t('form.validation.max', { field, max })
      )
    }

    // Validation Rule: Valid
    switch (name) {
      case 'email':
        // eslint-disable-next-line
        const emailRegex = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        data.push(
          (v: string) =>
            (!!v && emailRegex.test(String(v).toLowerCase())) ||
            this.$t('form.validation.valid', { field })
        )
        break
      case 'password':
        data.push(
          (v: string) =>
            !this.modelData.password_confirmation ||
            (!!v && this.modelData.password_confirmation === v) ||
            this.$t('form.validation.valid', { field })
        )
        break
      case 'password_confirmation':
        data.push(
          (v: string) =>
            this.modelData.password === v ||
            this.$t('form.validation.valid', { field })
        )
        break
      default:
        data.push(
          (v: string) =>
            !v ||
            (!!v && !!v.length) ||
            this.$t('form.validation.valid', { field })
        )
        break
    }

    return data
  }

  private beforeDestroy(): void {
    this.modelData = {}
    this.errors = null
  }
}
