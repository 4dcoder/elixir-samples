defmodule GettingStartedElixir.DatastoreRepo do

  def insert(%{valid?: false} = changeset), do: {:error, changeset}
  def insert(%{data: %{id: id, __meta__: %{source: {_, entity_name}}} = data, changes: changes}) do
    changes
    |> Diplomat.Entity.new(entity_name, id)
    |> Diplomat.Entity.insert

    {:ok, Map.merge(data, changes)}
  end

  def get(mod, id, opts \\ []) do
    Diplomat.Key.new(mod.__schema__(:source), id)
    |> Diplomat.Key.get()
    |> Enum.at(0)
    |> into_struct(mod)
  end

  defp into_struct(%Diplomat.Entity{key: %{name: id}, properties: properties}, mod) do
    data = Enum.map(properties, fn {k, %{value: v}} -> {k, v} end)
    |> Enum.into(%{})
    |> Poison.Decode.decode(as: struct(mod))
    |> Map.put(:id, id)
  end

  def update(%{valid?: false} = changeset), do: {:error, changeset}
  def update(%{data: %{id: id, __meta__: %{source: {_, entity_name}}} = data, changes: changes}) do
    results = data
    |> Map.take(data.__struct__.__schema__(:fields))
    |> Map.merge(changes)

    entity = Diplomat.Entity.new(results, entity_name, id)

    Diplomat.Transaction.begin
    |> Diplomat.Transaction.update(entity)
    |> Diplomat.Transaction.commit

    {:ok, results}
  end

  def delete(%{data: data}), do: delete(data)
  def delete(%{id: id, __meta__: %{source: {_, entity_name}}}) do
    key = Diplomat.Key.new(entity_name, id)

    Diplomat.Transaction.begin
    |> Diplomat.Transaction.delete(key)
    |> Diplomat.Transaction.commit
  end

  def all(queryable, opts \\ []) do
    select = select(queryable)
    from = from(queryable)
    where = where(queryable)
    order_by = order_by(queryable)
    limit = limit(queryable)
    offset = offset(queryable)

    [select, from, where, order_by, limit, offset]
    |> IO.iodata_to_binary()
    |> Diplomat.Query.new()
    |> Diplomat.Query.execute()
  end

  defp select(_queryable), do: "SELECT *"
  defp from(queryable), do: [" FROM `", elem(queryable.from, 0), "`"]
  defp where(_queryable), do: []
  defp order_by(%{order_bys: order_bys}) do
    [" ORDER BY " |
      intersperse_map(order_bys, ", ", fn %{expr: expr} ->
        intersperse_map(expr, ", ", &order_by_expr/1)
      end)
    ]
  end
  defp order_by_expr({dir, expr}) do
    {{_, [], [_, field]}, _, _} = expr
    str = "`#{field}`"
    case dir do
      :asc  -> str
      :desc -> [str | " DESC"]
    end
  end

  defp limit(%{limit: %{expr: limit}}), do: " LIMIT #{limit}"
  defp limit(_), do: []
  defp offset(%{offset: %{expr: offset}}), do: " OFFSET #{offset}"
  defp offset(_), do: []

  defp intersperse_map(list, separator, mapper, acc \\ [])
  defp intersperse_map([], _separator, _mapper, acc),
    do: acc
  defp intersperse_map([elem], _separator, mapper, acc),
    do: [acc | mapper.(elem)]
  defp intersperse_map([elem | rest], separator, mapper, acc),
    do: intersperse_map(rest, separator, mapper, [acc, mapper.(elem), separator])
end
