/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./resources/**/*.blade.php",
    "./resources/**/*.js",
    "./resources/**/*.jsx",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f0f4f0',
          100: '#dce8dc',
          200: '#b8d1b8',
          300: '#94ba94',
          400: '#70a370',
          500: '#4c8c4c', // Verde musgo principal
          600: '#3d703d',
          700: '#2e542e',
          800: '#1f381f',
          900: '#0f1c0f',
        },
        moss: {
          light: '#6b8e6b',
          DEFAULT: '#4c8c4c',
          dark: '#3d703d',
        }
      },
    },
  },
  plugins: [],
}