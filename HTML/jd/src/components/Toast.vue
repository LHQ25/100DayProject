<template>
  <div class="toast">{{message}}</div>
</template>

<script>
import { reactive, toRefs } from 'vue'
export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: 'Toast',
  props: ['message']
}
export const useToastEffect = () => {
  const toastData = reactive({ show: false, toastMessage: '' })

  const showToast = (message) => {
    toastData.show = true
    toastData.toastMessage = message
    setTimeout(() => {
      toastData.toastMessage = ''
      toastData.show = false
    }, 2000)
  }

  const { show, toastMessage } = toRefs(toastData)
  return { show, toastMessage, showToast }
}

</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
  .toast {
    position: fixed;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    padding: .1rem;
    background: rgba(0, 0, 0, .35);
    border-radius: .05rem;
    color: #FFF;
    font-size: .18rem;
  }
</style>
