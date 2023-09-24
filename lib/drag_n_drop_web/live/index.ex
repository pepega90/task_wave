defmodule DragNDropWeb.DragNDropLive.Index do
  use DragNDropWeb, :live_view



  @impl true
  def render(assigns) do
    ~H"""
        <div style="width:350px;" class="ml-4 flex-shrink-0 flex flex-col w-36 bg-gray-100 rounded-md">
              <h3 class="flex-shrink-0 pt-3 pb-1 px-3 text-sm font-medium text-gray-900">Todo</h3>
              <div class="flex-1 min-h-0 overflow-y-auto">
                <%!-- TODO DRAG --%>
                  <ul class="pt-1 pb-3 px-3" phx-hook="Drag" id="drag">
                    <div class="dropzone" id="todo_zone">
                      <%= for d <- @todo_zone do %>
                        <li draggable="true" class="mt-3 draggable" phx-value-id={d.id} phx-value-zone="todo_zone" phx-click="open_modal" id={d.id}>
                          <a href="#" class="block p-5 bg-white rounded-md shadow">
                            <div class="flex justify-between">
                              <p class="text-sm font-medium leading-snug text-gray-900"><%= d.text %></p>
                            </div>

                          </a>
                        </li>
                      <% end %>
                    </div>
                  </ul>
                <%!-- END TODO DRAG --%>
              </div>
            </div>

            <div style="width:350px;" class="ml-4 flex-shrink-0 flex flex-col w-36 bg-gray-100 rounded-md">
              <h3 class="flex-shrink-0 pt-3 pb-1 px-3 text-sm font-medium text-gray-900">In Progress</h3>
              <div class="flex-1 min-h-0 overflow-y-auto">
                <ul class="pt-1 pb-3 px-3">
                  <%!-- IN PROGRESS DRAG --%>
                    <ul class="pt-1 pb-3 px-3">
                      <div class="dropzone" id="progress_zone">
                          <%= for d <- @progress_zone do %>
                            <li draggable="true" class="mt-3 draggable" phx-value-id={d.id} phx-value-zone="progress_zone" phx-click="open_modal" id={d.id}>
                              <a href="#" class="block p-5 bg-white rounded-md shadow">
                                <div class="flex justify-between">
                                  <p class="text-sm font-medium leading-snug text-gray-900"><%= d.text %></p>
                                </div>
                                <div class="flex justify-between mt-5">
                                  <div class="text-sm text-gray-600"><time datetime="2020-10-12">Sep 17</time></div>
                                </div>
                              </a>
                            </li>
                          <% end %>
                        </div>
                    </ul>
                    <%!-- END IN PROGRESS DRAG --%>
                </ul>
              </div>
            </div>

            <div style="width:350px;" class="ml-4 flex-shrink-0 flex flex-col w-36 bg-gray-100 rounded-md">
              <h3 class="flex-shrink-0 pt-3 pb-1 px-3 text-sm font-medium text-gray-900">Done</h3>
              <div class="flex-1 min-h-0 overflow-y-auto">
                  <%!-- DONE DRAG --%>
                  <ul class="pt-1 pb-3 px-3">
                    <div class="dropzone" id="done_zone">
                      <%= for d <- @done_zone do %>
                        <li draggable="true" class="mt-3 draggable" phx-value-id={d.id} phx-value-zone="done_zone" phx-click="open_modal" id={d.id}>
                          <a href="#" class="block p-5 bg-white rounded-md shadow">
                            <div class="flex justify-between">
                              <p class="text-sm font-medium leading-snug text-gray-900"><%= d.text %></p>
                            </div>

                          </a>
                        </li>
                      <% end %>
                      </div>
                    </ul>
                  <%!-- END DONE DRAG --%>
              </div>
            </div>


            <%= if @selected != %{} do %>
            <%!-- MODAL --%>
              <div class="fixed inset-0 flex items-center justify-center z-50" class={if @open, do: "", else: "hidden"}>
                  <div phx-click="close_modal" class="modal-overlay absolute w-full h-full bg-gray-900 opacity-50"></div>

                  <div class="p-4 modal-container bg-white w-11/12 md:max-w-md mx-auto rounded shadow-lg z-50 overflow-y-auto">
                      <!-- Modal Header -->
                      <div class="modal-header">
                          <h2 class="text-2xl font-semibold"><%= @selected[:text] %></h2>
                      </div>
                      <hr/>
                      <!-- Modal Body -->
                      <div class="modal-body p-4">
                          <p><%= @selected[:desc] %></p>

                          <!-- Comment Section -->
                          <div class="mt-5 h-64 overflow-auto">
                              <h3 class="text-xl font-semibold mb-2">Comments</h3>
                              <ul class="space-y-2">
                                  <%= for c <- @selected[:comments] do %>
                                    <li class="flex items-center border-b border-gray-200 py-2">
                                        <div class="flex ml-3 justify-between items-center w-full">
                                            <div>
                                              <p class="text-gray-700"><%= c.nama %></p>
                                              <p class="text-gray-500 text-sm"><%= c.komen %></p>
                                            </div>
                                            <p class="text-gray-700"><%= c.waktu %></p>
                                        </div>
                                        <%!-- <div class="ml-3">
                                            <p class="text-gray-500 text-sm"><%= c.komen %></p>
                                        </div> --%>
                                    </li>
                                  <% end %>
                              </ul>
                          </div>

                          <!-- Add Comment Form -->
                          <form phx-hook="Komen" id="komen" sid={@selected[:id]} zone={@select_zone}>
                          <%!-- <form phx-submit="komen" phx-value-id={@selected[:id]} phx-value-zone={@select_zone}> --%>
                            <div class="mt-4">
                                  <input class="w-full p-2 border border-gray-300 rounded" name="comment" placeholder="Write your comment" />
                            </div>
                          </form>
                      </div>

                  </div>
              </div>
            <%!-- END MODAL --%>
            <% end %>
    """
  end

  @topic "jira"

  @impl true
  def mount(%{"nama" => user} = _params, _session, socket) do
    if connected?(socket), do: DragNDropWeb.Endpoint.subscribe(@topic)
    {:ok, socket
    |> assign(
      todo_zone: [],
      progress_zone: [],
      done_zone: [],
      open: false,
      selected: %{},
      select_zone: "",
      username: user,
      new_task: false
    )}
  end

  @impl true
  def handle_event("new", _params, socket), do: {:noreply, socket |> assign(new_task: true)}
  def handle_event("close_create", _params, socket), do: {:noreply, socket |> assign(new_task: false)}
  def handle_event("close_modal", _params, socket), do: {:noreply, socket |> assign(open: false, selected: %{}, select_zone: "")}

  def handle_event("add", %{"title" => val, "desc" => desc ,"pilih" => choice} = _params, %{assigns: %{todo_zone: todo, progress_zone: prog, done_zone: done}} = socket) do
    data = %{
      id: length(todo ++ prog ++ done) + 1 |> to_string,
      text: val,
      desc: desc,
      comments: [],
    }

    DragNDropWeb.Endpoint.broadcast(@topic, "new", %{data: data, choice: choice})

    {:noreply, socket |> assign(new_task: false)}
  end

  def handle_event("open_modal", %{"id" => id, "zone" => zone} = _params, %{assigns: assigns} = socket) do
    atom_zone = zone |> String.to_atom
    select_item = assigns[atom_zone] |> Enum.find(fn e -> e.id == id end)

    {:noreply, socket |> assign(open: true, selected: select_item, select_zone: zone)}
  end

  def handle_event("komen", %{"comment" => komen, "id" => id, "zone" => zone, "time" => current_time} = _params, %{assigns: assigns} = socket) do
    # replace at index, gunakan cara yang sama waktu bikin todolist liveview
    atom_zone = zone |> String.to_atom
    idx_drag = assigns[atom_zone] |> Enum.find_index(fn e -> e.id == id end)
    update_item = assigns[atom_zone] |> Enum.at(idx_drag) |> Map.update!(:comments, fn c -> [%{komen: komen, nama: assigns[:username], waktu: current_time} | c] end)
    update_zone = assigns[atom_zone] |> List.replace_at(idx_drag, update_item)

    DragNDropWeb.Endpoint.broadcast(@topic, "broad_comment", %{zone: zone, data: update_zone, selected: update_item})

    {:noreply, socket}
  end

  def handle_event("dropped", %{"dragId" => dragId, "draggableIndex" => dragIdx, "dropzoneId" => dropzone} = _params, %{assigns: assigns} = socket) do
    # disini, kita mencari item yang ingin kita drag, itu berada di zone mana
    drop_zone_atom =
      [:todo_zone, :progress_zone, :done_zone]
      |> Enum.find(fn zone_atom -> to_string(zone_atom) == dropzone end)

    if drop_zone_atom == nil do
      throw "invalid drop_zone_id"
    end

    # disini kita cari item  yang sedang kita drag
    drag_item = find_dragged(assigns, dragId)

    # disini kita broadcast, data ke sebuah event bernama "udpate_card", untuk mengupdate list ke sluruh client yang subscribe topic-nya
    DragNDropWeb.Endpoint.broadcast(@topic, "update_card", %{drag_item: drag_item, drop_zone_atom: drop_zone_atom, dragIdx: dragIdx})

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{topic: @topic, event: "broad_comment", payload: %{zone: zone, data: update_zone, selected: update_item}}, socket) do
    case zone do
      "todo_zone" ->
        {:noreply, socket |> assign(todo_zone: update_zone, selected: update_item)}
      "progress_zone" ->
        {:noreply, socket |> assign(progress_zone: update_zone, selected: update_item)}
      "done_zone" ->
        {:noreply, socket |> assign(done_zone: update_zone, selected: update_item)}
    end
  end

  def handle_info(%{topic: @topic, event: "new", payload: %{data: data, choice: choice}}, %{assigns: %{todo_zone: todo, progress_zone: prog, done_zone: done}} = socket) do
    case choice do
      "todo" ->
        {:noreply, socket |> assign(todo_zone: [data | todo])}
      "prog" ->
        {:noreply, socket |> assign(progress_zone: [data | prog])}
      "done" ->
        {:noreply, socket |> assign(done_zone: [data | done])}
    end
  end

  def handle_info(%{topic: @topic, event: "update_card", payload: %{drag_item: drag_item, drop_zone_atom: drop_zone_atom, dragIdx: dragIdx}}, socket) do
    # disini kita akan melakukan  update state, menggunakan Enum.reduce/3
    # socket kita jadikan sebagai accumulator, lalu di anon function kita destruct property assigns
    socket =
      [:todo_zone, :progress_zone, :done_zone]
      |> Enum.reduce(socket, fn zone_atom, %{assigns: assigns} = acc ->
        updated_list =
          assigns
            |> update_list(zone_atom, drag_item, drop_zone_atom, dragIdx)

          acc
            |> assign(zone_atom, updated_list)
      end)

    {:noreply, socket}
  end

  # find dragged item
  defp find_dragged(%{todo_zone: todo, progress_zone: prog, done_zone: done}, dragged_id) do
    # kita gabung seluruh zone, dan cari item yang sedang kita drag
    todo ++ prog ++ done
      |> Enum.find(fn e -> e.id == dragged_id end)
  end

  # function di bawah, dimana kita menupdate list dari item yang kita drag, ke list dimana tempat item yang akan kita drop
  def update_list(assigns, list_atom, dragged, drop_zone_atom, draggable_index) when list_atom == drop_zone_atom  do
    assigns[list_atom]
      |> remove_dragged(dragged.id)
      |> List.insert_at(draggable_index, dragged)
  end

  def update_list(assigns, list_atom, dragged, drop_zone_atom, _draggable_index) when list_atom != drop_zone_atom  do
    assigns[list_atom]
    |> remove_dragged(dragged.id)
  end

  # disini kita, ketika kita drag dari 1 zone ke zone lain, maka kita hapus zone previous si item. sebelum di add ke zone yang baru
  def remove_dragged(list, dragged_id) do
    list
      |> Enum.filter(fn draggable ->
      draggable.id != dragged_id
    end)
  end

end
