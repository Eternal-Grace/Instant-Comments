<template>
  <v-card class="full-width full-height">
    <v-container class="elevation-0 orange">
      <v-row
        id="chatroom-content"
        ref="chatroomContent"
        class="d-block overflow-y-auto"
        justify="center"
        align="center"
      >
        <div v-for="(data, key) in messages" :key="key" class="message">
          <v-card flat :color="themeColor" :class="[
            'ma-2',
            (data.id === getId ? 'message--me' : 'message--other')
          ]">
            <v-card-subtitle
              class="py-0 px-1"
              :style="`color: ${getColor(data.id)};`"
            >
              <strong>
                <em>
                  {{ `anon@${data.id}` }}
                </em>
              </strong>
            </v-card-subtitle>
            <v-card-text class="py-0 px-1 text-break">
              {{ data.message }}
            </v-card-text>
          </v-card>
        </div>
      </v-row>
    </v-container>
    <v-card-actions class="flex-column align-stretch">
      <v-textarea
        v-model="message"
        :label="$t('component.chatroom.input')"
        :height="100"
        :counter="50"
        :maxlength="50"
        clearable
        no-resize
        outlined
      />
      <v-btn
        :disabled="!message"
        color="light-blue lighten-3"
        class="mt-2 pa-0"
        small
        @click.prevent="sendMessage"
      >
        {{ $t('component.chatroom.button') }}
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script type="text/ts" lang="ts">
import { Vue, Component, Getter, Ref } from 'nuxt-property-decorator'
import delay from 'lodash/delay'

interface MessageType {
  id: string
  message: string
  socket: string
}

@Component({})
export default class Chatroom extends Vue {

  @Ref('chatroomContent')
  readonly chatroomContent!: HTMLDivElement

  @Getter('chatroom/getId')
  private readonly getId!: string

  private message: string | null = '' //
  private offsetTop: number | null = 0
  private timerId: number | null = 0
  private messages: Array<MessageType> | null = []

  private getColor(text: string): string {
    return this.$options.filters?.stringToColour(text)
  }

  private enterChatRoom(): void {
    if (!this.getId) {
      this.$store.dispatch(
        'chatroom/setId',
        Math.random().toString(16).substr(2, 5)
      )
    }
    this.$echo
      .channel('chatroom-message')
      .listen('.chatroom-message', (message: MessageType) => {
        this.messages?.push(message)
        if (this.timerId) {
          clearTimeout(this.timerId)
        }
        this.timerId = delay(() => {
          this.chatroomContent.scrollTop = this.chatroomContent.scrollHeight
        }, 250)
      })
  }

  private leaveChatRoom(): void {
    this.$echo.leaveChannel('chatroom-message')
  }

  private async sendMessage(): Promise<void> {
    if (this.message && this.message?.length > 0) {
      await this.$axios
        .post('/api/chatroom/message', {
          id: this.getId,
          message: this.message
        })
        .then(() => {})
        .catch(() => {})
        .finally(() => (this.message = null))
    }
  }

  private mounted(): void {
    this.enterChatRoom()
  }

  private beforeDestroy(): void {
    this.leaveChatRoom()
    this.offsetTop = null
    this.timerId = null
    this.message = null
    this.messages = null
  }
}
</script>

<style type="text/scss" lang="scss" scoped>
#chatroom-content {
  scroll-behavior: smooth;

  .message {
    // padding: 5px;
    // margin: 5px 3px 0 3px;
    &--me {
      text-align: right;
    }
    &--other {
      text-align: left;
    }
    // .chatroom-message {
    //   font-size: 12px;
    // }
  }
}

/*
#chatroom {
  position: absolute;
  bottom: 45px;
  right: 10px;

  .v-expansion-panel-content__wrap {
    padding: 0 8px 8px !important;
  }
}
#chatroom-container {
  max-height: 325px;
}
#chatroom-content {
  max-height: 325px;
  padding-bottom: 8px;
  scroll-behavior: smooth;

  .message {
    width: calc(100% - 15px);
    padding: 5px;
    margin: 5px 3px 0 3px;
    &--me {
      text-align: right;
    }
    &--other {
      text-align: left;
    }
    .chatroom-message {
      font-size: 12px;
    }
  }
}
*/
</style>
