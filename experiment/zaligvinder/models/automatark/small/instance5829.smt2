(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]+(([\'\,\.\- ][a-zA-Z ])?[a-zA-Z]*)*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (re.opt (re.++ (re.union (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "-") (str.to_re " ")) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re " ")))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
; User-Agent\u{3a}\w+Owner\x3A
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:\u{0a}"))))
; User-Agent\u{3a}[^\n\r]*Echelon.*Blacksnprtz\x7CdialnoSearch
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Echelon") (re.* re.allchar) (str.to_re "Blacksnprtz|dialnoSearch\u{0a}"))))
; ^\S{2}\d{7}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
