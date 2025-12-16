<template>
    <v-app>
        <v-main>
            <v-container>
                <!-- Header -->
                <v-row class="mb-4">
                    <v-col cols="12">
                        <div class="d-flex justify-space-between align-center">
                            <h1 data-testid="page-title">Posts</h1>
                            <v-btn
                                color="primary"
                                data-testid="btn-new-post"
                                @click="navigateToNew"
                            >
                                <v-icon left>mdi-plus</v-icon>
                                Nuevo Post
                            </v-btn>
                        </div>
                    </v-col>
                </v-row>

                <!-- Flash Messages -->
                <v-row v-if="$page.props.flash?.notice">
                    <v-col cols="12">
                        <v-alert
                            type="success"
                            dismissible
                            data-testid="flash-notice"
                        >
                            {{ $page.props.flash.notice }}
                        </v-alert>
                    </v-col>
                </v-row>

                <!-- Filters -->
                <v-row class="mb-4">
                    <v-col cols="12" md="6">
                        <v-text-field
                            v-model="localFilters.search"
                            label="Buscar por título"
                            prepend-inner-icon="mdi-magnify"
                            variant="outlined"
                            clearable
                            data-testid="search-input"
                            @update:model-value="debouncedSearch"
                        ></v-text-field>
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-select
                            v-model="localFilters.status"
                            :items="statusOptions"
                            item-title="text"
                            item-value="value"
                            label="Estado"
                            variant="outlined"
                            data-testid="status-filter"
                            @update:model-value="applyFilters"
                        ></v-select>
                    </v-col>
                </v-row>

                <!-- Data Table Server Side -->
                <v-row>
                    <v-col cols="12">
                        <v-card>
                            <v-data-table-server
                                v-model:items-per-page="
                                    tableOptions.itemsPerPage
                                "
                                v-model:page="tableOptions.page"
                                v-model:sort-by="tableOptions.sortBy"
                                :headers="headers"
                                :items="posts"
                                :items-length="pagination.total"
                                :loading="loading"
                                :items-per-page-options="perPageOptions"
                                data-testid="posts-table"
                                class="elevation-1"
                                @update:options="onOptionsUpdate"
                            >
                                <!-- Status Column -->
                                <template v-slot:item.status="{ item }">
                                    <v-chip
                                        :color="
                                            item.published
                                                ? 'success'
                                                : 'warning'
                                        "
                                        size="small"
                                        :data-testid="`post-status-${item.id}`"
                                    >
                                        {{
                                            item.published
                                                ? "Publicado"
                                                : "Borrador"
                                        }}
                                    </v-chip>
                                </template>

                                <!-- Date Column -->
                                <template v-slot:item.created_at="{ item }">
                                    {{ formatDate(item.created_at) }}
                                </template>

                                <!-- Actions Column -->
                                <template v-slot:item.actions="{ item }">
                                    <v-btn
                                        icon
                                        size="small"
                                        variant="text"
                                        color="primary"
                                        :data-testid="`btn-view-${item.id}`"
                                        @click="navigateToShow(item.id)"
                                    >
                                        <v-icon>mdi-eye</v-icon>
                                    </v-btn>
                                    <v-btn
                                        icon
                                        size="small"
                                        variant="text"
                                        color="info"
                                        :data-testid="`btn-edit-${item.id}`"
                                        @click="navigateToEdit(item.id)"
                                    >
                                        <v-icon>mdi-pencil</v-icon>
                                    </v-btn>
                                    <v-btn
                                        v-if="!item.published"
                                        icon
                                        size="small"
                                        variant="text"
                                        color="success"
                                        :data-testid="`btn-publish-${item.id}`"
                                        @click="publishPost(item.id)"
                                    >
                                        <v-icon>mdi-publish</v-icon>
                                    </v-btn>
                                    <v-btn
                                        v-else
                                        icon
                                        size="small"
                                        variant="text"
                                        color="warning"
                                        :data-testid="`btn-unpublish-${item.id}`"
                                        @click="unpublishPost(item.id)"
                                    >
                                        <v-icon>mdi-publish-off</v-icon>
                                    </v-btn>
                                    <v-btn
                                        icon
                                        size="small"
                                        variant="text"
                                        color="error"
                                        :data-testid="`btn-delete-${item.id}`"
                                        @click="confirmDelete(item)"
                                    >
                                        <v-icon>mdi-delete</v-icon>
                                    </v-btn>
                                </template>

                                <!-- Empty State -->
                                <template v-slot:no-data>
                                    <div
                                        class="text-center pa-4"
                                        data-testid="empty-state"
                                    >
                                        <v-icon size="64" color="grey"
                                            >mdi-post-outline</v-icon
                                        >
                                        <p class="text-h6 mt-2">No hay posts</p>
                                        <p class="text-body-2 text-grey">
                                            Crea tu primer post para comenzar
                                        </p>
                                    </div>
                                </template>
                            </v-data-table-server>
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
                            ¿Estás seguro de que deseas eliminar el post "{{
                                postToDelete?.title
                            }}"? Esta acción no se puede deshacer.
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
import { ref, reactive, watch } from "vue";
import { router } from "@inertiajs/vue3";

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

interface Pagination {
    page: number;
    per_page: number;
    total: number;
    total_pages: number;
}

interface Filters {
    search: string;
    status: string;
}

