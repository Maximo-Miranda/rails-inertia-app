<template>
    <v-app>
        <!-- App Bar (Barra superior) -->
        <v-app-bar color="primary" prominent dark>
            <v-app-bar-nav-icon
                @click="drawer = !drawer"
                data-testid="nav-icon"
            ></v-app-bar-nav-icon>

            <v-toolbar-title data-testid="app-title">
                Mi Aplicación
            </v-toolbar-title>

            <v-spacer></v-spacer>

            <!-- Botones adicionales en el app bar -->
            <v-btn icon data-testid="search-btn">
                <v-icon>mdi-magnify</v-icon>
            </v-btn>

            <v-btn icon data-testid="notifications-btn">
                <v-icon>mdi-bell</v-icon>
            </v-btn>

            <v-btn icon data-testid="account-btn">
                <v-icon>mdi-account</v-icon>
            </v-btn>
        </v-app-bar>

        <!-- Navigation Drawer (Menú lateral) -->
        <v-navigation-drawer
            v-model="drawer"
            app
            temporary
            data-testid="nav-drawer"
        >
            <!-- Header del drawer -->
            <v-list>
                <v-list-item
                    prepend-avatar="https://randomuser.me/api/portraits/women/85.jpg"
                    title="Usuario"
                    subtitle="usuario@ejemplo.com"
                    data-testid="user-info"
                ></v-list-item>
            </v-list>

            <v-divider></v-divider>

            <!-- Items de navegación -->
            <v-list density="compact" nav>
                <v-list-item
                    v-for="item in menuItems"
                    :key="item.title"
                    :prepend-icon="item.icon"
                    :title="item.title"
                    :value="item.value"
                    :data-testid="`nav-item-${item.value}`"
                    @click="navigateTo(item.route)"
                    :active="isCurrentRoute(item.route)"
                ></v-list-item>
            </v-list>

            <template v-slot:append>
                <div class="pa-2">
                    <v-btn
                        block
                        color="error"
                        prepend-icon="mdi-logout"
                        data-testid="logout-btn"
                    >
                        Cerrar Sesión
                    </v-btn>
                </div>
            </template>
        </v-navigation-drawer>

        <!-- Contenido principal -->
        <v-main>
            <slot />
        </v-main>
    </v-app>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { router } from "@inertiajs/vue3";
import { usePage } from "@inertiajs/vue3";

const drawer = ref(true);

interface MenuItem {
    title: string;
    icon: string;
    value: string;
    route: string;
}

const menuItems: MenuItem[] = [
    {
        title: "Inicio",
        icon: "mdi-home",
        value: "home",
        route: "/",
    },
    {
        title: "Posts",
        icon: "mdi-post",
        value: "posts",
        route: "/posts",
    },
    {
        title: "Vuetify Test",
        icon: "mdi-test-tube",
        value: "vuetify-test",
        route: "pages/vuetify_test",
    },
];

const navigateTo = (route: string) => {
    router.visit(route);
};

const isCurrentRoute = (route: string): boolean => {
    const currentPath = usePage().url;
    return currentPath === route || currentPath.startsWith(route + "/");
};
</script>
