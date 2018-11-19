defmodule MicroserviceHttpEndpointElixir do
  @moduledoc """
  Demonstrates a simple HTTP endpoint using API Gateway. You have full
  access to the request and response payload, including headers and
  status code.

  TableName provided by template.yaml.

  To scan a DynamoDB table, make a GET request with optional query string parameter.
  To put, update, or delete an item, make a POST, PUT, or DELETE request respectively,
  passing in the payload to the DynamoDB API as a JSON body.
  """

  @doc """
  Lambda handler
  """
  def handle(event, context) do
    :erllambda.message("event: ~p", [event])
    :erllambda.message("context: ~p", [context])

    table_name = System.get_env("TABLE_NAME")

    result = dispatch(event["httpMethod"], event, table_name)

    {:ok, response(result)}
  end

  defp dispatch("GET", _event, table_name) do
    :erlcloud_ddb_util.scan_all(table_name)
  end

  defp dispatch("POST", %{"queryStringParameters" => item}, table_name) do
    :erlcloud_ddb2.put_item(table_name, :maps.to_list(item))
  end

  defp dispatch("DELETE", %{"queryStringParameters" => item}, table_name) do
    :erlcloud_ddb2.delete_item(table_name, :maps.to_list(item))
  end

  defp items_to_json(items) do
    items
    |> Enum.map(&:maps.from_list/1)
    |> :jiffy.encode
  end

  defp response({:ok, response}) do
    %{
      statusCode: "200",
      body: items_to_json(response),
      headers: %{
        "Content-Type": "application/json"
      }
    }
  end

  defp response({:error, response}) do
    %{
      statusCode: "400",
      body: response,
      headers: %{
        "Content-Type": "application/json"
      }
    }
  end

end