interface SortItem {
    key: string;
    order: "asc" | "desc";
}

interface TableOptions {
    page: number;
    itemsPerPage: number;
    sortBy: SortItem[];
}

const props = defineProps<{
    posts: Post[];
    pagination: Pagination;
    filters: Filters;
}>();

// Local state
const deleteDialog = ref(false);
const postToDelete = ref<Post | null>(null);
const deleting = ref(false);
const loading = ref(false);

// Table options synced with server
const tableOptions = reactive<TableOptions>({
    page: props.pagination.page,
    itemsPerPage: props.pagination.per_page,
    sortBy: [],
});

const localFilters = reactive({
    search: props.filters.search,
    status: props.filters.status,
});

// Table headers with sortable options
const headers = [
    { title: "ID", key: "id", width: "80px", sortable: true },
    { title: "Título", key: "title", sortable: true },
    { title: "Estado", key: "status", width: "120px", sortable: false },
    { title: "Fecha", key: "created_at", width: "150px", sortable: true },
    { title: "Acciones", key: "actions", sortable: false, width: "200px" },
];

const statusOptions = [
    { text: "Todos", value: "all" },
    { text: "Publicados", value: "published" },
    { text: "Borradores", value: "draft" },
];

const perPageOptions = [
    { value: 5, title: "5" },
    { value: 10, title: "10" },
    { value: 25, title: "25" },
    { value: 50, title: "50" },
];

// Watch for prop changes to sync table state
watch(
    () => props.pagination,
    (newPagination) => {
        tableOptions.page = newPagination.page;
        tableOptions.itemsPerPage = newPagination.per_page;
    },
    { deep: true },
);

watch(
    () => props.filters,
    (newFilters) => {
        localFilters.search = newFilters.search;
        localFilters.status = newFilters.status;
    },
    { deep: true },
);

// Debounce search
let searchTimeout: ReturnType<typeof setTimeout>;
const debouncedSearch = () => {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        applyFilters();
    }, 300);
};

// Track previous sort state to detect changes
let previousSortBy = JSON.stringify(tableOptions.sortBy);

// Handle table options update (pagination, sorting)
const onOptionsUpdate = (options: {
    page: number;
    itemsPerPage: number;
    sortBy: SortItem[];
}) => {
    const currentSortBy = JSON.stringify(options.sortBy);
    const sortChanged = currentSortBy !== previousSortBy;

    // Check if anything actually changed
    const pageChanged = options.page !== props.pagination.page;
    const perPageChanged = options.itemsPerPage !== props.pagination.per_page;

    if (!pageChanged && !perPageChanged && !sortChanged) {
        return;
    }

    // Update previous sort state
    previousSortBy = currentSortBy;
    tableOptions.sortBy = options.sortBy;

    loadData({
        page: options.page,
        per_page: options.itemsPerPage,
        sortBy: options.sortBy,
    });
};

// Load data from server
const loadData = (
    params: { page?: number; per_page?: number; sortBy?: SortItem[] } = {},
) => {
    loading.value = true;

    const sortBy = params.sortBy || tableOptions.sortBy;
    const sortParams: Record<string, string> = {};

    if (sortBy.length > 0) {
        sortParams.sort_by = sortBy[0].key;
        sortParams.sort_direction = sortBy[0].order;
    }

    router.get(
        "/posts",
        {
            search: localFilters.search || undefined,
            status:
                localFilters.status !== "all" ? localFilters.status : undefined,
            per_page: params.per_page || tableOptions.itemsPerPage,
            page: params.page || tableOptions.page,
            ...sortParams,
        },
        {
            preserveState: true,
            preserveScroll: true,
            onFinish: () => {
                loading.value = false;
            },
        },
    );
};

// Apply filters and reset to first page
const applyFilters = () => {
    loading.value = true;

    const sortParams: Record<string, string> = {};
    if (tableOptions.sortBy.length > 0) {
        sortParams.sort_by = tableOptions.sortBy[0].key;
        sortParams.sort_direction = tableOptions.sortBy[0].order;
    }

    router.get(
        "/posts",
        {
            search: localFilters.search || undefined,
            status:
                localFilters.status !== "all" ? localFilters.status : undefined,
            per_page: tableOptions.itemsPerPage,
            page: 1,
            ...sortParams,
        },
        {
            preserveState: true,
            preserveScroll: true,
            onFinish: () => {
                loading.value = false;
            },
        },
    );
};

const navigateToNew = () => {
    router.get("/posts/new");
};

const navigateToShow = (id: number) => {
    router.get(`/posts/${id}`);
};

const navigateToEdit = (id: number) => {
    router.get(`/posts/${id}/edit`);
};

const publishPost = (id: number) => {
    router.patch(`/posts/${id}/publish`);
};

const unpublishPost = (id: number) => {
    router.patch(`/posts/${id}/unpublish`);
};

const confirmDelete = (post: Post) => {
    postToDelete.value = post;
    deleteDialog.value = true;
};

const deletePost = () => {
    if (!postToDelete.value) return;

    deleting.value = true;
    router.delete(`/posts/${postToDelete.value.id}`, {
        onFinish: () => {
            deleting.value = false;
            deleteDialog.value = false;
            postToDelete.value = null;
        },
    });
};

const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString("es-ES", {
        year: "numeric",
        month: "short",
        day: "numeric",
    });
};
</script>
