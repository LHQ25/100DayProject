<template>
    <div class=""></div>
    <div class="docker">
      <div v-for="(item, index) in dockerList"
           :key="item.icon"
           :class="{'docker__item': true, 'docker__item--active': index === currentIndex}"
           @click="itemClick(index)">
        <div class="iconfont" v-html="item.icon"></div>
        <div class="docker__title">{{item.title}}</div>
      </div>
    </div>
</template>

<script>
import { ref } from 'vue'
export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: 'Docker',
  setup () {
    let currentIndex = ref(0)

    const dockerList = [{ icon: '&#xe6f3', title: '首页' },
      { icon: '&#xe6f3', title: '购物车' },
      { icon: '&#xe6f3', title: '订单' },
      { icon: '&#xe6f3', title: '我的' }]

    function itemClick (index) {
      currentIndex = index
    }

    return { dockerList, currentIndex, itemClick }
  }
}
</script>

<style lang="scss">
  @import "../../style/viriables";
  .wrapper{
  }

  .docker{
    position: absolute;
    left: 0;
    bottom: 0;
    width: 100%;
    height: 0.49rem;
    background: #F1F1F1;
    border-top: 0.01rem solid $content-bgColor;
    box-sizing: border-box;
    display: flex;
    &__item{
      flex: 1;
      text-align: center;
      .iconfont{
        margin: 0.07rem 0 0.02rem 0;
        font-size: 0.18rem;
        color: $content-fontcolor;
      }
      &--active{
        color: #1fa4fc;
      }
    }
    &__title{
      font-size: 0.2rem;
      transform: scale(0.5,0.5);
      transform-origin: center top;
      color: $content-fontcolor;
    }
  }
</style>
