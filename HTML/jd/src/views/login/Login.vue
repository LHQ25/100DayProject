<template>
  <div class="wrapper">
    <img class="wrapper__img" src='http://www.dell-lee.com/imgs/vue3/user.png' />
    <div class="wrapper__input">
      <input
        class="wrapper__input__content"
        placeholder="用户名"
        v-model="username"
      />
    </div>
    <div class="wrapper__input">
      <input
        type="password"
        class="wrapper__input__content"
        placeholder="请输入密码"
        v-model="password"
        autocomplete="new-password"
      />
    </div>
    <div class="wrapper__login-button" @click="handleLogin">登陆</div>
    <div class="wrapper__login-link" @click="handleRegisterClick">立即注册</div>
    <Toast v-if="show" :message="toastMessage"/>
  </div>
</template>

<script>
import Toast, { useToastEffect } from '../../components/Toast'
import { post } from '../../utils/Request'
import { reactive, toRefs } from 'vue'
import { useRouter } from 'vue-router'

const useLoginEffect = (showToast) => {
  const router = useRouter()
  const data = reactive({ username: '', password: '' })

  const handleLogin = async () => {
    try {
      const result = await post('/api/login', { username: data.username, password: data.password })
      if (result?.error === 0) {
        localStorage.isLogin = true
        router.push({ name: 'Home' })
      } else {
        localStorage.isLogin = false
        showToast(result.desc)
      }
    } catch (e) {
      showToast(e.toLocaleString())
    }
  }

  const { username, password } = toRefs(data)

  return { username, password, handleLogin }
}

const useRegisterHandler = () => {
  const router = useRouter()

  const handleRegisterClick = () => {
    router.push({ name: 'register' })
  }
  return { handleRegisterClick }
}

export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: 'Login',
  components: { Toast },

  setup () {
    const { show, toastMessage, showToast } = useToastEffect()
    const { username, password, handleLogin } = useLoginEffect(showToast)
    const { handleRegisterClick } = useRegisterHandler()

    return { show, toastMessage, username, password, handleLogin, handleRegisterClick }
  }
}
</script>

<style lang="scss" scoped>
  @import "../../style/viriables";
  .wrapper{
    position: absolute;
    top: 50%;
    left: 0;
    right: 0;
    transform: translateY(-50%);
    &__img{
      width: .66rem;
      height: .66rem;
      display: block;
      margin: 0 auto .4rem auto;
    }
    &__input{
      height: .48rem;
      margin: 0 .4rem .16rem .4rem;
      padding: 0 .16rem;
      background: #f9f9f9;
      border: 1px solid rgb(0,0,0);
      border-radius: 6px;
      &__content{
        line-height: .48rem;
        border: none;
        outline: none;
        width: 100%;
        background: none;
        font-size: .16rem;
        transform: translateY(-125%);
        color: $content-notice-fontcolor;
        &::placeholder{
          color: $content-notice-fontcolor;
        }
      }
    }
    &__login-button{
      background: #0091ff;
      margin: .32rem .4rem;
      border-radius: 4px;
      line-height: .48rem;
      color: #fff;
      font-size: .16rem;
      text-align: center;
      box-shadow: 0 0.04rem 0.08rem 0 rgb(0, 145, 255, .32);
    }
    &__login-link {
      text-align: center;
      font-size: .14rem;
      color: $content-notice-fontcolor;
    }
  }
</style>
