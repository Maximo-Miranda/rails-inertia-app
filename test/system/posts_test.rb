require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @published_post = posts(:published_post)
    @draft_post = posts(:draft_post)
  end

  # ===========================================
  # Tests de Listado (Index)
  # ===========================================

  test "muestra la lista de posts" do
    visit posts_path

    assert_selector '[data-testid="page-title"]', text: "Posts"
    assert_selector '[data-testid="posts-table"]'
    assert_text @published_post.title
    assert_text @draft_post.title
  end

  test "muestra estado correcto para posts publicados y borradores" do
    visit posts_path

    assert_selector "[data-testid='post-status-#{@published_post.id}']", text: "Publicado"
    assert_selector "[data-testid='post-status-#{@draft_post.id}']", text: "Borrador"
  end

  test "filtra posts por búsqueda de título" do
    visit posts_path

    find('[data-testid="search-input"]').fill_in with: "Vuetify"

    # Esperar a que el filtro se aplique verificando el resultado esperado
    assert_text "Tutorial de Vuetify"
  end

  test "filtra posts por estado publicado" do
    visit posts_path

    find('[data-testid="status-filter"]').click
    find(".v-overlay .v-list-item", text: "Publicados").click

    # Esperar a que se muestre el post publicado
    assert_selector "[data-testid='post-status-#{@published_post.id}']", text: "Publicado"
  end

  test "muestra estado vacío cuando no hay posts" do
    Post.destroy_all
    visit posts_path

    assert_selector '[data-testid="empty-state"]'
    assert_text "No hay posts"
  end

  # ===========================================
  # Tests de Creación (New/Create)
  # ===========================================

  test "navega a la página de nuevo post" do
    visit posts_path

    find('[data-testid="btn-new-post"]').click

    assert_selector '[data-testid="page-title"]', text: "Nuevo Post"
  end

  test "crea un nuevo post como borrador" do
    visit new_post_path

    find('[data-testid="input-title"]').fill_in with: "Mi nuevo post de prueba"
    find('[data-testid="input-body"]').fill_in with: "Este es el contenido de mi nuevo post con suficiente texto."

    find('[data-testid="btn-submit"]').click

    assert_text "Post creado exitosamente"
    assert_text "Mi nuevo post de prueba"
  end

  test "crea un nuevo post publicado" do
    visit new_post_path

    find('[data-testid="input-title"]').fill_in with: "Post publicado inmediatamente"
    find('[data-testid="input-body"]').fill_in with: "Este post se publicará inmediatamente al crearse."

    find("label", text: "Publicar inmediatamente").click

    find('[data-testid="btn-submit"]').click

    assert_text "Post creado exitosamente"
  end

  test "muestra vista previa mientras se escribe" do
    visit new_post_path

    find('[data-testid="input-title"]').fill_in with: "Título de vista previa"

    assert_selector '[data-testid="preview-title"]', text: "Título de vista previa"

    find('[data-testid="input-body"]').fill_in with: "Contenido de la vista previa"

    assert_selector '[data-testid="preview-body"]', text: "Contenido de la vista previa"
  end

  test "muestra errores de validación en el formulario" do
    visit new_post_path

    find('[data-testid="input-title"]').fill_in with: "AB"
    find('[data-testid="input-body"]').fill_in with: "Corto"

    # El botón debería estar deshabilitado o mostrar errores
    assert_text "al menos 3 caracteres"
  end

  test "botón cancelar regresa a la lista" do
    visit new_post_path

    find('[data-testid="btn-cancel"]').click

    assert_selector '[data-testid="page-title"]', text: "Posts"
  end

  # ===========================================
  # Tests de Lectura (Show)
  # ===========================================

  test "muestra los detalles de un post" do
    visit post_path(@published_post)

    assert_selector '[data-testid="page-title"]', text: @published_post.title
    assert_selector '[data-testid="post-body"]', text: @published_post.body
    assert_selector '[data-testid="post-status"]', text: "Publicado"
  end

  test "muestra información del post en la barra lateral" do
    visit post_path(@published_post)

    assert_selector '[data-testid="info-id"]', text: @published_post.id.to_s
    assert_selector '[data-testid="info-created"]'
    assert_selector '[data-testid="info-updated"]'
  end

  test "navega desde la lista al detalle del post" do
    visit posts_path

    find("[data-testid='btn-view-#{@published_post.id}']").click

    assert_selector '[data-testid="page-title"]', text: @published_post.title
  end

  # ===========================================
  # Tests de Edición (Edit/Update)
  # ===========================================

  test "navega a la página de edición" do
    visit posts_path

    find("[data-testid='btn-edit-#{@published_post.id}']").click

    assert_selector '[data-testid="page-title"]', text: "Editar Post"
  end

  test "actualiza un post existente" do
    visit edit_post_path(@published_post)

    find('[data-testid="input-title"]').fill_in with: "Título actualizado del post"

    find('[data-testid="btn-submit"]').click

    assert_text "Post actualizado exitosamente"
    assert_text "Título actualizado del post"
  end

  test "navega a edición desde la página de detalle" do
    visit post_path(@published_post)

    find('[data-testid="btn-edit"]').click

    assert_selector '[data-testid="page-title"]', text: "Editar Post"
  end

  # ===========================================
  # Tests de Eliminación (Destroy)
  # ===========================================

  test "elimina un post desde la lista" do
    visit posts_path

    find("[data-testid='btn-delete-#{@draft_post.id}']").click

    assert_selector '[data-testid="delete-dialog-title"]', text: "Confirmar eliminación"

    find('[data-testid="btn-confirm-delete"]').click

    assert_text "Post eliminado exitosamente"
    assert_no_text @draft_post.title
  end

  test "cancela la eliminación de un post" do
    visit posts_path

    find("[data-testid='btn-delete-#{@draft_post.id}']").click

    assert_selector '[data-testid="delete-dialog-title"]'

    find('[data-testid="btn-cancel-delete"]').click

    assert_no_selector '[data-testid="delete-dialog-title"]'
    assert_text @draft_post.title
  end

  test "elimina un post desde la página de detalle" do
    visit post_path(@draft_post)

    find('[data-testid="btn-delete"]').click

    assert_selector '[data-testid="delete-dialog-title"]'

    find('[data-testid="btn-confirm-delete"]').click

    assert_text "Post eliminado exitosamente"
  end

  # ===========================================
  # Tests de Publicar/Despublicar
  # ===========================================

  test "publica un post borrador desde la lista" do
    visit posts_path

    find("[data-testid='btn-publish-#{@draft_post.id}']").click

    assert_text "Post publicado exitosamente"
    assert_selector "[data-testid='post-status-#{@draft_post.id}']", text: "Publicado"
  end

  test "despublica un post desde la lista" do
    visit posts_path

    find("[data-testid='btn-unpublish-#{@published_post.id}']").click

    assert_text "Post despublicado exitosamente"
    assert_selector "[data-testid='post-status-#{@published_post.id}']", text: "Borrador"
  end

  test "publica un post desde la página de detalle" do
    visit post_path(@draft_post)

    assert_selector '[data-testid="btn-publish"]'

    find('[data-testid="btn-publish"]').click

    assert_text "Post publicado exitosamente"
  end

  test "despublica un post desde la página de detalle" do
    visit post_path(@published_post)

    assert_selector '[data-testid="btn-unpublish"]'

    find('[data-testid="btn-unpublish"]').click

    assert_text "Post despublicado exitosamente"
  end

  # ===========================================
  # Tests de Navegación
  # ===========================================

  test "botón atrás regresa a la lista desde el detalle" do
    visit post_path(@published_post)

    find('[data-testid="btn-back"]').click

    assert_selector '[data-testid="page-title"]', text: "Posts"
  end

  test "botón atrás regresa a la lista desde edición" do
    visit edit_post_path(@published_post)

    find('[data-testid="btn-back"]').click

    assert_selector '[data-testid="page-title"]', text: "Posts"
  end

  # ===========================================
  # Tests de Paginación (v-data-table-server)
  # ===========================================

  test "cambia el número de items por página usando v-data-table-server" do
    # Crear suficientes posts para paginación
    15.times do |i|
      Post.create!(title: "Post para paginación #{i}", body: "Contenido suficiente para el post #{i}")
    end

    visit posts_path

    # El v-data-table-server tiene su propio selector de items por página integrado
    within('[data-testid="posts-table"]') do
      find(".v-data-table-footer__items-per-page .v-select").click
    end

    # Seleccionar 5 items por página del menú desplegable
    first(".v-overlay .v-list-item", text: /^5$/).click

    # Esperar a que la URL se actualice con el parámetro per_page
    assert_current_path(/per_page=5/, wait: 5)

    # Verificar que la tabla muestra paginación
    # Y que muestra los datos correctos
    within('[data-testid="posts-table"]') do
      assert_selector "tbody tr", count: 5, wait: 5
      assert_selector ".v-data-table-footer__pagination"
    end
  end

  test "navega entre páginas usando la paginación integrada de v-data-table-server" do
    # Crear suficientes posts para tener múltiples páginas
    15.times do |i|
      Post.create!(title: "Post paginado #{i}", body: "Contenido del post paginado número #{i}")
    end

    sleep 2

    visit posts_path(per_page: 5)

    sleep 2

    # Verificar que estamos en la primera página y hacer clic en siguiente
    within('[data-testid="posts-table"]') do
      assert_selector ".v-data-table-footer__pagination"
      sleep 2
      find('.v-data-table-footer__pagination .v-btn[aria-label="Next page"]').click
    end

    sleep 3

    # Esperar a que la URL se actualice con page=2
    assert_current_path(/page=2/, wait: 5)
  end

  test "ordena posts por título al hacer clic en el header de la columna" do
    visit posts_path

    # Hacer clic en el header de la columna "Título" para ordenar
    within('[data-testid="posts-table"]') do
      find("th .v-data-table-header__content", text: "Título").click
    end

    # Esperar a que la URL contenga el parámetro de ordenamiento
    assert_current_path(/sort_by=title/, wait: 5)
  end

  test "ordena posts por fecha al hacer clic en el header de la columna" do
    visit posts_path

    # Hacer clic en el header de la columna "Fecha" para ordenar
    within('[data-testid="posts-table"]') do
      find("th .v-data-table-header__content", text: "Fecha").click
    end

    # Esperar a que la URL contenga el parámetro de ordenamiento
    assert_current_path(/sort_by=created_at/, wait: 5)
  end

  test "la tabla se renderiza correctamente con datos" do
    # Crear suficientes posts
    10.times do |i|
      Post.create!(title: "Post tabla #{i}", body: "Contenido del post #{i}")
    end

    visit posts_path

    # Verificar que la tabla existe y muestra datos
    assert_selector '[data-testid="posts-table"]'

    # Verificar que el footer de paginación existe
    within('[data-testid="posts-table"]') do
      assert_selector ".v-data-table-footer"
      assert_selector ".v-data-table-footer__items-per-page"
    end
  end
end
