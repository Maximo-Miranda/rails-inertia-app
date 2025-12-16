<template>
    <v-container>
        <!-- Card con título -->
        <v-row>
            <v-col cols="12">
                <v-card>
                    <v-card-title>
                        <h1>¡Vuetify funcionando con Inertia!</h1>
                    </v-card-title>
                    <v-card-text>
                        <p>
                            Este es un componente de Vuetify renderizado con
                            Inertia.js
                        </p>

                        <v-btn
                            id="btn-primary"
                            data-testid="btn-primary"
                            color="primary"
                            class="mr-2"
                        >
                            Botón Primario
                        </v-btn>

                        <v-btn
                            id="btn-secondary"
                            data-testid="btn-secondary"
                            color="secondary"
                        >
                            Botón Secundario
                        </v-btn>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>

        <!-- Text Fields -->
        <v-row class="mt-4">
            <v-col cols="12" md="6">
                <v-text-field
                    id="vuetify-test-name"
                    data-testid="vuetify-test-name"
                    v-model="form.name"
                    label="Nombre"
                    variant="outlined"
                ></v-text-field>
            </v-col>
            <v-col cols="12" md="6">
                <v-text-field
                    id="vuetify-test-email"
                    data-testid="vuetify-test-email"
                    v-model="form.email"
                    label="Email"
                    variant="outlined"
                ></v-text-field>
            </v-col>
        </v-row>

        <!-- Select -->
        <v-row>
            <v-col cols="12" md="6">
                <v-select
                    id="vuetify-test-country"
                    data-testid="vuetify-test-country"
                    v-model="form.country"
                    :items="countries"
                    label="País"
                    variant="outlined"
                ></v-select>
            </v-col>
            <v-col cols="12" md="6">
                <v-autocomplete
                    id="vuetify-test-city"
                    data-testid="vuetify-test-city"
                    v-model="form.city"
                    :items="cities"
                    label="Ciudad"
                    variant="outlined"
                ></v-autocomplete>
                <span v-if="form.city" data-testid="city-selected"
                    >Ciudad: {{ form.city }}</span
                >
            </v-col>
        </v-row>

        <!-- Checkbox y Switch -->
        <v-row>
            <v-col cols="12" md="6">
                <v-checkbox
                    id="vuetify-test-terms"
                    data-testid="vuetify-test-terms"
                    v-model="form.acceptTerms"
                    label="Acepto los términos y condiciones"
                ></v-checkbox>
                <span v-if="form.acceptTerms" data-testid="terms-accepted"
                    >✓ Términos aceptados</span
                >
            </v-col>
            <v-col cols="12" md="6">
                <v-switch
                    id="vuetify-test-notifications"
                    data-testid="vuetify-test-notifications"
                    v-model="form.notifications"
                    label="Recibir notificaciones"
                    color="primary"
                ></v-switch>
                <span
                    v-if="form.notifications"
                    data-testid="notifications-enabled"
                    >✓ Notificaciones activas</span
                >
            </v-col>
        </v-row>

        <!-- Date Picker -->
        <v-row>
            <v-col cols="12" md="6">
                <v-text-field
                    id="vuetify-test-date"
                    data-testid="vuetify-test-date"
                    v-model="form.date"
                    label="Fecha de nacimiento"
                    type="date"
                    variant="outlined"
                ></v-text-field>
            </v-col>
            <v-col cols="12" md="6">
                <v-slider
                    id="vuetify-test-age"
                    data-testid="vuetify-test-age"
                    v-model="form.age"
                    label="Edad"
                    :min="18"
                    :max="100"
                    thumb-label
                ></v-slider>
            </v-col>
        </v-row>

        <!-- Accordion / Expansion Panels -->
        <v-row>
            <v-col cols="12">
                <v-expansion-panels
                    id="vuetify-test-accordion"
                    data-testid="vuetify-test-accordion"
                >
                    <v-expansion-panel>
                        <v-expansion-panel-title data-testid="panel-1-title">
                            Panel 1 - Información Personal
                        </v-expansion-panel-title>
                        <v-expansion-panel-text data-testid="panel-1-content">
                            Contenido del panel 1: Aquí va la información
                            personal.
                        </v-expansion-panel-text>
                    </v-expansion-panel>
                    <v-expansion-panel>
                        <v-expansion-panel-title data-testid="panel-2-title">
                            Panel 2 - Preferencias
                        </v-expansion-panel-title>
                        <v-expansion-panel-text data-testid="panel-2-content">
                            Contenido del panel 2: Aquí van las preferencias.
                        </v-expansion-panel-text>
                    </v-expansion-panel>
                </v-expansion-panels>
            </v-col>
        </v-row>

        <!-- Tabs -->
        <v-row class="mt-4">
            <v-col cols="12">
                <v-tabs v-model="activeTab" data-testid="vuetify-test-tabs">
                    <v-tab value="tab1" data-testid="tab-1">Tab 1</v-tab>
                    <v-tab value="tab2" data-testid="tab-2">Tab 2</v-tab>
                    <v-tab value="tab3" data-testid="tab-3">Tab 3</v-tab>
                </v-tabs>
                <v-tabs-window v-model="activeTab">
                    <v-tabs-window-item value="tab1">
                        <v-card flat>
                            <v-card-text data-testid="tab1-content">
                                Contenido de Tab 1
                            </v-card-text>
                        </v-card>
                    </v-tabs-window-item>
                    <v-tabs-window-item value="tab2">
                        <v-card flat>
                            <v-card-text data-testid="tab2-content">
                                Contenido de Tab 2
                            </v-card-text>
                        </v-card>
                    </v-tabs-window-item>
                    <v-tabs-window-item value="tab3">
                        <v-card flat>
                            <v-card-text data-testid="tab3-content">
                                Contenido de Tab 3
                            </v-card-text>
                        </v-card>
                    </v-tabs-window-item>
                </v-tabs-window>
            </v-col>
        </v-row>

        <!-- Dialog -->
        <v-row class="mt-4">
            <v-col cols="12">
                <v-btn
                    id="btn-open-dialog"
                    data-testid="btn-open-dialog"
                    color="primary"
                    @click="dialog = true"
                >
                    Abrir Dialog
                </v-btn>

                <v-dialog v-model="dialog" max-width="500">
                    <v-card>
                        <v-card-title data-testid="dialog-title">
                            Título del Dialog
                        </v-card-title>
                        <v-card-text data-testid="dialog-content">
                            Este es el contenido del dialog.
                        </v-card-text>
                        <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn
                                id="btn-close-dialog"
                                data-testid="btn-close-dialog"
                                color="primary"
                                @click="dialog = false"
                            >
                                Cerrar
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
            </v-col>
        </v-row>

        <!-- Snackbar -->
        <v-row class="mt-4">
            <v-col cols="12">
                <v-btn
                    id="btn-show-snackbar"
                    data-testid="btn-show-snackbar"
                    color="success"
                    @click="snackbar = true"
                >
                    Mostrar Snackbar
                </v-btn>

                <v-snackbar
                    v-model="snackbar"
                    :timeout="3000"
                    data-testid="snackbar"
                >
                    ¡Mensaje de snackbar exitoso!
                    <template v-slot:actions>
                        <v-btn
                            data-testid="btn-close-snackbar"
                            variant="text"
                            @click="snackbar = false"
                        >
                            Cerrar
                        </v-btn>
                    </template>
                </v-snackbar>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup lang="ts">
import { ref, reactive } from "vue";

// Esta página no usa el layout por defecto
// defineOptions({
//     layout: null,
// });

const form = reactive({
    name: "",
    email: "",
    country: null,
    city: null,
    acceptTerms: false,
    notifications: false,
    date: "",
    age: 25,
});

const countries = ["Colombia", "México", "Argentina", "España", "Chile"];
const cities = [
    "Bogotá",
    "Medellín",
    "Ciudad de México",
    "Buenos Aires",
    "Madrid",
    "Santiago",
];

const activeTab = ref("tab1");
const dialog = ref(false);
const snackbar = ref(false);
</script>
