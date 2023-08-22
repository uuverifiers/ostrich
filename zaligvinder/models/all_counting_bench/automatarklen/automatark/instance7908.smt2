(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [\w\-_\+\(\)]{0,}[\.png|\.PNG]{4}
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "-") (str.to_re "_") (str.to_re "+") (str.to_re "(") (str.to_re ")") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 4 4) (re.union (str.to_re ".") (str.to_re "p") (str.to_re "n") (str.to_re "g") (str.to_re "|") (str.to_re "P") (str.to_re "N") (str.to_re "G"))) (str.to_re "\u{0a}"))))
; ^[a-zA-Z]+(([\'\,\.\- ][a-zA-Z ])?[a-zA-Z]*)*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (re.opt (re.++ (re.union (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "-") (str.to_re " ")) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re " ")))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}k3g/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".k3g/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
