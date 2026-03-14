import axios from 'axios'

const API_URL = import.meta.env.VITE_API_URL

export const signup = async (email, password) => {
  const response = await axios.post(`${API_URL}/auth/signup`, { email, password })
  return response.data
}

export const login = async (email, password) => {
  const response = await axios.post(`${API_URL}/auth/login`, { email, password })
  return response.data
}
