defmodule Planatlas.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Planatlas.Documents.Permalink, autogenerate: true}
  
  schema "documents" do
    field :description, :string
    field :title, :string
    field :file, :map
    field :slug, :string
    has_many :annotations, Planatlas.Documents.Annotation
    has_many :users_documents, Planatlas.Accounts.UserDocument

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:title, :description, :file])
    |> validate_required([:title, :description])
    |> slugify_title()
  end

  def add_blank_json_document(document) do
    file = %{file: default_file}

    document
    |> cast(file, [:file])
  end

  defp slugify_title(changeset) do
    case fetch_change(changeset, :title) do
      {:ok, new_title} -> put_change(changeset, :slug, slugify(new_title))
      :error -> changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  defp default_file do
    %{
      "categories" => %{},
      "globalSettings" => %{
        "chargeStrength" => "-700",
        "checkedAttrs" => ["linkDistance"],
        "controls" => %{
          "radiusRangeMax" => %{"customValue" => 2833, "defaultValue" => 2000},
          "fontSizeRangeMax" => %{"customValue" => nil, "defaultValue" => 500}
        },
        "defaults" => %{
          "bgColor" => "powderblue",
          "fontSize" => 30,
          "goToEditNodePageWhenNodeIsClicked" => true,
          "linkDistance" => 300,
          "nodeColor" => "blue",
          "nodeHoverColor" => "green",
          "radius" => 30,
          "sideMenuOpenOnInit" => true
        },
        "fontSize" => nil,
        "general" => %{
          "chargeStrength" => %{"customValue" => "-700", "defaultValue" => "-700"},
          "linkDistance" => %{"customValue" => "505", "defaultValue" => "505"}
        },
        "linkDistance" => "505",
        "node" => %{
          "checkedAttrs" => [],
          "fontSize" => %{"customValue" => nil, "defaultValue" => 50},
          "radius" => %{"customValue" => nil, "defaultValue" => 30},
          "name" => %{"customValue" => nil, "defaultValue" => "new node"},
          "radiusRangeMax" => %{"customValue" => nil, "defaultValue" => 1000}
        },
        "radius" => nil,
        "radiusRangeMax" => 756,
        "zoom" => %{
          "k" => 0.4079329796515761,
          "x" => 2031.315035870646,
          "y" => 3907.9446603136703
        }
      },
      "links" => [
        %{
          "index" => 0,
          "source" => "af0f8b50-dffd-47cf-a936-1b2627628e53",
          "target" => "2fc4ce12-b49c-4590-a6dc-afc361320e85"
        },
        %{
          "index" => 1,
          "source" => "2fc4ce12-b49c-4590-a6dc-afc361320e85",
          "target" => "ee37261b-e659-4e68-91a6-a6846422e476"
        },
        %{
          "index" => 2,
          "source" => "ee37261b-e659-4e68-91a6-a6846422e476",
          "target" => "af0f8b50-dffd-47cf-a936-1b2627628e53"
        }
      ],
      "nodes" => [
        %{
          "bbox" => %{},
          "customAttrs" => %{"fontSize" => "150", "radius" => 397, "name" => "new"},
          "fx" => -4431.874529348066,
          "fy" => -8603.301490308226,
          "globalSettings" => %{
            "checkedAttrs" => [],
            "fontSize" => %{"customValue" => nil, "defaultValue" => 50},
            "name" => %{"customValue" => nil, "defaultValue" => 'new node'},
            "radius" => %{"customValue" => nil, "defaultValue" => 30},
            "radiusRangeMax" => %{"customValue" => nil, "defaultValue" => 1000}
          },
          "id" => "af0f8b50-dffd-47cf-a936-1b2627628e53",
          "index" => 0,
          "sticky" => true,
          "tempCustomAttrs" => %{"fontSize" => "150", "radius" => 397},
          "vx" => 0,
          "vy" => 0,
          "x" => -4431.874529348066,
          "y" => -8603.301490308226
        },
        %{
          "bbox" => %{},
          "customAttrs" => %{"name" => "asdf"},
          "fx" => -3870.382289679577,
          "fy" => -9410.482139214966,
          "globalSettings" => %{
            "checkedAttrs" => [],
            "fontSize" => %{"customValue" => nil, "defaultValue" => 50},
            "name" => %{"customValue" => nil, "defaultValue" => 'new node'},
            "radius" => %{"customValue" => nil, "defaultValue" => 30},
            "radiusRangeMax" => %{"customValue" => nil, "defaultValue" => 1000}
          },
          "id" => "ee37261b-e659-4e68-91a6-a6846422e476",
          "index" => 1,
          "sticky" => true,
          "vx" => 0,
          "vy" => 0,
          "x" => -3870.382289679577,
          "y" => -9410.482139214966
        },
        %{
          "bbox" => %{},
          "customAttrs" => %{"radius" => 667, "name" => "123"},
          "fx" => -3024.315433950241,
          "fy" => -8543.611727222364,
          "globalSettings" => %{
            "checkedAttrs" => [],
            "fontSize" => %{"customValue" => nil, "defaultValue" => 50},
            "name" => %{"customValue" => nil, "defaultValue" => "new node"},
            "radius" => %{"customValue" => nil, "defaultValue" => 30},
            "radiusRangeMax" => %{"customValue" => nil, "defaultValue" => 1000}
          },
          "id" => "2fc4ce12-b49c-4590-a6dc-afc361320e85",
          "index" => 2,
          "sticky" => true,
          "vx" => 0,
          "vy" => 0,
          "x" => -3024.315433950241,
          "y" => -8543.611727222364
        }
      ]
    }
  end
end
