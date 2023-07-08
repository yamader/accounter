import { defineConfig } from "vitepress"

export default defineConfig({
  title: "money D",
  description: "The money D App",
  themeConfig: {
    nav: [
      { text: "Home", link: "/" },
      { text: "解説", link: "/expl" },
    ],
    socialLinks: [
      { icon: "github", link: "https://github.com/yamader/accounter" },
    ],
  },
})
