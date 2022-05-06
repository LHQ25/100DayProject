<template>
  <div class="nearby">
    <h3 class="nearby__title">附近店铺</h3>
    <div
      class="nearby__item"
      v-for="item in nearbyList"
      :key="item.id"
    >
      <img :src="item.imgUrl" class="nearby__item__img">
      <div class="nearby__content">
        <div class="nearby__content__title">{{item.title}}</div>
        <div class="nearby__content__tags">
          <span
            class="nearby__content__tag"
            v-for="(innerItem, innerIndex) in item.tags"
            :key="innerIndex"
          >{{innerItem}}</span>
        </div>
        <p class="nearby__content__highlight">{{item.desc}}</p>
        <div class="nearby__content__line"></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: 'Nearby',
  setup () {
    const nearbyList = [{
      id: 1,
      imgUrl: 'http://www.dell-lee.com/imgs/vue3/near.png',
      title: '沃尔玛',
      tags: ['月售1万+', '起送¥0', '基础运费¥5'],
      desc: 'VIP尊享满89元减4元运费券（每月3张）'
    }, {
      id: 2,
      imgUrl: 'http://www.dell-lee.com/imgs/vue3/near.png',
      title: '沃尔玛',
      tags: ['月售1万+', '起送¥5', '基础运费¥5'],
      desc: 'VIP尊享满89元减4元运费券（每月3张）'
    }]
    return { nearbyList }
  }
}
</script>

<style lang="scss" scoped>
  @import "../../style/viriables";
  .nearby{
    &__title{
      margin: 0.16rem 0 0.02rem 0;
      font-size: 0.18rem;
      font-weight: normal;
      color: $content-fontcolor;
    }
    &__item{
      display: flex;
      margin-top: .12rem;
      &__img{
        width: .56rem;
        height: .56rem;
      }
    }
    &__content{
      margin-left: .16rem;
      display: flex;
      flex-direction: column;
      color: $content-fontcolor;
      &__title{
        font-size: .16rem;
        line-height: .22rem;
      }
      &__tags{
        font-size: .13rem;
        line-height: .18rem;
        margin-top: .08rem;
      }
      &__tag{
        margin-right: .16rem;
      }
      &__highlight{
        font-size: .13rem;
        color: #e93b3b;
        line-height: .18rem;
        margin-top: .08rem;
      }
      &__line{
        background: #f1f1f1;
        height: .01rem;
        margin-right: -.18rem;
      }
    }
  }
</style>
