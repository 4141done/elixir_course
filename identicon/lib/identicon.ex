defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  # first three values can be rgb
  # Can pattern match in arg list
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # Changed to a tuple since each has meaning
    %Identicon.Image{image | color: {r, g, b}}
  end

  # Color on even numbers, don't color on odd
end
  