;test regex .*?((sun|mon|tue|wed|thu|fri|sat)\s* (jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)\s+\d{0,2}\s+\d{0,4}\s+\d{0,2}\:\d{0,2}\:\d{0,2}\s+([+|-]\d{0,2}:\d{0,2})?).*?
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "s") (re.++ (str.to_re "u") (str.to_re "n"))) (re.++ (str.to_re "m") (re.++ (str.to_re "o") (str.to_re "n")))) (re.++ (str.to_re "t") (re.++ (str.to_re "u") (str.to_re "e")))) (re.++ (str.to_re "w") (re.++ (str.to_re "e") (str.to_re "d")))) (re.++ (str.to_re "t") (re.++ (str.to_re "h") (str.to_re "u")))) (re.++ (str.to_re "f") (re.++ (str.to_re "r") (str.to_re "i")))) (re.++ (str.to_re "s") (re.++ (str.to_re "a") (str.to_re "t")))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re " ") (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "a") (str.to_re "n"))) (re.++ (str.to_re "f") (re.++ (str.to_re "e") (str.to_re "b")))) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (str.to_re "r")))) (re.++ (str.to_re "a") (re.++ (str.to_re "p") (str.to_re "r")))) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (str.to_re "y")))) (re.++ (str.to_re "j") (re.++ (str.to_re "u") (str.to_re "n")))) (re.++ (str.to_re "j") (re.++ (str.to_re "u") (str.to_re "l")))) (re.++ (str.to_re "a") (re.++ (str.to_re "u") (str.to_re "g")))) (re.++ (str.to_re "s") (re.++ (str.to_re "e") (str.to_re "p")))) (re.++ (str.to_re "o") (re.++ (str.to_re "c") (str.to_re "t")))) (re.++ (str.to_re "n") (re.++ (str.to_re "o") (str.to_re "v")))) (re.++ (str.to_re "d") (re.++ (str.to_re "e") (str.to_re "c")))) (re.++ (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 0 4) (re.range "0" "9")) (re.++ (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (str.to_re ":") (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (re.+ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.opt (re.++ (re.union (str.to_re "+") (re.union (str.to_re "|") (str.to_re "-"))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (str.to_re ":") ((_ re.loop 0 2) (re.range "0" "9"))))))))))))))))))))) (re.* (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)