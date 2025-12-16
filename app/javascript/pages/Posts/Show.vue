<template>
    <v-app>
        <v-main>
            <v-container>
                <!-- Header -->
                <v-row class="mb-4">
                    <v-col cols="12">
                        <div class="d-flex align-center justify-space-between">
                            <div class="d-flex align-center">
                                <v-btn
                                    icon
                                    variant="text"
                                    data-testid="btn-back"
                                    @click="goBack"
                                >
                                    <v-icon>mdi-arrow-left</v-icon>
                                </v-btn>
                                <h1 class="ml-2" data-testid="page-title">{{ post.title }}</h1>
                            </div>
                            <div class="d-flex gap-2">
                                <v-btn
                                    variant="outlined"
                                    color="info"
                                    data-testid="btn-edit"
                                    @click="navigateToEdit"
                                >
                                    <v-icon left>mdi-pencil</v-icon>
                                    Editar
                                </v-btn>
                                <v-btn
                                    v-if="!post.published"
                                    color="success"
                                    data-testid="btn-publish"
                                    @click="publishPost"
                                >
                                    <v-icon left>mdi-publish</v-icon>
                                    Publicar
                                </v-btn>
                                <v-btn
                                    v-else
                                    color="warning"
                                    data-testid="btn-unpublish"
                                    @click="unpublishPost"
                                >
                                    <v-icon left>mdi-publish-off</v-icon>
                                    Despublicar
                                </v-btn>
                                <v-btn
                                    color="error"
                                    variant="outlined"
                                    data-testid="btn-delete"
                                    @click="confirmDelete"
                                >
                                    <v-icon left>mdi-delete</v-icon>
                                    Eliminar
                                </v-btn>
                            </div>
                        </div>
                    </v-col>
                </v-row>

                <!-- Content -->
                <v-row>
                    <v-col cols="12" md="8">
                        <v-card>
                            <v-card-text>
                                <!-- Status Chip -->
                                <v-chip
                                    :color="post.published ? 'success' : 'warning'"
                                    size="small"
                                    class="mb-4"
                                    data-testid="post-status"
                                >
                                    {{ post.published ? 'Publicado' : 'Borrador' }}
                                </v-chip>

                                <!-- Body -->
                                <div
                                    class="text-body-1"
                                    data-testid="post-body"
                                    style="white-space: pre-wrap;"
                                >
                                    {{ post.body }}
                                </div>
                            </v-card-text>
                        </v-card>
                    </v-col>

                    <!-- Sidebar Info -->
                    <v-col cols="12" md="4">
                        <v-card>
                            <v-card-title>
                                <v-icon left>mdi-information</v-icon>
                                Información
                            </v-card-title>
                            <v-card-text>
                                <v-list density="compact">
                                    <v-list-item>
                                        <template v-slot:prepend>
                                            <v-icon>mdi-identifier</v-icon>
                                        </template>
                                        <v-list-item-title>ID</v-list-item-title>
                                        <v-list-item-subtitle data-testid="info-id">
                                            {{ post.id }}
                                        </v-list-item-subtitle>
                                    </v-list-item>
                                    <v-list-item>
                                        <template v-slot:prepend>
                                            <v-icon>mdi-calendar-plus</v-icon>
                                        </template>
                                        <v-list-item-title>Creado</v-list-item-title>
                                        <v-list-item-subtitle data-testid="info-created">
                                            {{ formatDate(post.created_at) }}
                                        </v-list-item-subtitle>
                                    </v-list-item>
                                    <v-list-item>
                                        <template v-slot:prepend>
                                            <v-icon>mdi-calendar-edit</v-icon>
                                        </template>
                                        <v-list-item-title>Actualizado</v-list-item-title>
                                        <v-list-item-subtitle data-testid="info-updated">
                                            {{ formatDate(post.updated_at) }}
                                        </v-list-item-subtitle>
                                    </v-list-item>
                                    <v-list-item v-if="post.published_at">
                                        <template v-slot:prepend>
                                            <v-icon>mdi-publish</v-icon>
                                        </template>
                                        <v-list-item-title>Publicado</v-list-item-title>
                                        <v-list-item-subtitle data-testid="info-published">
                                            {{ formatDate(post.published_at) }}
                                        </v-list-item-subtitle>
                                    </v-list-item>
                                </v-list>
                            </v-card-text>
                        </v-card>
                    </v-col>
                </v-row>

                <!-- Delete Confirmation Dialog -->
                <v-dialog v-model="deleteDialog" max-width="400">
                    <v-card>
                        <v-card-title data-testid="delete-dialog-title">
                            Confirmar eliminación
                        </v-card-title>
                        <v-card-text>
                            ¿Estás seguro de que deseas eliminar el post "{{ post.title }}"?
                            Esta acción no se puede deshacer.
                        </v-card-text>
                        <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn
                                variant="text"
                                data-testid="btn-cancel-delete"
                                @click="deleteDialog = false"
                            >
                                Cancelar
                            </v-btn>
                            <v-btn
                                color="error"
                                variant="flat"
                                data-testid="btn-confirm-delete"
                                :loading="deleting"
                                @click="deletePost"
                            >
                                Eliminar
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
            </v-container>
        </v-main>
    </v-app>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { router } from '@inertiajs/vue3';

interface Post {
    id: number;
    title: string;
    body: string;
    published: boolean;
    published_at: string | null;
    status: string;
    created_at: string;
    updated_at: string;
}

const props = defineProps<{
    post: Post;
}>();

// Local state
const deleteDialog = ref(false);
const deleting = ref(false);

// Methods
const goBack = () => {
    router.get('/posts');
};

const navigateToEdit = () => {
    router.get(`/posts/${props.post.id}/edit`);
};

const publishPost = () => {
    router.patch(`/posts/${props.post.id}/publish`);
};

const unpublishPost = () => {
    router.patch(`/posts/${props.post.id}/unpublish`);
};

const confirmDelete = () => {
    deleteDialog.value = true;
};

const deletePost = () => {
    deleting.value = true;
    router.delete(`/posts/${props.post.id}`, {
        onFinish: () => {
            deleting.value = false;
            deleteDialog.value = false;
        }
    });
};

const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('es-ES', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
};
</script>
