<template>
    <v-app>
        <v-main>
            <v-container>
                <!-- Header -->
                <v-row class="mb-4">
                    <v-col cols="12">
                        <div class="d-flex align-center">
                            <v-btn
                                icon
                                variant="text"
                                data-testid="btn-back"
                                @click="goBack"
                            >
                                <v-icon>mdi-arrow-left</v-icon>
                            </v-btn>
                            <h1 class="ml-2" data-testid="page-title">Nuevo Post</h1>
                        </div>
                    </v-col>
                </v-row>

                <!-- Form -->
                <v-row>
                    <v-col cols="12" md="8">
                        <v-card>
                            <v-card-text>
                                <v-form ref="formRef" v-model="valid" @submit.prevent="submitForm">
                                    <!-- Title -->
                                    <v-text-field
                                        v-model="form.title"
                                        label="Título"
                                        variant="outlined"
                                        :rules="titleRules"
                                        :error-messages="errors.title"
                                        data-testid="input-title"
                                        class="mb-4"
                                        required
                                    ></v-text-field>

                                    <!-- Body -->
                                    <v-textarea
                                        v-model="form.body"
                                        label="Contenido"
                                        variant="outlined"
                                        :rules="bodyRules"
                                        :error-messages="errors.body"
                                        data-testid="input-body"
                                        rows="10"
                                        class="mb-4"
                                        required
                                    ></v-textarea>

                                    <!-- Published Switch -->
                                    <v-switch
                                        v-model="form.published"
                                        label="Publicar inmediatamente"
                                        color="primary"
                                        data-testid="switch-published"
                                        class="mb-4"
                                    ></v-switch>

                                    <!-- Actions -->
                                    <div class="d-flex justify-end gap-2">
                                        <v-btn
                                            variant="outlined"
                                            data-testid="btn-cancel"
                                            @click="goBack"
                                        >
                                            Cancelar
                                        </v-btn>
                                        <v-btn
                                            type="submit"
                                            color="primary"
                                            :loading="submitting"
                                            :disabled="!valid"
                                            data-testid="btn-submit"
                                        >
                                            Crear Post
                                        </v-btn>
                                    </div>
                                </v-form>
                            </v-card-text>
                        </v-card>
                    </v-col>

                    <!-- Preview Panel -->
                    <v-col cols="12" md="4">
                        <v-card>
                            <v-card-title>
                                <v-icon left>mdi-eye</v-icon>
                                Vista previa
                            </v-card-title>
                            <v-card-text>
                                <div v-if="form.title || form.body">
                                    <h2 class="text-h5 mb-2" data-testid="preview-title">
                                        {{ form.title || 'Sin título' }}
                                    </h2>
                                    <v-chip
                                        :color="form.published ? 'success' : 'warning'"
                                        size="small"
                                        class="mb-3"
                                        data-testid="preview-status"
                                    >
                                        {{ form.published ? 'Publicado' : 'Borrador' }}
                                    </v-chip>
                                    <p class="text-body-1" data-testid="preview-body" style="white-space: pre-wrap;">
                                        {{ form.body || 'Sin contenido' }}
                                    </p>
                                </div>
                                <div v-else class="text-center text-grey" data-testid="preview-empty">
                                    <v-icon size="48">mdi-file-document-outline</v-icon>
                                    <p class="mt-2">Escribe algo para ver la vista previa</p>
                                </div>
                            </v-card-text>
                        </v-card>
                    </v-col>
                </v-row>
            </v-container>
        </v-main>
    </v-app>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue';
import { router } from '@inertiajs/vue3';

interface PostForm {
    title: string;
    body: string;
    published: boolean;
}

interface Props {
    post: PostForm;
    errors?: {
        title?: string[];
        body?: string[];
    };
}

const props = withDefaults(defineProps<Props>(), {
    errors: () => ({})
});

// Form state
const formRef = ref();
const valid = ref(false);
const submitting = ref(false);

const form = reactive<PostForm>({
    title: props.post.title,
    body: props.post.body,
    published: props.post.published
});

// Validation rules
const titleRules = [
    (v: string) => !!v || 'El título es requerido',
    (v: string) => (v && v.length >= 3) || 'El título debe tener al menos 3 caracteres',
    (v: string) => (v && v.length <= 255) || 'El título no puede exceder 255 caracteres'
];

const bodyRules = [
    (v: string) => !!v || 'El contenido es requerido',
    (v: string) => (v && v.length >= 10) || 'El contenido debe tener al menos 10 caracteres'
];

// Computed errors from server
const errors = reactive({
    title: props.errors.title || [],
    body: props.errors.body || []
});

// Methods
const goBack = () => {
    router.get('/posts');
};

const submitForm = async () => {
    const { valid: isValid } = await formRef.value.validate();

    if (!isValid) return;

    submitting.value = true;

    router.post('/posts', {
        post: {
            title: form.title,
            body: form.body,
            published: form.published
        }
    }, {
        onFinish: () => {
            submitting.value = false;
        }
    });
};
</script>
