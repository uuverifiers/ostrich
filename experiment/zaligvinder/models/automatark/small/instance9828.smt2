(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-z-[dfioquwz]]|[A-Z-[DFIOQUWZ]])\d([a-z-[dfioqu]]|[A-Z-[DFIOQU]])(\s)?\d([a-z-[dfioqu]]|[A-Z-[DFIOQU]])\d$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "[") (str.to_re "d") (str.to_re "f") (str.to_re "i") (str.to_re "o") (str.to_re "q") (str.to_re "u") (str.to_re "w") (str.to_re "z")) (str.to_re "]")) (re.++ (re.union (re.range "A" "Z") (str.to_re "-") (str.to_re "[") (str.to_re "D") (str.to_re "F") (str.to_re "I") (str.to_re "O") (str.to_re "Q") (str.to_re "U") (str.to_re "W") (str.to_re "Z")) (str.to_re "]"))) (re.range "0" "9") (re.union (re.++ (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "[") (str.to_re "d") (str.to_re "f") (str.to_re "i") (str.to_re "o") (str.to_re "q") (str.to_re "u")) (str.to_re "]")) (re.++ (re.union (re.range "A" "Z") (str.to_re "-") (str.to_re "[") (str.to_re "D") (str.to_re "F") (str.to_re "I") (str.to_re "O") (str.to_re "Q") (str.to_re "U")) (str.to_re "]"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (re.union (re.++ (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "[") (str.to_re "d") (str.to_re "f") (str.to_re "i") (str.to_re "o") (str.to_re "q") (str.to_re "u")) (str.to_re "]")) (re.++ (re.union (re.range "A" "Z") (str.to_re "-") (str.to_re "[") (str.to_re "D") (str.to_re "F") (str.to_re "I") (str.to_re "O") (str.to_re "Q") (str.to_re "U")) (str.to_re "]"))) (re.range "0" "9") (str.to_re "\u{0a}"))))
; [^A-Za-z0-9]
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Log[^\n\r]*Host\x3A\dHOST\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Log") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.range "0" "9") (str.to_re "HOST:User-Agent:\u{0a}"))))
; ^(GB)?([0-9]{9})$
(assert (str.in_re X (re.++ (re.opt (str.to_re "GB")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (\$\s*[\d,]+\.\d{2})\b
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}$") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (str.to_re ","))) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))
(check-sat)
