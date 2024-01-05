module.exports = {
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',
    'plugin:react/jsx-runtime',
    'plugin:tailwindcss/recommended',
    '@electron-toolkit/eslint-config-ts/recommended',
    '@electron-toolkit/eslint-config-prettier'
  ],
  plugins: ['@typescript-eslint', 'react', 'react-hooks'],
  rules: {
    '@typescript-eslint/explicit-function-return-type': 'off',
    'tailwindcss/no-custom-classname': 'off',
    // https://github.com/jsx-eslint/eslint-plugin-react/issues/3284 Eslint-plugin-react does not support it yet
    'react/prop-types': [2, { ignore: ['className'] }]
  }
}
