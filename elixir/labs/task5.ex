defmodule Task5 do
    @spec all(p::(t::any -> boolean), xs::[t::any]) :: b::boolean
    # b akkor és csak akkor igaz, ha p teljesül xs minden elemére

    def all(_, []), do: true
    def all(p?, t) do
        p?.(hd t) and all(p?, tl t)
    end
end
