require "application_system_test_case"

class NavigationDrawerTest < ApplicationSystemTestCase
  setup do
    @published_post = posts(:published_post)
    @draft_post = posts(:draft_post)
  end

  # ===========================================
  # Tests de Navigation Drawer
  # ===========================================

  test "navigation drawer es visible al cargar la página de posts" do
    visit posts_path

    # Verificar que el drawer existe
    assert_selector '[data-testid="nav-drawer"]'

    # Verificar que el app bar está presente
    assert_selector '[data-testid="app-title"]', text: "Mi Aplicación"

    # Verificar que el botón del menú existe
    assert_selector '[data-testid="nav-icon"]'
  end

  test "navigation drawer muestra items de navegación correctos" do
    visit posts_path

    within('[data-testid="nav-drawer"]') do
      # Verificar que todos los items de navegación están presentes
      assert_selector '[data-testid="nav-item-home"]', text: "Inicio"
      assert_selector '[data-testid="nav-item-posts"]', text: "Posts"
      assert_selector '[data-testid="nav-item-vuetify-test"]', text: "Vuetify Test"
    end
  end

  test "navigation drawer muestra información de usuario" do
    visit posts_path

    within('[data-testid="nav-drawer"]') do
      # Verificar que la información del usuario está presente
      assert_selector '[data-testid="user-info"]', text: "Usuario"
      assert_selector '[data-testid="user-info"]', text: "usuario@ejemplo.com"
    end
  end

  test "navigation drawer puede abrirse y cerrarse con el botón hamburguesa" do
    visit posts_path

    # El drawer debería estar visible inicialmente
    assert_selector '[data-testid="nav-drawer"]', visible: true

    # Hacer clic en el botón del menú para cerrar/abrir
    find('[data-testid="nav-icon"]').click

    # Dar tiempo para la animación
    sleep 0.5

    # Hacer clic nuevamente para abrir
    find('[data-testid="nav-icon"]').click

    sleep 0.5

    # Verificar que el drawer está visible
    assert_selector '[data-testid="nav-drawer"]'
  end

  test "navega a Posts desde el drawer" do
    visit "/pages/vuetify_test"

    within('[data-testid="nav-drawer"]') do
      find('[data-testid="nav-item-posts"]').click
    end

    # Verificar que estamos en la página de posts
    assert_current_path posts_path
    assert_selector '[data-testid="page-title"]', text: "Posts"
    assert_selector '[data-testid="posts-table"]'
  end

  test "navega a Vuetify Test desde el drawer" do
    visit posts_path

    within('[data-testid="nav-drawer"]') do
      find('[data-testid="nav-item-vuetify-test"]').click
    end

    # Verificar que estamos en la página de Vuetify Test
    assert_current_path "/pages/vuetify_test"
    assert_text "¡Vuetify funcionando con Inertia!"
  end

  test "item activo se resalta correctamente en el drawer" do
    visit posts_path

    # El item de Posts debería estar activo
    within('[data-testid="nav-drawer"]') do
      posts_item = find('[data-testid="nav-item-posts"]')
      assert posts_item[:class].include?("v-list-item--active"), "El item de Posts debería estar activo"
    end
  end

  test "flujo completo: navega a Posts, crea un nuevo post y verifica que aparece en el listado" do
    # 1. Visitar la página inicial
    visit posts_path

    # 2. Verificar que el drawer es visible
    assert_selector '[data-testid="nav-drawer"]'

    # 3. Verificar que estamos en Posts
    assert_selector '[data-testid="page-title"]', text: "Posts"

    # 4. Contar posts actuales
    initial_posts_count = Post.count

    # 5. Hacer clic en "Nuevo Post"
    find('[data-testid="btn-new-post"]').click

    # 6. Verificar que estamos en la página de nuevo post
    assert_selector '[data-testid="page-title"]', text: "Nuevo Post"

    # 7. Verificar que el drawer sigue presente
    assert_selector '[data-testid="nav-drawer"]'

    # 8. Llenar el formulario
    find('[data-testid="input-title"]').fill_in with: "Post de prueba desde Navigation Drawer"
    find('[data-testid="input-body"]').fill_in with: "Este post fue creado para probar la funcionalidad del navigation drawer en el sistema."

    # 9. Marcar como publicado
    find("label", text: "Publicar inmediatamente").click

    # 10. Enviar el formulario
    find('[data-testid="btn-submit"]').click

    # 11. Verificar que se creó el post
    assert_text "Post creado exitosamente"
    assert_text "Post de prueba desde Navigation Drawer"

    # 12. Usar el navigation drawer para volver a Posts
    within('[data-testid="nav-drawer"]') do
      find('[data-testid="nav-item-posts"]').click
    end

    # 13. Verificar que estamos en la lista de posts
    assert_selector '[data-testid="page-title"]', text: "Posts"
    assert_selector '[data-testid="posts-table"]'

    # 14. Verificar que el nuevo post aparece en la lista
    assert_text "Post de prueba desde Navigation Drawer"

    # 15. Verificar que se incrementó el conteo de posts
    assert_equal initial_posts_count + 1, Post.count

    # 16. Verificar que el post está publicado
    new_post = Post.find_by(title: "Post de prueba desde Navigation Drawer")
    assert new_post.published, "El post debería estar publicado"

    # 17. Hacer clic en el post para ver los detalles
    find("[data-testid='btn-view-#{new_post.id}']").click

    # 18. Verificar los detalles del post
    assert_selector '[data-testid="page-title"]', text: "Post de prueba desde Navigation Drawer"
    assert_selector '[data-testid="post-body"]', text: "Este post fue creado para probar la funcionalidad del navigation drawer en el sistema."
    assert_selector '[data-testid="post-status"]', text: "Publicado"

    # 19. Verificar que el drawer sigue presente
    assert_selector '[data-testid="nav-drawer"]'
  end

  test "flujo de edición usando el drawer: edita un post y verifica los cambios" do
    # 1. Visitar la página de posts
    visit posts_path

    # 2. Navegar al detalle del post usando el drawer
    find("[data-testid='btn-view-#{@draft_post.id}']").click

    # 3. Verificar que estamos en el detalle
    assert_selector '[data-testid="page-title"]', text: @draft_post.title
    assert_selector '[data-testid="nav-drawer"]'

    # 4. Hacer clic en editar
    find('[data-testid="btn-edit"]').click

    # 5. Verificar que estamos en la página de edición
    assert_selector '[data-testid="page-title"]', text: "Editar Post"

    # 6. Modificar el título
    find('[data-testid="input-title"]').fill_in with: "Post editado con Navigation Drawer"

    # 7. Guardar cambios
    find('[data-testid="btn-submit"]').click

    # 8. Verificar mensaje de éxito
    assert_text "Post actualizado exitosamente"

    # 9. Usar el drawer para volver a la lista
    within('[data-testid="nav-drawer"]') do
      find('[data-testid="nav-item-posts"]').click
    end

    # 10. Verificar que el post editado aparece en la lista
    assert_text "Post editado con Navigation Drawer"
  end

  test "navegación entre diferentes secciones mantiene el drawer visible" do
    # 1. Comenzar en Posts
    visit posts_path
    assert_selector '[data-testid="nav-drawer"]'
    assert_selector '[data-testid="page-title"]', text: "Posts"

    # 2. Navegar a Vuetify Test
    within('[data-testid="nav-drawer"]') do
      find('[data-testid="nav-item-vuetify-test"]').click
    end
    assert_selector '[data-testid="nav-drawer"]'
    assert_text "¡Vuetify funcionando con Inertia!"

    # 3. Volver a Posts
    within('[data-testid="nav-drawer"]') do
      find('[data-testid="nav-item-posts"]').click
    end
    assert_selector '[data-testid="nav-drawer"]'
    assert_selector '[data-testid="page-title"]', text: "Posts"
  end

  test "drawer muestra botón de logout" do
    visit posts_path

    within('[data-testid="nav-drawer"]') do
      assert_selector '[data-testid="logout-btn"]'
      # Verificar que el botón contiene el texto (case-insensitive)
      logout_btn = find('[data-testid="logout-btn"]')
      assert logout_btn.text.upcase.include?("CERRAR"), "El botón debe contener 'Cerrar'"
      assert logout_btn.text.upcase.include?("SESIÓN") || logout_btn.text.upcase.include?("SESION"), "El botón debe contener 'Sesión'"
    end
  end

  test "botones de acción en app bar están presentes" do
    visit posts_path

    # Verificar botones en el app bar
    assert_selector '[data-testid="search-btn"]'
    assert_selector '[data-testid="notifications-btn"]'
    assert_selector '[data-testid="account-btn"]'
  end
end
