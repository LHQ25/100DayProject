import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import { Button, Toast, Form, Field } from 'vant'

// md5 加密
import md5 from 'js-md5'

// 移动端分辨率适配—rem
// 安装 -> npm install lib-flexible -S
// 导入
import 'lib-flexible/flexible'
// 写样式的时候要用 rem 做单位，在编译代码的时候自动转化成 rem。 postcss-pxtorem 可以完成自动转换，
// 安装 -> npm install postcss-pxtorem -D
// 在项目根目录下新建 .postcssrc.js 配置文件

// 请求库 Axios
// 安装 -> npm install axios -S

// 公共样式
// 因为不同的浏览器，对 HTML 标签的默认样式支持有所区别，以及有些标签的默认样式展示不友好，所以我们要对样式做一个统一的重制
// 在 src 目录下新建 common/style/base.less、 common/style/mixin.less
// 在 App.vue 文件中引入全局基础样式：


createApp(App)
.use(Button)
.use(Field)
.use(Form)
.use(Toast)
.use(store)
.use(router)
.mount('#app')


createApp.prototype.$md5 = md5;
createApp.config.productionTip = false