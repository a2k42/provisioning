import { defineConfig } from "vitepress";

// https://vitepress.dev/reference/site-config
export default defineConfig({
    title: "Provisioning",
    description: "Bare-metal provisioning and configuration-management",
    themeConfig: {
        // https://vitepress.dev/reference/default-theme-config
        nav: [
            // { text: "Virtualisation", link: "/virtualisation/" },
            {
                text: "Security",
                items: [
                    { text: "GnuPG", link: "/security/gpg/create-gpg-key", activeMatch: "/security/gpg/" },
                    { text: "SSH", link: "/security/ssh/ssh", activeMatch: "/security/ssh/" },
                ],
            },
            // { text: "Bare-Metal", link: "/bare-metal/" },
            // { text: "Configuration", link: "/conf-man/" },
            // { text: "Containerisation", link: "/containers/" },
        ],

        sidebar: {
            "/security": [
                {
                    text: "GPG",
                    items: [
                        { text: "Viewing", link: "/security/gpg/viewing-keys" },
                        { text: "Creating", link: "/security/gpg/create-gpg-key" },
                        { text: "GPG, GitHub, & SSH", link: "/security/gpg/gpg-ssh-github" },
                    ],
                },
                {
                    text: "SSH",
                    items: [
                        { text: "SSH", link: "/security/ssh/ssh" },
                    ]
                }
            ]
        },
        socialLinks: [{ icon: "github", link: "https://github.com/a2k42/provisioning" }],
        footer: {
            message: 'Released under the MIT License. The information contained herein is shared to help you get started and does not necessarily reflect best practise.',
            copyright: 'Copyright © 2024 Andy K (a2k42)'
        }
    },
    base: "/provisioning/",
    head: [['link', { rel: 'icon', href: '/provisioning/favicon.ico' }]]
});
