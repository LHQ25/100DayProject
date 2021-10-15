<template>
  <ul v-infinite-scroll="load" class="infinite-list" style="overflow: auto">
    <li v-for="i in count" :key="i" class="infinite-list-item">{{ i }}</li>
  </ul>
</template>

<script>

import { defineComponent, ref } from 'vue'

export default defineComponent({

  setup() {
    const count = ref(0)
    const load = () => {
      count.value += 2
    }
    return {
      count,
      load,
    }
  }
})
</script>
