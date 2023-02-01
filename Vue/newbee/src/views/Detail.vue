<template>
    <div class="detail">
        <s-header :title="'详情'"></s-header>
      <div>我是详情</div>
    </div>
  </template>
  
  <script>

import sHeader from '@/components/SimpleHeader'

  export default {
      name: 'Detail',
      components: {
        sHeader
      }
  }
  </script>
  
  <style lang="less" scoped>
  
  </style>