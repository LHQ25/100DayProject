import axios from "axios";

export function getUserInfo() {
    return axios.get('/user/info');
}

// 登录
export function login(params) {
    return axios.post('/user/login', params);
}
  
// 登出
export function logout() {
    return axios.post('/user/logout')
}
  
// 注册
export function register(params) {
    return axios.post('/user/register', params);
}