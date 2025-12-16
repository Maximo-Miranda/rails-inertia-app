require "application_system_test_case"

class VuetifyTestFormTest < ApplicationSystemTestCase
  test "página carga correctamente" do
    visit "/pages/vuetify_test"

    assert_selector "h1", text: "¡Vuetify funcionando con Inertia!"
  end

  test "diligencia campos de texto (nombre y email)" do
    visit "/pages/vuetify_test"

    fill_in "vuetify-test-name", with: "Juan Pérez"
    fill_in "vuetify-test-email", with: "juan@example.com"

    assert_field "vuetify-test-name", with: "Juan Pérez"
    assert_field "vuetify-test-email", with: "juan@example.com"
  end

  test "selecciona país en v-select" do
    visit "/pages/vuetify_test"

    find('[data-testid="vuetify-test-country"]').click
    find(".v-overlay .v-list-item", text: "Colombia").click

    assert_selector '[data-testid="vuetify-test-country"]', text: "Colombia"
  end

  test "usa autocomplete para seleccionar ciudad" do
    visit "/pages/vuetify_test"

    find('[data-testid="vuetify-test-city"]').click
    fill_in "vuetify-test-city", with: "Bog"
    find(".v-overlay .v-list-item", text: "Bogotá").click

    assert_selector '[data-testid="city-selected"]', text: "Ciudad: Bogotá"
  end

  test "marca checkbox de términos" do
    visit "/pages/vuetify_test"

    find('[data-testid="vuetify-test-terms"]').click

    assert_selector '[data-testid="terms-accepted"]', text: "Términos aceptados"
  end

  test "activa switch de notificaciones" do
    visit "/pages/vuetify_test"

    # find('label', text: "Recibir notificaciones").click
    find('[data-testid="vuetify-test-notifications"] input', visible: :all).click

    assert_selector '[data-testid="notifications-enabled"]', text: "Notificaciones activas"
  end

  test "abre y cierra accordion (expansion panels)" do
    visit "/pages/vuetify_test"

    find('[data-testid="panel-1-title"]').click
    assert_text "Aquí va la información personal"

    find('[data-testid="panel-2-title"]').click
    assert_text "Aquí van las preferencias"
  end

  test "navega entre tabs" do
    visit "/pages/vuetify_test"

    assert_text "Contenido de Tab 1"

    find('[data-testid="tab-2"]').click
    assert_text "Contenido de Tab 2"

    find('[data-testid="tab-3"]').click
    assert_text "Contenido de Tab 3"
  end

  test "abre y cierra dialog" do
    visit "/pages/vuetify_test"

    find('[data-testid="btn-open-dialog"]').click

    assert_text "Título del Dialog"
    assert_text "Este es el contenido del dialog"

    find('[data-testid="btn-close-dialog"]').click

    assert_no_text "Título del Dialog"
  end

  test "muestra y cierra snackbar" do
    visit "/pages/vuetify_test"

    find('[data-testid="btn-show-snackbar"]').click

    assert_text "¡Mensaje de snackbar exitoso!"

    find('[data-testid="btn-close-snackbar"]').click

    assert_no_text "¡Mensaje de snackbar exitoso!"
  end

  test "click en botones" do
    visit "/pages/vuetify_test"

    assert_selector '[data-testid="btn-primary"]'
    assert_selector '[data-testid="btn-secondary"]'
  end
end
