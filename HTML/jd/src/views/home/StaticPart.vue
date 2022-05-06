<template>
    <div class="position">
      <span class="iconfont position__icon">&#xe619;</span>
      北京理工大学国防科技园2号楼10层
      <span class="iconfont position_notice">&#xe60b;</span>
    </div>
    <div class="search">
      <span class="iconfont">&#xe62d;</span>
      <span class="search__text">山姆会员商店优惠商品</span>
    </div>
    <div class="banner">
      <img
        class="banner__img"
        src="http://www.dell-lee.com/imgs/vue3/banner.jpg"
      />
    </div>
    <div class="icons">
      <div
        class="icons__item"
        v-for="item in iconsList"
        :key="item.desc"
      >
        <img
          class="icons__item__img"
          :src="`http://www.dell-lee.com/imgs/vue3/${item.imgName}.png`"
        />
        <p class="icons__item__desc">{{item.desc}}</p>
      </div>
    </div>
    <div class="gap"></div>

</template>

<script>
export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: 'StaticPart',
  setup () {
    const iconsList = [
      { imgName: '超市', desc: '超市便利' },
      { imgName: '菜市场', desc: '菜市场' },
      { imgName: '水果店', desc: '水果店' },
      { imgName: '鲜花', desc: '鲜花绿植' },
      { imgName: '医药健康', desc: '医药健康' },
      { imgName: '家居', desc: '家居时尚' },
      { imgName: '蛋糕', desc: '烘培蛋糕' },
      { imgName: '签到', desc: '签到' },
      { imgName: '大牌免运', desc: '大牌免运' },
      { imgName: '红包', desc: '红包套餐' }
    ]
    return { iconsList }
  }
}
</script>

<style lang="scss">
  @import "../../style/viriables";

  .position{
    position: relative;
    padding: 0.16rem 0.24rem 0.24rem 0;
    font-size: 0.16rem;
    line-height: 0.22rem;
    color: $content-fontcolor;
    .position__icon{
      position: relative;
      font-size: 0.2rem;
      top: 0.01rem;
    }
    .position_notice{
      font-size: .2rem;
      position: absolute;
      right: 0;
      top: 0.17rem;
    }
  }

  .search{
    line-height: .32rem;
    font-size: .14rem;
    background: #f5f5f5;
    border-radius: 0.16rem;
    color: #B7B7B7;
    .iconfont{
      display: inline-block;
      font-size: .16rem;
      padding: 0 0.12rem 0 0.09rem;
    }
    &__text{
      display: inline-block;
      font-size: .14rem;
    }
  }

  .banner{
    height: 0;
    padding-bottom: 24.5%;
    overflow: hidden;
    &__img{
      width: 100%;
    }
  }

  .icons{
    font-size: .12rem;
    color: $content-fontcolor;
    display: flex;
    flex-wrap: wrap;
    margin-top: .16rem;
    &__item{
      width: 20%;
      &__img{
        width: .4rem;
        height: .4rem;
        margin: 0 auto;
        display: block;
      }
      &__desc{
        text-align: center;
      }
    }
  }
  .gap{
    margin: 0 -.18rem;
    height: .1rem;
    background: $content-bgColor;
  }
</style>
