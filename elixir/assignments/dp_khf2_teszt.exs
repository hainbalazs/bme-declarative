s0 = IO.inspect(Khf2.szovegelo "khf2_s0.txt") ===
       []

s1 = IO.inspect(Khf2.szovegelo "khf2_s1.txt") ===
       [["."]]

s2 = IO.inspect(Khf2.szovegelo "khf2_s2.txt") ===
       [
         ["---", "%%%", "7", "(())", "$$$$", "***", nil, nil, nil, nil],
         ["===", "!!!!!", "\"\"\"\"", "'''", nil, nil, nil, nil, nil, nil],
         ["..", "??", "@@", "&&", "##", "<<", "...", ">>", "bla", "BlaBla"]
       ]

s3 = IO.inspect(Khf2.szovegelo "khf2_s3.txt") ===
       [["itt", "a", "vége", ":", "fuss", "el", "véle!"]]

s4 = IO.inspect(Khf2.szovegelo "khf2_s4.txt") ===
       [
         ["Lakott", "egy", "kisbaba", "Vácott,", nil],
         ["folyton", "a", "macskával", "játszott.", nil],
         ["Kapott", "egy", "plüsst:", nil, nil],
         ["\"Inkább", "ezt", "üsd!\"", nil, nil],
         ["Azt", "hitték,", "arra", "majd", "átszok..."]
       ]

t1 = IO.inspect(Khf2.szovegelo "khf2_t1.txt") === elem((File.read! "khf2_m1.txt") |> Code.eval_string, 0)
t2 = IO.inspect(Khf2.szovegelo "khf2_t2.txt") === elem((File.read! "khf2_m2.txt") |> Code.eval_string, 0)
t3 = IO.inspect(Khf2.szovegelo "khf2_t3.txt") === elem((File.read! "khf2_m3.txt") |> Code.eval_string, 0)

IO.puts "#{s0}, #{s1}, #{s2}, #{s3}, #{s4}"
IO.puts "#{t1}, #{t2}, #{t3}"
