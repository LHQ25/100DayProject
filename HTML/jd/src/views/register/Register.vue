<template>
  <div class="wrapper">
    <img class="wrapper__img" src="http://www.dell-lee.com/imgs/vue3/user.png"/>
    <div class="wrapper__input">
      <input
        class="wrapper__input__content"
        placeholder="请输入用户名"
        v-model="username"
      />
    </div>
    <div class="wrapper__input">
      <input
        type="password"
        class="wrapper__input__content"
        placeholder="请输入密码"
        autocomplete="new-password"
        v-model="password"
      />
    </div>
    <div class="wrapper__input">
      <input
        class="wrapper__input__content"
        placeholder="确认密码"
        type="password"
        v-model="ensurement"
      />
    </div>
    <div class="wrapper__register-button" @click="handleRegister">注册</div>
    <div class="wrapper__register-link" @click="handleLoginClick">已有账号去登陆</div>
    <Toast v-if="show" :message="toastMessage"/>
  </div>
</template>

<script>
import Toast, { useToastEffect } from '../../components/Toast'
import { useRouter } from 'vue-router'
import { post } from '../../utils/Request'
import { reactive, toRefs } from 'vue'

const registerHandle = (showToast) => {
  const router = useRouter()
  const data = reactive({ usurname: '', password: '', ensurement: '' })

  const handleRegister = async () => {
    if (data.password !== data.ensurement) {
      showToast('两次密码不对')
    } else {
      try {
        const result = await post('/api/user/register', {
          username: data.username,
          password: data.password
        })
        if (result?.error === 0) {
          router.push({ name: 'login' })
        } else {
          showToast(result.message)
        }
      } catch (e) {
        showToast(e.toLocaleString())
      }
    }
  }

  const { username, password, ensurement } = toRefs(data)
  return { username, password, ensurement, handleRegister }
}

const useLoginHandle = () => {
  const router = useRouter()
  const handleLoginClick = () => {
    router.push({ name: 'login' })
  }
  return { handleLoginClick }
}

export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: 'Register',
  components: { Toast },
  setup () {
    const { show, toastMessage, showToast } = useToastEffect()
    const { username, password, ensurement, handleRegister } = registerHandle(showToast)
    const { handleLoginClick } = useLoginHandle()
    return { show, toastMessage, showToast, username, password, ensurement, handleRegister, handleLoginClick }
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
    &__register-button{
      background: #0091ff;
      margin: .32rem .4rem;
      border-radius: 4px;
      line-height: .48rem;
      color: #fff;
      font-size: .16rem;
      text-align: center;
      box-shadow: 0 0.04rem 0.08rem 0 rgb(0, 145, 255, .32);
    }
    &__register-link {
      text-align: center;
      font-size: .14rem;
      color: $content-notice-fontcolor;
    }
  }
</style>
