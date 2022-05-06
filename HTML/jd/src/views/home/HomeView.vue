<template>
  <div class="wrapper">
    <StaticPart />
    <near-by/>
  </div>
  <Docker />
</template>

<script>
// @ is an alias to /src
import Docker from './Docker.vue'
import StaticPart from './StaticPart'
import NearBy from './NeraBy'

export default {
  name: 'HomeView',
  components: {
    StaticPart,
    Docker,
    NearBy
  }
}
</script>

<style>
  .wrapper{
    position: absolute;
    left: 0;
    right: 0;
    top: 0;
    bottom: 0.5rem;
    padding: 0 .18rem .1rem .18rem;
    overflow-y: auto;
  }
</style>
